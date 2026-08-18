-- ============================================================
-- NiyyahLy Product Analytics
-- Stage 8: Personalization Exposure Analysis
-- File: 03_personalization_exposure.sql
--
-- Purpose:
-- Investigate whether availability of an MBTI profile during
-- onboarding is associated with stronger post-activation
-- engagement.
--
-- Product hypothesis:
-- Reflection prompts personalized using personality information
-- may create stronger and more sustained engagement.
--
-- Important:
-- The current dataset does not contain an explicit event such
-- as personalized_prompt_delivered.
--
-- Therefore, personalization exposure is inferred from the
-- onboarding path:
--
--   1. User already knows MBTI and provides their type
--   2. User completes the personality test
--   3. User completes MBTI self-selection
--
-- Users who explicitly skip the personality step are treated
-- as not personalized.
--
-- This analysis is observational.
-- Personalization exposure was NOT randomly assigned.
--
-- Therefore, differences between the groups cannot be
-- interpreted as causal evidence that personalization
-- increases or decreases engagement.
-- ============================================================



-- ============================================================
-- QUERY 1: MBTI Event Coverage Among Activated Users
-- ============================================================
--
-- Business question:
-- Among activated users, how many interacted with each
-- MBTI-related onboarding event?
--
-- Purpose:
-- Establish the available MBTI-related behaviors before
-- constructing a personalization exposure classification.
--
-- This is a diagnostic query rather than an engagement
-- analysis.
-- ============================================================


WITH activated_users AS (

  SELECT

    user_id

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  WHERE
    activated = TRUE
),

mbti_events AS (

  SELECT

    user_id,

    COUNTIF(
      event_name = 'personality_test_opened'
    ) > 0 AS personality_test_opened,

    COUNTIF(
      event_name = 'personality_test_completed'
    ) > 0 AS personality_test_completed,

    COUNTIF(
      event_name = 'mbti_self_select_opened'
    ) > 0 AS mbti_self_select_opened,

    COUNTIF(
      event_name = 'mbti_self_select_completed'
    ) > 0 AS mbti_self_select_completed,

    COUNTIF(
      event_name = 'personality_skip_selected'
    ) > 0 AS personality_skip_selected

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events`

  WHERE
    event_name IN (
      'personality_test_opened',
      'personality_test_completed',
      'mbti_self_select_opened',
      'mbti_self_select_completed',
      'personality_skip_selected'
    )

  GROUP BY
    user_id
)

SELECT

  COUNT(*) AS activated_users,

  COUNTIF(
    e.personality_test_opened
  ) AS personality_test_opened_users,

  COUNTIF(
    e.personality_test_completed
  ) AS personality_test_completed_users,

  COUNTIF(
    e.mbti_self_select_opened
  ) AS mbti_self_select_opened_users,

  COUNTIF(
    e.mbti_self_select_completed
  ) AS mbti_self_select_completed_users,

  COUNTIF(
    e.personality_skip_selected
  ) AS personality_skipped_users

FROM
  activated_users a

LEFT JOIN
  mbti_events e

ON
  a.user_id = e.user_id;



-- ============================================================
-- QUERY 2: MBTI Path Classification
-- ============================================================
--
-- Business question:
-- How did activated users obtain or interact with their
-- MBTI information?
--
-- Purpose:
-- Create mutually exclusive diagnostic categories.
--
-- Important:
-- This classification describes the observed onboarding path.
-- It does not yet claim that the resulting prompt was
-- personalized.
-- ============================================================


WITH activated_users AS (

  SELECT

    user_id,
    knows_mbti,
    onboarding_path,
    cohort

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  WHERE
    activated = TRUE
),

mbti_events AS (

  SELECT

    user_id,

    COUNTIF(
      event_name = 'personality_test_completed'
    ) > 0 AS personality_test_completed,

    COUNTIF(
      event_name = 'mbti_self_select_completed'
    ) > 0 AS mbti_self_select_completed,

    COUNTIF(
      event_name = 'personality_skip_selected'
    ) > 0 AS personality_skip_selected

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events`

  WHERE
    event_name IN (
      'personality_test_completed',
      'mbti_self_select_completed',
      'personality_skip_selected'
    )

  GROUP BY
    user_id
)

SELECT

  CASE

    WHEN
      a.knows_mbti = TRUE
      AND COALESCE(
        e.mbti_self_select_completed,
        FALSE
      )
    THEN 'already_knew_mbti_self_selected'

    WHEN
      a.knows_mbti = TRUE
      AND COALESCE(
        e.personality_test_completed,
        FALSE
      )
    THEN 'already_knew_mbti_test_completed'

    WHEN
      a.knows_mbti = FALSE
      AND COALESCE(
        e.personality_test_completed,
        FALSE
      )
    THEN 'learned_mbti_through_test'

    WHEN
      a.knows_mbti = FALSE
      AND COALESCE(
        e.personality_skip_selected,
        FALSE
      )
    THEN 'skipped_personality'

    ELSE 'unclassified'

  END AS mbti_path,

  COUNT(*) AS users

FROM
  activated_users a

LEFT JOIN
  mbti_events e

ON
  a.user_id = e.user_id

