-- NiyyahLy Product Analytics
-- Data Quality Check: events table
-- Source: niyyahly_raw.events


-- 1. Total events
SELECT
  COUNT(*) AS total_events
FROM `niyyahly-product-analytics.niyyahly_raw.events`;


-- 2. Unique users with events
SELECT
  COUNT(DISTINCT user_id) AS users_with_events
FROM `niyyahly-product-analytics.niyyahly_raw.events`;


-- 3. Event distribution
SELECT
  event_name,
  COUNT(*) AS event_count
FROM `niyyahly-product-analytics.niyyahly_raw.events`
GROUP BY event_name
ORDER BY event_count DESC;


-- 4. Duplicate event IDs
SELECT
  event_id,
  COUNT(*) AS occurrences
FROM `niyyahly-product-analytics.niyyahly_raw.events`
GROUP BY event_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


-- 5. Orphan events
SELECT
  COUNT(*) AS orphan_events
FROM `niyyahly-product-analytics.niyyahly_raw.events` e
LEFT JOIN `niyyahly-product-analytics.niyyahly_raw.events` u
  ON e.user_id = u.user_id
WHERE u.user_id IS NULL;


-- 6. Event date range
SELECT
  MIN(DATE(event_timestamp)) AS earliest_event,
  MAX(DATE(event_timestamp)) AS latest_event
FROM `niyyahly-product-analytics.niyyahly_raw.events`;


-- 7. Mood distribution from event properties
SELECT
  JSON_VALUE(properties, '$.mood') AS mood,
  COUNT(*) AS selections
FROM `niyyahly-product-analytics.niyyahly_raw.events`
WHERE event_name = 'mood_selected'
GROUP BY mood
ORDER BY selections DESC;


-- 8. Onboarding event coverage
SELECT
  event_name,
  COUNT(DISTINCT user_id) AS unique_users
FROM `niyyahly-product-analytics.niyyahly_raw.events`
WHERE event_name IN (
  'onboarding_started',
  'personality_test_opened',
  'personality_test_completed',
  'mbti_self_select_opened',
  'mbti_self_select_completed',
  'personality_skip_selected',
  'onboarding_completed'
)
GROUP BY event_name
ORDER BY unique_users DESC;
