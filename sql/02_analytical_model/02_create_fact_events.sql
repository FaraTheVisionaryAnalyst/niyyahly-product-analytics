-- NiyyahLy Product Analytics
-- Analytical Model: fact_events
-- Grain: one row per product event

CREATE OR REPLACE TABLE
`niyyahly-product-analytics.niyyahly_analytics.fact_events` AS

SELECT
  event_id,
  user_id,
  session_id,
  event_name,
  TIMESTAMP(event_timestamp) AS event_timestamp,
  platform,
  app_version,
  properties

FROM
  `niyyahly-product-analytics.niyyahly_raw.events`;
