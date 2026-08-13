-- NiyyahLy Product Analytics
-- Stage 5: Onboarding Analysis


-- 1. Overall onboarding completion

SELECT
  COUNT(*) AS users,
  COUNTIF(onboarding_started) AS started,
  COUNTIF(onboarding_completed) AS completed,

  SAFE_DIVIDE(
    COUNTIF(onboarding_completed),
    COUNTIF(onboarding_started)
  ) AS onboarding_completion_rate

FROM `niyyahly-product-analytics.niyyahly_analytics.mart_onboarding`;


-- 2. Completion by experiment cohort

SELECT
  cohort,
  COUNT(*) AS users,
  COUNTIF(onboarding_started) AS started,
  COUNTIF(onboarding_completed) AS completed,

  SAFE_DIVIDE(
    COUNTIF(onboarding_completed),
    COUNTIF(onboarding_started)
  ) AS completion_rate

FROM `niyyahly-product-analytics.niyyahly_analytics.mart_onboarding`

GROUP BY cohort
ORDER BY cohort;


-- 3. Completion by onboarding path

SELECT
  onboarding_path,
  COUNT(*) AS users,
  COUNTIF(onboarding_completed) AS completed,

  SAFE_DIVIDE(
    COUNTIF(onboarding_completed),
    COUNT(*)
  ) AS completion_rate

FROM `niyyahly-product-analytics.niyyahly_analytics.mart_onboarding`

GROUP BY onboarding_path
ORDER BY completion_rate DESC;


-- 4. Completion by MBTI familiarity

SELECT
  knows_mbti,
  COUNT(*) AS users,
  COUNTIF(onboarding_completed) AS completed,

  SAFE_DIVIDE(
    COUNTIF(onboarding_completed),
    COUNT(*)
  ) AS completion_rate

FROM `niyyahly-product-analytics.niyyahly_analytics.mart_onboarding`

GROUP BY knows_mbti;


-- 5. Onboarding duration

SELECT
  cohort,
  COUNT(*) AS completed_users,

  AVG(onboarding_duration_seconds)
    AS average_duration_seconds,

  APPROX_QUANTILES(
    onboarding_duration_seconds,
    100
  )[OFFSET(50)]
    AS median_duration_seconds

FROM `niyyahly-product-analytics.niyyahly_analytics.mart_onboarding`

WHERE onboarding_completed = TRUE

GROUP BY cohort
ORDER BY cohort;


-- 6. Duration by onboarding path

SELECT
  onboarding_path,
  COUNT(*) AS completed_users,

  AVG(onboarding_duration_seconds)
    AS average_duration_seconds,

  APPROX_QUANTILES(
    onboarding_duration_seconds,
    100
  )[OFFSET(50)]
    AS median_duration_seconds

FROM `niyyahly-product-analytics.niyyahly_analytics.mart_onboarding`

WHERE onboarding_completed = TRUE

GROUP BY onboarding_path
ORDER BY median_duration_seconds;
