-- ============================================================
-- NiyyahLy Product Analytics
-- Stage 7: Retention Analysis
-- File: 02_retention_analysis.sql
--
-- Purpose:
-- Analyze user retention after signup using journal_saved
-- as the retained activity event.
--
-- Retention windows:
-- D1, D7, D14, D30
--
-- Main product question:
-- Do users return to NiyyahLy after their initial experience?
-- ============================================================


-- ============================================================
-- QUERY 1: Overall Retention
-- ============================================================
--
-- Business question:
-- What percentage of users return and save a journal on
-- D1, D7, D14 and D30 after signup?
-- ============================================================

SELECT

  COUNT(*) AS total_users,

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
-- Does retention differ between the control and variant
-- onboarding experiences?
-- ============================================================

SELECT

  cohort,

  COUNT(*) AS users,

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
-- QUERY 3: Retention Among Activated Users
-- ============================================================
--
-- Business question:
-- Are users who reach activation more likely to return
-- and save a journal later?
--
-- This connects the activation analysis to retention.
-- ============================================================

WITH retention_with_activation AS (

  SELECT

    r.*,

    a.activated

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_retention` r

  LEFT JOIN
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation` a

  ON
    r.user_id = a.user_id
)

SELECT

  activated,

  COUNT(*) AS users,

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
  retention_with_activation

GROUP BY
  activated

ORDER BY
  activated DESC;


-- ============================================================
-- QUERY 4: Retention by MBTI Familiarity
-- ============================================================
--
-- Business question:
-- Does retention differ between users who already know
-- their MBTI and users who do not?
-- ============================================================

SELECT

  knows_mbti,

  COUNT(*) AS users,

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
  knows_mbti

ORDER BY
  knows_mbti;


-- ============================================================
-- QUERY 5: Retention by Platform
-- ============================================================
--
-- Business question:
-- Does retention differ across Web, Android and iOS?
-- ============================================================

SELECT

  platform,

  COUNT(*) AS users,

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
  platform

ORDER BY
  platform;


-- ============================================================
-- QUERY 6: Retention by Onboarding Path
-- ============================================================
--
-- Business question:
-- Does retention differ across the different onboarding
-- paths?
--
-- Important:
-- onboarding_path is not an independent experiment dimension.
-- It is a breakdown of behavior within the onboarding design.
-- ============================================================

SELECT

  onboarding_path,

  COUNT(*) AS users,

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
  onboarding_path

ORDER BY
  onboarding_path;
