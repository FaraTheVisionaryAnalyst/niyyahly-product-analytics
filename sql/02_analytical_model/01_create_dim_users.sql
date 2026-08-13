-- NiyyahLy Product Analytics
-- Analytical Model: dim_users
-- Grain: one row per user

CREATE OR REPLACE TABLE
`niyyahly-product-analytics.niyyahly_analytics.dim_users` AS

SELECT
  user_id,
  DATE(signup_date) AS signup_date,
  cohort_month,
  platform,
  country,
  cohort,
  onboarding_version,
  onboarding_path,
  knows_mbti,
  NULLIF(mbti, '') AS mbti,
  faith_level,
  social_energy,
  extrovert_score,
  religiosity_score,
  onboarding_completed,
  activated

FROM
  `niyyahly-product-analytics.niyyahly_raw.users`;
