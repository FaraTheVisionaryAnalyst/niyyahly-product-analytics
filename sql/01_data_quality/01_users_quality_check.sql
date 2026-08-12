-- NiyyahLy Product Analytics
-- Data Quality Check: users table
-- Source: niyyahly_raw.users

-- 1. Total users
SELECT
  COUNT(*) AS total_users
FROM `niyyahly-product-analytics.niyyahly_raw.users`;


-- 2. Experiment cohort distribution
SELECT
  cohort,
  COUNT(*) AS users
FROM `niyyahly-product-analytics.niyyahly_raw.users`
GROUP BY cohort
ORDER BY cohort;


-- 3. Overall onboarding completion
SELECT
  COUNT(*) AS total_users,
  COUNTIF(onboarding_completed) AS completed_users,
  SAFE_DIVIDE(
    COUNTIF(onboarding_completed),
    COUNT(*)
  ) AS completion_rate
FROM `niyyahly-product-analytics.niyyahly_raw.users`;
