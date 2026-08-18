# NiyyahLy Engagement — Next Steps

## What the Current Analysis Shows

The current analysis shows that users who reach activation
continue to engage with the journal after activation.

Post-activation engagement was evaluated using:

- Active journal days
- Longest journal streak
- Consistency across four post-activation periods

The onboarding variant showed stronger sustained engagement
than the control cohort.

Among activated users:

- Control: 18.20% active across all four periods
- Variant: 31.40% active across all four periods
- Absolute difference: +13.20 percentage points
- Two-proportion z-test: z = 4.79

This indicates a statistically significant difference in the
synthetic experiment dataset.

However, this result should be interpreted as an observed
cohort difference and not as proof that a specific product
feature caused the improvement.

---

## What the Current Data Cannot Explain

The current dataset does not cleanly isolate the effect of
personality-based prompt personalization.

In particular, `knows_mbti` indicates whether a user already
knows their MBTI, but it does not indicate whether the user
actually received a personality-personalized reflection.

Users who initially do not know their MBTI may still:

- take the personality test,
- complete the test,
- receive an MBTI result,
- and potentially receive personalized content.

Therefore, MBTI familiarity should not be treated as a direct
proxy for personalization exposure.

---

## Product Hypothesis

The next product hypothesis is:

> Users who receive reflection prompts personalized using their
> personality profile and current mood will demonstrate stronger
> sustained engagement than users receiving non-personalized
> prompts.

The expected mechanism is that more personally relevant
reflection prompts may make users feel more understood and
increase their motivation to continue using the reflection
experience.

---

## Recommended Next Experiment

The next experiment should directly randomize the
personalization experience.

### Control

Users receive a standard reflection prompt.

### Variant

Users receive a reflection prompt incorporating:

- Personality information
- Current mood

The experiment should keep other parts of the experience
as consistent as possible.

---

## Required Instrumentation

The product should explicitly record whether personalization
was actually used.

Recommended fields/events include:

- `personality_context_available`
- `mood_context_available`
- `personality_context_used`
- `mood_context_used`
- `prompt_personalized`
- `prompt_generation_completed`
- `journal_saved`

This allows the analysis to distinguish between:

1. User has personality information
2. Personality information was actually used
3. Mood information was actually used
4. The resulting prompt was personalized

---

## Primary Success Metric

The primary success metric should be a sustained
post-activation engagement measure.

A candidate primary metric is:

**Percentage of activated users active across all four
post-activation periods.**

This metric captures whether users continue returning
throughout the 30-day period rather than simply returning
once.

Supporting metrics can include:

- Active journal days
- Longest journal streak
- D1/D7/D14/D30 retention

---

## Decision Framework

If personalization produces a meaningful improvement in
sustained engagement:

→ Continue investing in personalized reflection.

If activation improves but sustained engagement does not:

→ Focus on the quality and relevance of the reflection
experience rather than onboarding alone.

If neither activation nor engagement improves:

→ Reconsider the underlying value proposition or onboarding
design.

---

## Current Limitation

The current synthetic dataset provides evidence that the
variant is associated with stronger activation and
post-activation engagement.

It does not provide sufficient instrumentation to attribute
that improvement specifically to personality + mood
personalization.

Therefore, the next experiment should be designed to
directly measure personalization exposure and its effect
on sustained engagement.
