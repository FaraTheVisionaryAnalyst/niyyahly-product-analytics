-- ============================================================
-- NiyyahLy Product Analytics
-- Stage 8: 30-Day Post-Activation Engagement
-- File: 01_create_mart_30d_post_activation.sql
--
-- Purpose:
-- Measure continued journal engagement among activated users
-- during the 30 days following activation.
--
-- Population:
-- Activated users only.
--
-- Engagement event:
-- journal_saved
--
-- Metrics:
-- 1. journal_active_days_30d
--    Number of distinct days with at least one journal save.
--
-- 2. longest_journal_streak_30d
--    Longest number of consecutive journal-active days.
--
-- 3. active_consistency_periods_30d
--    Number of four post-activation periods containing
--    at least one journal-active day:
--
--      Period 1 = Days 1-7
--      Period 2 = Days 8-14
--      Period 3 = Days 15-21
--      Period 4 = Days 22-30
--
-- Important:
-- Activation day is Day 0 and is excluded from all
-- post-activation engagement metrics.
--
-- Grain:
-- One row per activated user.
-- ============================================================


CREATE OR REPLACE TABLE
`niyyahly-product-analytics.niyyahly_analytics.mart_30d_post_activation` AS

WITH activated_users AS (

  SELECT

    user_id,
    signup_date,
    cohort,
    onboarding_version,
    onboarding_path,
    knows_mbti,
    platform,

    signup_completed_at,
    onboarding_completed_at,
    first_journal_saved_at

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  WHERE
    activated = TRUE
),


-- ============================================================
-- Get one row per user per journal-active calendar day
-- during the 30 days following activation.
-- ============================================================

journal_days AS (

  SELECT DISTINCT

    u.user_id,

    DATE(e.event_timestamp) AS journal_date,

    DATE_DIFF(
      DATE(e.event_timestamp),
      DATE(u.first_journal_saved_at),
      DAY
    ) AS days_since_activation

  FROM
    activated_users u

  INNER JOIN
    `niyyahly-product-analytics.niyyahly_analytics.facts_events` e

  ON
    u.user_id = e.user_id

  WHERE
    e.event_name = 'journal_saved'

    AND DATE_DIFF(
      DATE(e.event_timestamp),
      DATE(u.first_journal_saved_at),
      DAY
    ) BETWEEN 1 AND 30
),


-- ============================================================
-- Metric 1:
-- Number of distinct journal-active days.
-- ============================================================

active_day_counts AS (

  SELECT

    user_id,

    COUNT(*) AS journal_active_days_30d

  FROM
    journal_days

  GROUP BY
    user_id
),


-- ============================================================
-- Prepare journal dates for streak calculation.
-- Consecutive dates will be placed into the same streak group.
-- ============================================================

numbered_days AS (

  SELECT

    user_id,
    journal_date,

    ROW_NUMBER() OVER (
      PARTITION BY user_id
      ORDER BY journal_date
    ) AS day_number

  FROM
    journal_days
),


streak_groups AS (

  SELECT

    user_id,
    journal_date,

    DATE_SUB(
      journal_date,
      INTERVAL day_number DAY
    ) AS streak_group

  FROM
    numbered_days
),


streak_lengths AS (

  SELECT

    user_id,
    streak_group,

    COUNT(*) AS streak_length

  FROM
    streak_groups

  GROUP BY
    user_id,
    streak_group
),


-- ============================================================
-- Metric 2:
-- Longest consecutive journal streak.
-- ============================================================

longest_streaks AS (

  SELECT

    user_id,

    MAX(streak_length) AS longest_journal_streak_30d

  FROM
    streak_lengths

  GROUP BY
    user_id
),


-- ============================================================
-- Metric 3:
-- Determine which of the four post-activation periods
-- contain journal activity.
--
-- Period 1 = Days 1-7
-- Period 2 = Days 8-14
-- Period 3 = Days 15-21
-- Period 4 = Days 22-30
-- ============================================================

period_activity AS (

  SELECT

    user_id,

    CASE

      WHEN days_since_activation BETWEEN 1 AND 7
        THEN 1

      WHEN days_since_activation BETWEEN 8 AND 14
        THEN 2

      WHEN days_since_activation BETWEEN 15 AND 21
        THEN 3

      WHEN days_since_activation BETWEEN 22 AND 30
        THEN 4

    END AS consistency_period

  FROM
    journal_days

  GROUP BY
    user_id,
    consistency_period
),


active_period_counts AS (

  SELECT

    user_id,

    COUNT(*) AS active_consistency_periods_30d

  FROM
    period_activity

  GROUP BY
    user_id
)


-- ============================================================
-- Final user-level mart
--
-- LEFT JOIN ensures that activated users who have no
-- post-activation journal activity remain in the table.
--
-- Their engagement metrics are assigned 0.
-- ============================================================

SELECT

  u.user_id,

  u.signup_date,
  u.cohort,
  u.onboarding_version,
  u.onboarding_path,
  u.knows_mbti,
  u.platform,

  u.signup_completed_at,
  u.onboarding_completed_at,
  u.first_journal_saved_at,

  COALESCE(
    a.journal_active_days_30d,
    0
  ) AS journal_active_days_30d,

  COALESCE(
    s.longest_journal_streak_30d,
    0
  ) AS longest_journal_streak_30d,

  COALESCE(
    p.active_consistency_periods_30d,
    0
  ) AS active_consistency_periods_30d

FROM
  activated_users u

LEFT JOIN
  active_day_counts a

ON
  u.user_id = a.user_id

LEFT JOIN
  longest_streaks s

ON
  u.user_id = s.user_id

LEFT JOIN
  active_period_counts p

ON
  u.user_id = p.user_id;
