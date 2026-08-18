-- ============================================================
-- NiyyahLy Product Analytics
-- Stage 8: Engagement Segmentation
-- File: 03_engagement_segmentation.sql
--
-- Purpose:
-- Explore whether post-activation engagement differs across
-- meaningful user segments.
--
-- First segmentation:
-- MBTI familiarity.
--
-- Product question:
-- Among activated users, is MBTI familiarity associated with
-- different levels of journal frequency and sustained usage?
--
-- Important:
-- MBTI familiarity is a segmentation variable.
-- It is NOT a direct measure of personalization.
--
-- Therefore:
-- This analysis can identify an association or signal for
-- further investigation, but cannot establish that
-- personality-based personalization causes stronger engagement.
-- ============================================================


-- ============================================================
-- QUERY 1: Engagement by MBTI Familiarity
-- ============================================================
--
-- Metrics selected:
--
-- 1. Average active journal days
--    Measures overall journaling frequency.
--
-- 2. Percentage active in all four periods
--    Measures sustained usage across the 30-day window.
--
-- These two metrics are intentionally selected instead of
-- repeating the full engagement framework from
-- 02_30d_engagement_analysis.sql.
-- ============================================================


SELECT

  knows_mbti,

  COUNT(*) AS activated_users,

  ROUND(
    AVG(journal_active_days_30d),
    2
  ) AS average_active_journal_days,

  SAFE_DIVIDE(
    COUNTIF(active_consistency_periods_30d = 4),
    COUNT(*)
  ) AS pct_active_all_4_periods

FROM
  `niyyahly-product-analytics.niyyahly_analytics.mart_30d_post_activation`

GROUP BY
  knows_mbti

ORDER BY
  knows_mbti;
