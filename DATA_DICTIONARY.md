# Data Dictionary — v1

users: user-level profile, cohort, onboarding and personalization.
events: event-level product behavior; properties is JSON text.
daily_checkins: mood, faith state, topic and tone selections.
prompt_generations: AI generation attempts, success, latency and regeneration.
journal_entries: saved journal metadata plus synthetic sentiment.
favorite_prompts: prompt favorites.
inspire_saves: Inspire saves.
programme_progress: programme day completion.
notification_log: notification delivery and taps.
community_activity: aggregated/anonymous community behavior.
experiment_assignments: synthetic experiment assignment.
event_tracking_plan: canonical event names and categories.

Key product fields:
cohort = control / variant
onboarding_version = baseline / lower_friction
onboarding_path = mandatory_test / self_select / test_or_skip
knows_mbti = synthetic indicator
mood = very_low / low / neutral / good / grateful
faith_state = at_peace / distant / questioning / hurting
tone = universal / light_islamic / deeper_faith

Sentiment and all profile attributes are synthetic. They are not clinical measures or real customer attributes.
