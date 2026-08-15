# NiyyahLy Activation Analysis

## Product Question

After completing onboarding, do users reach NiyyahLy's core reflection experience?

---

## Background

The onboarding analysis identified a potential opportunity to reduce onboarding friction.

The original product idea was based on the observation that some users may leave during onboarding, particularly when they are required to complete a personality-related step.

The lower-friction onboarding concept allows users to either:

- Select an MBTI type they already identify with
- Complete the personality test
- Skip the test when appropriate

The purpose of this analysis is to determine whether differences in onboarding behavior continue into the core NiyyahLy product experience.

---

## Hypothesis

A lower-friction onboarding experience may help more users reach the core NiyyahLy reflection experience.

The analysis therefore examines whether the variant cohort has:

1. A higher activation rate
2. A higher activation rate among onboarding completers
3. A shorter time to activation

The analysis also examines whether activation differs across important user segments.

---

## Dataset

This analysis uses the synthetic NiyyahLy Product Analytics V1 dataset.

The dataset contains:

- 3,000 synthetic users
- 110,519 synthetic product events
- Control and variant onboarding cohorts
- MBTI familiarity
- Onboarding paths
- Platform information
- Product interaction events
- Downstream retention events

No real NiyyahLy customer data is used.

---

# Activation Definition

## What is Activation?

For this portfolio, activation represents a user reaching the core NiyyahLy reflection experience.

A user is classified as **activated** when all of the following events occur within 24 hours of their `signup_completed` event:

1. `onboarding_completed`
2. `mood_selected`
3. `topic_selected`
4. `tone_selected`
5. `prompt_generation_completed`
6. `journal_saved`

The activation journey is therefore:

```text
signup_completed
        ↓
onboarding_completed
        ↓
mood_selected
        ↓
topic_selected
        ↓
tone_selected
        ↓
prompt_generation_completed
        ↓
journal_saved
        ↓
ACTIVATED
