-- NiyyahLy Product Analytics
-- Analytical Model Validation


-- 1. User count
SELECT
  COUNT(*) AS users
FROM `niyyahly-product-analytics.niyyahly_analytics.dim_users`;


-- 2. Duplicate users
SELECT
  user_id,
  COUNT(*) AS rows_check
FROM `niyyahly-product-analytics.niyyahly_analytics.dim_users`
GROUP BY user_id
HAVING COUNT(*) > 1;


-- 3. Event count
SELECT
  COUNT(*) AS events
FROM `niyyahly-product-analytics.niyyahly_analytics.fact_events`;


-- 4. Duplicate event IDs
SELECT
  event_id,
  COUNT(*) AS rows_check
FROM `niyyahly-product-analytics.niyyahly_analytics.fact_events`
GROUP BY event_id
HAVING COUNT(*) > 1;


-- 5. Orphan events
SELECT
  COUNT(*) AS orphan_events
FROM `YOUR_PROJECT_ID.niyyahly_analytics.fact_events` e
LEFT JOIN `niyyahly-product-analytics.niyyahly_analytics.dim_users` u
  ON e.user_id = u.user_id
WHERE u.user_id IS NULL;
