-- ============================================================
-- NiyyahLy Product Analytics
-- Stage 6: Activation Analysis
-- File: 02_activation_analysis.sql
--
-- Purpose:
-- Analyze activation after the mart_activation table
-- has been created and validated.
--
-- Main product question:
-- Does the lower-friction onboarding experience help
-- more users reach NiyyahLy's core reflection experience?
-- ============================================================


-- ============================================================
-- QUERY 1: Overall Activation Rate
-- ============================================================
--
-- Business question:
-- What percentage of all users reached the core
-- NiyyahLy reflection experience within 24 hours?
-- ============================================================

SELECT

  COUNT(*) AS total_users,

  COUNTIF(activated) AS activated_users,

  SAFE_DIVIDE(
    COUNTIF(activated),
    COUNT(*)
  ) AS activation_rate

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_activation`;


-- ============================================================
-- QUERY 2: Activation Among Onboarding Completers
-- ============================================================
--
-- Business question:
-- Once a user completes onboarding, how many continue
-- to the core reflection experience?
-- ============================================================

SELECT

  COUNT(*) AS total_users,

  COUNTIF(onboarding_completed)
    AS onboarding_completers,

  COUNTIF(activated)
    AS activated_users,

  SAFE_DIVIDE(
    COUNTIF(activated),
    COUNTIF(onboarding_completed)
  ) AS activation_rate_among_completers

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_activation`;


-- ============================================================
-- QUERY 3: Activation by Experiment Cohort
-- ============================================================
--
-- Business question:
-- Does the variant onboarding experience have a different
-- activation rate compared with the control?
-- ============================================================

SELECT

  cohort,

  COUNT(*) AS users,

  COUNTIF(onboarding_completed)
    AS onboarding_completers,

  COUNTIF(activated)
    AS activated_users,

  SAFE_DIVIDE(
    COUNTIF(onboarding_completed),
    COUNT(*)
  ) AS onboarding_completion_rate,

  SAFE_DIVIDE(
    COUNTIF(activated),
    COUNT(*)
  ) AS activation_rate,

  SAFE_DIVIDE(
    COUNTIF(activated),
    COUNTIF(onboarding_completed)
  ) AS activation_rate_among_completers

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

GROUP BY
  cohort

ORDER BY
  cohort;


-- ============================================================
-- QUERY 4: Activation Lift
-- ============================================================
--
-- Business question:
-- How much higher or lower is activation in the variant
-- compared with the control?
--
-- Absolute lift is reported in percentage points.
-- Relative lift expresses the difference relative to control.
-- ============================================================

WITH cohort_metrics AS (

  SELECT

    cohort,

    SAFE_DIVIDE(
      COUNTIF(activated),
      COUNT(*)
    ) AS activation_rate

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  GROUP BY
    cohort
)

SELECT

  MAX(IF(
    cohort = 'variant',
    activation_rate,
    NULL
  )) AS variant_activation_rate,

  MAX(IF(
    cohort = 'control',
    activation_rate,
    NULL
  )) AS control_activation_rate,

  (
    MAX(IF(
      cohort = 'variant',
      activation_rate,
      NULL
    ))
    -
    MAX(IF(
      cohort = 'control',
      activation_rate,
      NULL
    ))
  ) AS absolute_lift_pp,

  SAFE_DIVIDE(

    (
      MAX(IF(
        cohort = 'variant',
        activation_rate,
        NULL
      ))
      -
      MAX(IF(
        cohort = 'control',
        activation_rate,
        NULL
      ))
    ),

    MAX(IF(
      cohort = 'control',
      activation_rate,
      NULL
    ))

  ) AS relative_lift

FROM
  cohort_metrics;


-- ============================================================
-- QUERY 5: Time to Activation by Cohort
-- ============================================================
--
-- Business question:
-- Among activated users, does the variant reach activation
-- faster than the control?
--
-- Time is measured from signup to first journal save.
-- ============================================================

SELECT

  cohort,

  COUNTIF(activated)
    AS activated_users,

  AVG(
    TIMESTAMP_DIFF(
      first_journal_saved_at,
      signup_completed_at,
      MINUTE
    )
  ) AS average_minutes_to_activation,

  APPROX_QUANTILES(
    TIMESTAMP_DIFF(
      first_journal_saved_at,
      signup_completed_at,
      MINUTE
    ),
    100
  )[OFFSET(50)] AS median_minutes_to_activation

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

WHERE
  activated = TRUE

GROUP BY
  cohort

ORDER BY
  cohort;


-- ============================================================
-- QUERY 6: Activation by MBTI Familiarity
-- ============================================================
--
-- Business question:
-- Does activation differ between users who already know
-- their MBTI type and users who do not?
-- ============================================================

SELECT

  knows_mbti,

  COUNT(*) AS users,

  COUNTIF(onboarding_completed)
    AS onboarding_completers,

  COUNTIF(activated)
    AS activated_users,

  SAFE_DIVIDE(
    COUNTIF(onboarding_completed),
    COUNT(*)
  ) AS onboarding_completion_rate,

  SAFE_DIVIDE(
    COUNTIF(activated),
    COUNT(*)
  ) AS activation_rate

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

GROUP BY
  knows_mbti

ORDER BY
  knows_mbti;


-- ============================================================
-- QUERY 7: Activation by Platform
-- ============================================================
--
-- Business question:
-- Does activation differ across product platforms?
-- ============================================================

SELECT

  platform,

  COUNT(*) AS users,

  COUNTIF(activated)
    AS activated_users,

  SAFE_DIVIDE(
    COUNTIF(activated),
    COUNT(*)
  ) AS activation_rate

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

GROUP BY
  platform

ORDER BY
  activation_rate DESC;


-- ============================================================
-- QUERY 8: Reflection Journey Duration
-- ============================================================
--
-- Business question:
-- How long does the active reflection journey take?
--
-- This measures:
--
-- mood_selected → journal_saved
--
-- rather than the entire calendar period between signup
-- and first product activity.
-- ============================================================

SELECT

  cohort,

  COUNTIF(activated)
    AS activated_users,

  AVG(
    TIMESTAMP_DIFF(
      first_journal_saved_at,
      first_mood_selected_at,
      MINUTE
    )
  ) AS average_reflection_minutes,

  APPROX_QUANTILES(
    TIMESTAMP_DIFF(
      first_journal_saved_at,
      first_mood_selected_at,
      MINUTE
    ),
    100
  )[OFFSET(50)] AS median_reflection_minutes

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

WHERE
  activated = TRUE

GROUP BY
  cohort

ORDER BY
  cohort;


-- ============================================================
-- QUERY 9: Activation Funnel
-- ============================================================
--
-- Business question:
-- Where do users drop out of the activation journey?
-- ============================================================

SELECT

  COUNT(*) AS total_users,

  COUNTIF(onboarding_completed)
    AS onboarding_completed,

  COUNTIF(
    onboarding_completed
    AND mood_selected
  ) AS reached_reflection,

  COUNTIF(
    onboarding_completed
    AND mood_selected
    AND topic_selected
  ) AS selected_topic,

  COUNTIF(
    onboarding_completed
    AND mood_selected
    AND topic_selected
    AND tone_selected
  ) AS selected_tone,

  COUNTIF(
    onboarding_completed
    AND mood_selected
    AND topic_selected
    AND tone_selected
    AND prompt_generated
  ) AS generated_prompt,

  COUNTIF(activated)
    AS activated

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_activation`;
