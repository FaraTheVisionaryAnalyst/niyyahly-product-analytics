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

## What the Current Data Shows About Personalization

The analysis also reconstructed the MBTI-related onboarding
paths among activated users.

Among 1,007 activated users:

- 271 already knew their MBTI and completed self-selection
- 210 already knew their MBTI and completed the personality test
- 420 did not previously know their MBTI and completed the
  personality test
- 106 skipped the personality step

This means:

- 901 activated users were classified as having an MBTI
  profile available for personalization
- 106 activated users were classified as not personalized
  because they explicitly skipped the personality step

Therefore, `knows_mbti` alone should not be used as a proxy
for personalization exposure.

The analysis instead uses the observed onboarding path to
infer whether an MBTI profile was available for the
personalized reflection experience.

---

## Exploratory Personalization Result

Among activated users:

| Personalization Group | Users | Average Active Journal Days | Active Across All 4 Periods |
|---|---:|---:|---:|
| Personalized | 901 | 4.64 | 24.31% |
| Not personalized | 106 | 4.93 | 34.91% |

In this synthetic dataset, the personalization-exposed group
did not show higher post-activation engagement.

The personalized group had:

- 4.64 average active journal days
- 24.31% active across all four consistency periods

The non-personalized group had:

- 4.93 average active journal days
- 34.91% active across all four consistency periods

Therefore, the observed difference is in the opposite
direction from the original personalization hypothesis.

However, this result should be treated as exploratory rather
than as evidence that personalization reduces engagement.

The non-personalized group contains only 106 users, compared
with 901 personalized users.

More importantly, personalization exposure was not randomly
assigned.

Users entered the personalized or non-personalized path
through their onboarding behavior. Users who skip the
personality step may differ from users who complete or provide
their MBTI profile in motivation, preferences, engagement
intent, or other characteristics.

Therefore, the observed difference cannot establish that
personalization caused higher or lower engagement.

---

## What the Current Data Can and Cannot Explain

The current data provides a useful signal about the relationship
between MBTI profile availability and subsequent engagement.

However, the dataset does not contain an explicit event such as:

`personalized_prompt_delivered`

or:

`personality_context_used`

Therefore, personalization exposure is inferred from the
onboarding path rather than directly observed at the prompt
level.

The current analysis can therefore answer:

> Do users classified as having an MBTI profile available for
> personalization show different subsequent engagement?

It cannot reliably answer:

> Does using personality information inside the reflection
> prompt cause higher engagement?

The second question requires a controlled experiment.

---

## Product Hypothesis

The product hypothesis remains:

> Users who receive reflection prompts personalized using their
> personality profile and current mood will demonstrate stronger
> sustained engagement than users receiving non-personalized
> prompts.

The expected mechanism is that more personally relevant
reflection prompts may make users feel more understood and
increase their motivation to continue using the reflection
experience.

The current observational comparison does not confirm this
hypothesis, but it also does not provide sufficient evidence
to reject it causally.

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

Random assignment is important because it allows the analysis
to compare otherwise similar users and isolate the effect of
the personalized prompt experience more reliably.

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
2. Personality information is available to the system
3. Personality information was actually used
4. Mood information was available
5. Mood information was actually used
6. The resulting prompt was personalized
7. The user saved the resulting journal

This instrumentation would remove the current ambiguity
between having an MBTI profile and actually receiving a
personalized prompt.

---

## Primary Success Metric

The primary success metric should be a sustained
post-activation engagement measure.

The recommended primary metric is:

**Percentage of activated users active across all four
post-activation periods.**

The four periods are:

- Days 1–7
- Days 8–14
- Days 15–21
- Days 22–30

This metric captures whether users continue returning
throughout the 30-day period rather than simply returning
once.

Supporting metrics can include:

- Active journal days
- Longest journal streak
- D1/D7/D14/D30 retention

---

## Product Priorities

Based on the current analysis, there are two immediate
product opportunities.

### 1. Improve activation

The largest early funnel loss occurs before users reach the
core reflection experience.

The priority is therefore to improve the transition from
onboarding into the first meaningful reflection experience.

### 2. Improve sustained engagement

Once users activate, engagement is substantially stronger
than among users who do not activate, but sustained usage
remains limited.

The 30-day engagement analysis shows:

- Average active journal days: 4.67
- Median active journal days: 5
- 17.6% of activated users reached at least 7 active days
- 1.5% reached at least 10 active days
- Median longest streak: 1 day

This suggests that increasing repeat usage and consistency
is a more useful product goal than simply optimizing
one-time return behavior.

---

## Decision Framework for the Next Experiment

If personalized prompts produce a meaningful improvement in
sustained engagement:

→ Continue investing in personalized reflection.

If personalization improves prompt interaction but does not
improve sustained engagement:

→ Investigate whether the prompt experience is engaging in
the moment but does not create a strong reason to return.

If personalization does not improve engagement:

→ Reconsider the personalization mechanism, the relevance of
the personality/mood inputs, or the broader reflection
experience.

If activation remains the dominant bottleneck:

→ Prioritize getting more users into the first meaningful
reflection experience before optimizing later-stage
personalization.

---

## Current Limitations

All data in this analysis is synthetic.

The onboarding cohort comparison provides evidence of an
association between the variant experience and stronger
post-activation engagement, but does not by itself establish
causality for a specific feature.

The personalization comparison is observational because
users were not randomly assigned to personalized versus
non-personalized experiences.

The non-personalized group is also substantially smaller
than the personalized group:

- Personalized: 901 users
- Not personalized: 106 users

Therefore, the personalization result should not be used to
claim that personalized prompts increase or decrease
engagement.

The current dataset also does not directly record whether
personality or mood information was actually incorporated
into the generated prompt.

A future randomized experiment with explicit personalization
instrumentation is therefore required to test the
personalization hypothesis directly.
