CREATE OR REPLACE TABLE
`niyyahly-product-analytics.niyyahly_analytics.mart_retention` AS

WITH journal_activity AS (

  SELECT DISTINCT

    e.user_id,

    DATE(e.event_timestamp) AS activity_date

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.facts_events` e

  WHERE
    e.event_name = 'journal_saved'
),

retention_flags AS (

  SELECT

    u.user_id,

    u.signup_date,
    u.cohort,
    u.onboarding_version,
    u.onboarding_path,
    u.knows_mbti,
    u.platform,

    MAX(
      CASE
        WHEN DATE_DIFF(
          j.activity_date,
          u.signup_date,
          DAY
        ) = 1
        THEN 1
        ELSE 0
      END
    ) AS retained_d1,

    MAX(
      CASE
        WHEN DATE_DIFF(
          j.activity_date,
          u.signup_date,
          DAY
        ) = 7
        THEN 1
        ELSE 0
      END
    ) AS retained_d7,

    MAX(
      CASE
        WHEN DATE_DIFF(
          j.activity_date,
          u.signup_date,
          DAY
        ) = 14
        THEN 1
        ELSE 0
      END
    ) AS retained_d14,

    MAX(
      CASE
        WHEN DATE_DIFF(
          j.activity_date,
          u.signup_date,
          DAY
        ) = 30
        THEN 1
        ELSE 0
      END
    ) AS retained_d30

  FROM
    `niyyahly-product-analytics.niyyahly_analytics.dim_users` u

  LEFT JOIN
    journal_activity j

  ON
    u.user_id = j.user_id

  GROUP BY

    u.user_id,
    u.signup_date,
    u.cohort,
    u.onboarding_version,
    u.onboarding_path,
    u.knows_mbti,
    u.platform
)

SELECT

  *

FROM
  retention_flags;