GROUP BY
  mbti_path

ORDER BY
  users DESC;



-- ============================================================
-- QUERY 3: MBTI Path Overlap Validation
-- ============================================================
--
-- Business question:
-- Are MBTI-related behaviors overlapping or mutually exclusive?
--
-- Purpose:
-- Validate that the observed onboarding paths can be
-- interpreted without double-counting users.
--
-- This is a data-quality / analytical-validation query.
-- ============================================================


WITH activated_users AS (

  SELECT

    user_id,
    knows_mbti

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  WHERE
    activated = TRUE
),

mbti_events AS (

  SELECT

    user_id,

    COUNTIF(
      event_name = 'personality_test_completed'
    ) > 0 AS personality_test_completed,

    COUNTIF(
      event_name = 'mbti_self_select_completed'
    ) > 0 AS mbti_self_select_completed,

    COUNTIF(
      event_name = 'personality_skip_selected'
    ) > 0 AS personality_skip_selected

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events`

  WHERE
    event_name IN (
      'personality_test_completed',
      'mbti_self_select_completed',
      'personality_skip_selected'
    )

  GROUP BY
    user_id
),

user_flags AS (

  SELECT

    a.user_id,

    a.knows_mbti,

    COALESCE(
      e.personality_test_completed,
      FALSE
    ) AS personality_test_completed,

    COALESCE(
      e.mbti_self_select_completed,
      FALSE
    ) AS mbti_self_select_completed,

    COALESCE(
      e.personality_skip_selected,
      FALSE
    ) AS personality_skip_selected

  FROM
    activated_users a

  LEFT JOIN
    mbti_events e

  ON
    a.user_id = e.user_id
)

SELECT

  knows_mbti,

  personality_test_completed,

  mbti_self_select_completed,

  personality_skip_selected,

  COUNT(*) AS users

FROM
  user_flags

GROUP BY

  knows_mbti,
  personality_test_completed,
  mbti_self_select_completed,
  personality_skip_selected

ORDER BY
  users DESC;



-- ============================================================
-- QUERY 4: Personalization Exposure vs Engagement
-- ============================================================
--
-- Business question:
-- Among activated users, do users with an MBTI profile
-- available for personalization show stronger post-activation
-- engagement than users who skipped the personality step?
--
-- Personalized group:
-- - Already knew MBTI and provided their type
-- - Completed personality test
-- - Completed MBTI self-selection
--
-- Non-personalized group:
-- - Explicitly skipped the personality step
--
-- Engagement metrics:
--
-- 1. Average active journal days
--    Measures usage frequency.
--
-- 2. Percentage active across all four post-activation
--    consistency periods.
--    Measures sustained usage across the 30-day period.
--
-- Important:
-- This is an observational comparison.
--
-- Users were NOT randomly assigned to personalized versus
-- non-personalized experiences.
--
-- Users who skipped the personality step may differ from
-- personalized users in motivation, preferences, onboarding
-- behavior, or other characteristics.
--
-- Therefore, observed differences cannot establish that
-- personalization caused higher or lower engagement.
--
-- The result should be treated as exploratory evidence for
-- designing a future randomized personalization experiment.
-- ============================================================


WITH activated_users AS (

  SELECT

    user_id,
    knows_mbti

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.mart_activation`

  WHERE
    activated = TRUE
),

mbti_events AS (

  SELECT

    user_id,

    COUNTIF(
      event_name = 'personality_test_completed'
    ) > 0 AS personality_test_completed,

    COUNTIF(
      event_name = 'mbti_self_select_completed'
    ) > 0 AS mbti_self_select_completed,

    COUNTIF(
      event_name = 'personality_skip_selected'
    ) > 0 AS personality_skip_selected

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events`

  WHERE
    event_name IN (
      'personality_test_completed',
      'mbti_self_select_completed',
      'personality_skip_selected'
    )

  GROUP BY
    user_id
),

personalization_groups AS (

  SELECT

    a.user_id,

    CASE

      WHEN
        a.knows_mbti = TRUE
        OR COALESCE(
          e.personality_test_completed,
          FALSE
        )
        OR COALESCE(
          e.mbti_self_select_completed,
          FALSE
        )
      THEN 'personalized'

      WHEN
        COALESCE(
          e.personality_skip_selected,
          FALSE
        )
      THEN 'not_personalized'

      ELSE 'unclassified'

    END AS personalization_group

  FROM
    activated_users a

  LEFT JOIN
    mbti_events e

  ON
    a.user_id = e.user_id
)

SELECT

  p.personalization_group,

  COUNT(*) AS activated_users,

  ROUND(
    AVG(m.journal_active_days_30d),
    2
  ) AS average_active_journal_days,

  SAFE_DIVIDE(
    COUNTIF(
      m.active_consistency_periods_30d = 4
    ),
    COUNT(*)
  ) AS pct_active_all_4_periods

FROM
  personalization_groups p

INNER JOIN
  `niyyahly-product-analytics.niyyahly_analytics.mart_30d_post_activation` m

ON
  p.user_id = m.user_id

GROUP BY
  p.personalization_group

ORDER BY
  p.personalization_group;
