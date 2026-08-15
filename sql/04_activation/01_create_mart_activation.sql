CREATE OR REPLACE TABLE
`niyyahly-product-analytics.niyyahly_analytics.mart_activation` AS

WITH signup_times AS (

  SELECT
    user_id,
    MIN(event_timestamp) AS signup_completed_at

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events`

  WHERE
    event_name = 'signup_completed'

  GROUP BY
    user_id
),

activation_events AS (

  SELECT
    e.user_id,
    s.signup_completed_at,

    MIN(IF(
      e.event_name = 'onboarding_completed',
      e.event_timestamp,
      NULL
    )) AS onboarding_completed_at,

    MIN(IF(
      e.event_name = 'mood_selected',
      e.event_timestamp,
      NULL
    )) AS first_mood_selected_at,

    MIN(IF(
      e.event_name = 'topic_selected',
      e.event_timestamp,
      NULL
    )) AS first_topic_selected_at,

    MIN(IF(
      e.event_name = 'tone_selected',
      e.event_timestamp,
      NULL
    )) AS first_tone_selected_at,

    MIN(IF(
      e.event_name = 'prompt_generation_completed',
      e.event_timestamp,
      NULL
    )) AS first_prompt_generated_at,

    MIN(IF(
      e.event_name = 'journal_saved',
      e.event_timestamp,
      NULL
    )) AS first_journal_saved_at

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events` e

  INNER JOIN
    signup_times s

  ON
    e.user_id = s.user_id

  WHERE
    e.event_timestamp >= s.signup_completed_at

    AND e.event_timestamp <
        TIMESTAMP_ADD(
          s.signup_completed_at,
          INTERVAL 24 HOUR
        )

  GROUP BY
    e.user_id,
    s.signup_completed_at
)

SELECT

  u.user_id,

  u.signup_date,
  u.cohort,
  u.onboarding_version,
  u.onboarding_path,
  u.knows_mbti,
  u.platform,

  a.signup_completed_at,
  a.onboarding_completed_at,
  a.first_mood_selected_at,
  a.first_topic_selected_at,
  a.first_tone_selected_at,
  a.first_prompt_generated_at,
  a.first_journal_saved_at,

  a.onboarding_completed_at IS NOT NULL
    AS onboarding_completed,

  a.first_mood_selected_at IS NOT NULL
    AS mood_selected,

  a.first_topic_selected_at IS NOT NULL
    AS topic_selected,

  a.first_tone_selected_at IS NOT NULL
    AS tone_selected,

  a.first_prompt_generated_at IS NOT NULL
    AS prompt_generated,

  a.first_journal_saved_at IS NOT NULL
    AS journal_saved,

  CASE
    WHEN
      a.onboarding_completed_at IS NOT NULL
      AND a.first_mood_selected_at IS NOT NULL
      AND a.first_topic_selected_at IS NOT NULL
      AND a.first_tone_selected_at IS NOT NULL
      AND a.first_prompt_generated_at IS NOT NULL
      AND a.first_journal_saved_at IS NOT NULL
    THEN TRUE
    ELSE FALSE
  END AS activated

FROM
  `niyyahly-product-analytics.niyyahly_analytics.dim_users` u

LEFT JOIN
  activation_events a

ON
  u.user_id = a.user_id;
