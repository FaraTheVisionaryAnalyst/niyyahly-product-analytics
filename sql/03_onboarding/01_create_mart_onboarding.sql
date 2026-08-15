CREATE OR REPLACE TABLE
`niyyahly-product-analytics.niyyahly_analytics.mart_onboarding` AS

WITH onboarding_events AS (

  SELECT
    user_id,

    MIN(IF(
      event_name = 'onboarding_started',
      event_timestamp,
      NULL
    )) AS onboarding_started_at,

    MIN(IF(
      event_name = 'personality_test_opened',
      event_timestamp,
      NULL
    )) AS personality_test_opened_at,

    MIN(IF(
      event_name = 'personality_test_completed',
      event_timestamp,
      NULL
    )) AS personality_test_completed_at,

    MIN(IF(
      event_name = 'mbti_self_select_opened',
      event_timestamp,
      NULL
    )) AS mbti_self_select_opened_at,

    MIN(IF(
      event_name = 'mbti_self_select_completed',
      event_timestamp,
      NULL
    )) AS mbti_self_select_completed_at,

    MIN(IF(
      event_name = 'personality_skip_selected',
      event_timestamp,
      NULL
    )) AS personality_skip_at,

    MIN(IF(
      event_name = 'onboarding_completed',
      event_timestamp,
      NULL
    )) AS onboarding_completed_at

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events`

  GROUP BY
    user_id
)

SELECT
  u.user_id,
  u.signup_date,
  u.cohort,
  u.onboarding_version,
  u.onboarding_path,
  u.knows_mbti,
  u.mbti,
  u.platform,
  u.country,

  e.onboarding_started_at,
  e.personality_test_opened_at,
  e.personality_test_completed_at,
  e.mbti_self_select_opened_at,
  e.mbti_self_select_completed_at,
  e.personality_skip_at,
  e.onboarding_completed_at,

  e.onboarding_started_at IS NOT NULL
    AS onboarding_started,

  e.onboarding_completed_at IS NOT NULL
    AS onboarding_completed,

  CASE
    WHEN
      e.onboarding_started_at IS NOT NULL
      AND e.onboarding_completed_at IS NOT NULL
    THEN TIMESTAMP_DIFF(
      e.onboarding_completed_at,
      e.onboarding_started_at,
      SECOND
    )
    ELSE NULL
  END AS onboarding_duration_seconds,

  u.activated

FROM
  `niyyahly-product-analytics.niyyahly_analytics.dim_users` u

LEFT JOIN
  onboarding_events e
ON
  u.user_id = e.user_id;
