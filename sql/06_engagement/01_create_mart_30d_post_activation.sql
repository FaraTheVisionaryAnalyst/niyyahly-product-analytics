-- ============================================================
-- NiyyahLy Product Analytics
-- Stage 8: 30-Day Post-Activation Engagement
-- File: 01_create_mart_30d_post_activation.sql
--
-- Purpose:
-- Measure how consistently activated users engage with
-- NiyyahLy during the first 30 days after activation.
--
-- Population:
-- Activated users only.
--
-- Engagement event:
-- journal_saved
--
-- Main metric:
-- Number of distinct calendar days on which an activated
-- user saved at least one journal during the 30 days
-- following activation.
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

journal_activity AS (

  SELECT DISTINCT

    e.user_id,

    DATE(e.event_timestamp) AS activity_date

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events` e

  WHERE
    e.event_name = 'journal_saved'
),

engagement AS (

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

    COUNT(
      DISTINCT
      CASE
        WHEN DATE_DIFF(
          j.activity_date,
          DATE(u.first_journal_saved_at),
          DAY
        ) BETWEEN 1 AND 30
        THEN j.activity_date
      END
    ) AS journal_active_days_30d

  FROM
    activated_users u

  LEFT JOIN
    journal_activity j

  ON
    u.user_id = j.user_id

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
    u.first_journal_saved_at
)

SELECT

  *

FROM
  engagement;
