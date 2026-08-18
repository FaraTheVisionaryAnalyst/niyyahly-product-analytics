-- ============================================================
-- NiyyahLy Product Analytics
-- Stage 7: Retention Analysis
-- File: 01_create_mart_retention.sql
--
-- Purpose:
-- Build a user-level retention mart measuring whether
-- ACTIVATED users return and save a journal after activation.
--
-- Retention population:
-- Activated users only.
--
-- Activation definition:
-- First journal_saved event.
--
-- Retention windows:
-- D1, D7, D14, D30 after activation.
--
-- Important:
-- Activation day = Day 0.
-- D1 = calendar day immediately after activation.
-- D7 = seven calendar days after activation.
-- D14 = fourteen calendar days after activation.
-- D30 = thirty calendar days after activation.
--
-- Important distinction:
-- Milestone retention measures whether a user was active
-- on a specific day.
--
-- It does NOT measure:
-- - number of journals saved
-- - number of active days
-- - continuous usage
-- - a 30-day streak
--
-- Continuous post-activation engagement is measured separately
-- in mart_30d_post_activation.
--
-- Grain:
-- One row per activated user.
-- ============================================================


CREATE OR REPLACE TABLE
`niyyahly-product-analytics.niyyahly_analytics.mart_retention` AS


-- ============================================================
-- STEP 1
-- Define the retention population.
--
-- Only activated users are included.
-- Activation is based on first_journal_saved_at from
-- mart_activation.
-- ============================================================

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
    first_journal_saved_at,

    DATE(first_journal_saved_at) AS activation_date

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  WHERE
    activated = TRUE
),


-- ============================================================
-- STEP 2
-- Get one row per user per calendar day on which the user
-- saved at least one journal.
--
-- Multiple journal_saved events on the same date count as
-- one active day.
-- ============================================================

journal_activity AS (

  SELECT DISTINCT

    e.user_id,

    DATE(e.event_timestamp) AS activity_date

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events` e

  WHERE
    e.event_name = 'journal_saved'
),


-- ============================================================
-- STEP 3
-- Calculate the number of days between activation and
-- subsequent journal activity.
--
-- Activation day = Day 0.
--
-- Only activity from D1 through D30 is relevant to this mart.
-- ============================================================

retention_activity AS (

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
    u.activation_date,

    j.activity_date,

    DATE_DIFF(
      j.activity_date,
      u.activation_date,
      DAY
    ) AS days_since_activation

  FROM
    activated_users u

  INNER JOIN
    journal_activity j

  ON
    u.user_id = j.user_id

  WHERE

    DATE_DIFF(
      j.activity_date,
      u.activation_date,
      DAY
    ) BETWEEN 1 AND 30
),


-- ============================================================
-- STEP 4
-- Create retention flags.
--
-- A user is retained at a milestone if they saved at least
-- one journal on that exact calendar day after activation.
-- ============================================================

retention_flags AS (

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
    u.activation_date,

    MAX(
      CASE
        WHEN r.days_since_activation = 1
        THEN 1
        ELSE 0
      END
    ) AS retained_d1,

    MAX(
      CASE
        WHEN r.days_since_activation = 7
        THEN 1
        ELSE 0
      END
    ) AS retained_d7,

    MAX(
      CASE
        WHEN r.days_since_activation = 14
        THEN 1
        ELSE 0
      END
    ) AS retained_d14,

    MAX(
      CASE
        WHEN r.days_since_activation = 30
        THEN 1
        ELSE 0
      END
    ) AS retained_d30

  FROM
    activated_users u

  LEFT JOIN
    retention_activity r

  ON
    u.user_id = r.user_id

  GROUP BY

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
    u.activation_date
)


-- ============================================================
-- FINAL USER-LEVEL RETENTION MART
-- ============================================================

SELECT

  *

FROM
  retention_flags;
