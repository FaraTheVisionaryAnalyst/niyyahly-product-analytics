-- ============================================================
-- NiyyahLy Product Analytics
-- Stage 7: Retention Analysis
-- File: 02_retention_analysis.sql
--
-- Purpose:
-- Analyze milestone retention among activated users.
--
-- Population:
-- Activated users only.
--
-- Retention definition:
-- User saved at least one journal on the specified calendar
-- day after activation.
--
-- Milestones:
-- D1, D7, D14, D30
--
-- Important:
-- These are milestone retention metrics.
-- They do not measure continuous usage or streak behavior.
--
-- Continuous 30-day engagement is analyzed separately in:
-- sql/06_engagement/02_30d_engagement_analysis.sql
-- ============================================================


-- ============================================================
-- QUERY 1: Overall Retention
-- ============================================================
--
-- Business question:
-- Among activated users, what percentage returned and saved
-- a journal on D1, D7, D14 and D30?
-- ============================================================

SELECT

  COUNT(*) AS activated_users,

  COUNTIF(retained_d1 = 1)
    AS d1_retained_users,

  COUNTIF(retained_d7 = 1)
    AS d7_retained_users,

  COUNTIF(retained_d14 = 1)
    AS d14_retained_users,

  COUNTIF(retained_d30 = 1)
    AS d30_retained_users,

  SAFE_DIVIDE(
    COUNTIF(retained_d1 = 1),
    COUNT(*)
  ) AS d1_retention_rate,

  SAFE_DIVIDE(
    COUNTIF(retained_d7 = 1),
    COUNT(*)
  ) AS d7_retention_rate,

  SAFE_DIVIDE(
    COUNTIF(retained_d14 = 1),
    COUNT(*)
  ) AS d14_retention_rate,

  SAFE_DIVIDE(
    COUNTIF(retained_d30 = 1),
    COUNT(*)
  ) AS d30_retention_rate

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_retention`;


-- ============================================================
-- QUERY 2: Retention by Experiment Cohort
-- ============================================================
--
-- Business question:
-- Does milestone retention differ between the control and
-- variant onboarding experiences?
--
-- Interpretation:
-- This is a cohort comparison.
-- It does not by itself prove that a specific feature caused
-- the difference.
-- ============================================================

SELECT

  cohort,

  COUNT(*) AS activated_users,

  COUNTIF(retained_d1 = 1)
    AS d1_retained_users,

  COUNTIF(retained_d7 = 1)
    AS d7_retained_users,

  COUNTIF(retained_d14 = 1)
    AS d14_retained_users,

  COUNTIF(retained_d30 = 1)
    AS d30_retained_users,

  SAFE_DIVIDE(
    COUNTIF(retained_d1 = 1),
    COUNT(*)
  ) AS d1_retention_rate,

  SAFE_DIVIDE(
    COUNTIF(retained_d7 = 1),
    COUNT(*)
  ) AS d7_retention_rate,

  SAFE_DIVIDE(
    COUNTIF(retained_d14 = 1),
    COUNT(*)
  ) AS d14_retention_rate,

  SAFE_DIVIDE(
    COUNTIF(retained_d30 = 1),
    COUNT(*)
  ) AS d30_retention_rate

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_retention`

GROUP BY
  cohort

ORDER BY
  cohort;


-- ============================================================
-- QUERY 3: Retention Curve by Cohort
-- ============================================================
--
-- Purpose:
-- Produce a Tableau-friendly long-format retention curve.
--
-- Each row represents one cohort and one retention milestone.
--
-- This is useful for visualizing:
--
-- D1 → D7 → D14 → D30
--
-- without duplicating the retention calculations in Tableau.
-- ============================================================

WITH milestone_rates AS (

  SELECT

    cohort,

    SAFE_DIVIDE(
      COUNTIF(retained_d1 = 1),
      COUNT(*)
    ) AS d1_retention_rate,

    SAFE_DIVIDE(
      COUNTIF(retained_d7 = 1),
      COUNT(*)
    ) AS d7_retention_rate,

    SAFE_DIVIDE(
      COUNTIF(retained_d14 = 1),
      COUNT(*)
    ) AS d14_retention_rate,

    SAFE_DIVIDE(
      COUNTIF(retained_d30 = 1),
      COUNT(*)
    ) AS d30_retention_rate

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_retention`

  GROUP BY
    cohort
)

SELECT
  cohort,
  'D1' AS milestone,
  1 AS milestone_day,
  d1_retention_rate AS retention_rate
FROM
  milestone_rates

UNION ALL

SELECT
  cohort,
  'D7' AS milestone,
  7 AS milestone_day,
  d7_retention_rate AS retention_rate
FROM
  milestone_rates

UNION ALL

SELECT
  cohort,
  'D14' AS milestone,
  14 AS milestone_day,
  d14_retention_rate AS retention_rate
FROM
  milestone_rates

UNION ALL

SELECT
  cohort,
  'D30' AS milestone,
  30 AS milestone_day,
  d30_retention_rate AS retention_rate
FROM
  milestone_rates

ORDER BY
  cohort,
  milestone_day;
