-- ============================================================
-- NiyyahLy Product Analytics
-- Stage 8: 30-Day Post-Activation Engagement
-- File: 02_30d_engagement_analysis.sql
--
-- Query 1:
-- Retrieve distinct journal-active days for activated users.
--
-- Purpose:
-- Establish the user-level activity dates needed to calculate:
-- 1. Active journal days
-- 2. Longest journal streak
-- 3. Active weeks
-- ============================================================


WITH activated_users AS (

  SELECT

    user_id,
    first_journal_saved_at

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  WHERE
    activated = TRUE
),

journal_days AS (

  SELECT DISTINCT

    u.user_id,

    DATE(e.event_timestamp) AS journal_date

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
)

SELECT

  user_id,
  journal_date

FROM
  journal_days

ORDER BY
  user_id,
  journal_date;

-- ============================================================
-- QUERY 2: Longest Journal Streak
-- ============================================================
--
-- Business question:
-- Do activated users develop consecutive journaling behavior
-- during the 30 days following activation?
--
-- Metric:
-- Longest number of consecutive calendar days on which
-- the user saved at least one journal.
-- ============================================================


WITH activated_users AS (

  SELECT

    user_id,
    first_journal_saved_at

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  WHERE
    activated = TRUE
),

journal_days AS (

  SELECT DISTINCT

    u.user_id,

    DATE(e.event_timestamp) AS journal_date

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
)

SELECT

  user_id,

  MAX(streak_length) AS longest_journal_streak_30d

FROM
  streak_lengths

GROUP BY
  user_id

ORDER BY
  user_id;

-- ============================================================
-- QUERY 3: Post-Activation Consistency Periods
-- ============================================================
--
-- Business question:
-- Did activated users continue journaling across different
-- parts of the 30-day period after activation?
--
-- The 30-day period is divided into four user-relative periods:
--
-- Period 1 = Days 1-7
-- Period 2 = Days 8-14
-- Period 3 = Days 15-21
-- Period 4 = Days 22-30
--
-- Metric:
-- Number of the four periods containing at least one
-- journal_saved event.
-- ============================================================


WITH activated_users AS (

  SELECT

    user_id,
    first_journal_saved_at

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  WHERE
    activated = TRUE
),

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
)

SELECT

  user_id,

  COUNT(*) AS active_consistency_periods_30d

FROM
  period_activity

GROUP BY
  user_id

ORDER BY
  user_id;
