# NiyyahLy Engagement — Next Steps

## What the Current Analysis Shows

The current analysis evaluates post-activation engagement among
users who reached activation.

Post-activation engagement is measured using:

- Active journal days
- Longest journal streak
- Consistency across four post-activation periods

These metrics are intended to measure sustained product usage
rather than simply whether a user returned on one specific
retention milestone.

---

## Retention vs Engagement

The project distinguishes between milestone retention and
sustained engagement.

### Retention

Retention asks:

> Did an activated user return and save a journal on D1, D7,
> D14 or D30?

This is useful for measuring return behavior at specific
milestones.

However, a user can be D30 retained after only saving a journal
on the D30 date.

Therefore D30 retention does not prove continuous usage.

### Engagement

Engagement asks:

> Did the activated user continue using the journal throughout
> the 30-day period?

This is measured using:

- Active journal days
- Longest journal streak
- Four-period consistency

These metrics provide stronger evidence of sustained product
usage.

---

## Current 30-Day Engagement Findings

Among activated users:

- Average active journal days: 4.67
- Median active journal days: 5
- Maximum active journal days: 12
- 99.1% were active on at least one post-activation day
- 86.0% were active on at least three days
- 17.6% were active on at least seven days
- 1.5% were active on at least ten days

For streak behavior:

- Average longest streak: 1.62 days
- Median longest streak: 1 day
- 49.7% achieved at least a 2-day streak
- 10.8% achieved at least a 3-day streak
- 0.2% achieved at least a 5-day streak

These results suggest that most activated users return at
least once, but sustained consecutive usage is much less common.

This is an important distinction from milestone retention.

---

## Experiment Cohort Findings

The variant cohort currently shows stronger sustained
engagement than the control cohort.

Among activated users:

- Control: 18.20% active across all four periods
- Variant: 31.40% active across all four periods
- Absolute difference: +13.20 percentage points
- Two-proportion z-test: z = 4.79

The synthetic dataset therefore shows a statistically significant
difference between the two cohorts.

However, this should be interpreted as an observed experiment
cohort difference rather than proof that a particular product
feature caused the improvement.

---

## What the Current Data Cannot Explain

The current dataset does not cleanly isolate the effect of
personality-based prompt personalization.

In particular, `knows_mbti` indicates whether a user already knows
their MBTI, but does not directly indicate whether a personalized
reflection prompt was actually generated or shown.

Users may:

- already know their MBTI
- complete the personality test
- skip the personality test
- select an MBTI
- receive different onboarding experiences

Therefore these variables should not be treated as direct
experimental exposure measures for prompt personalization.

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

The experiment should keep other parts of the experience as
consistent as possible.

---

## Required Instrumentation

The product should explicitly record whether personalization was
actually used.

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

The primary success metric should be a sustained post-activation
engagement measure.

A strong candidate is:

**Percentage of activated users active across all four
post-activation periods.**

This metric captures whether users continue returning
throughout the 30-day period rather than simply returning once.

Supporting metrics can include:

- Active journal days
- Longest journal streak
- D1/D7/D14/D30 milestone retention

---

## Decision Framework

If personalization produces a meaningful improvement in sustained
engagement:

→ Continue investing in personalized reflection.

If activation improves but sustained engagement does not:

→ Focus on the quality and relevance of the reflection experience
rather than onboarding alone.

If neither activation nor engagement improves:

→ Reconsider the underlying value proposition or onboarding
design.

---

## Current Limitation

The current synthetic dataset provides evidence that the variant
is associated with stronger activation and post-activation
engagement.

It does not provide sufficient instrumentation to attribute that
improvement specifically to personality + mood personalization.

Therefore, the next experiment should directly randomize
personalization exposure and measure its effect on sustained
engagement.
