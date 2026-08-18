# NiyyahLy Retention Analysis

## Purpose

This analysis measures whether users who reach activation
continue returning to NiyyahLy and saving journals after their
initial meaningful experience.

Retention is measured at D1, D7, D14 and D30 after activation.

---

## Retention Population

The retention population consists of activated users only.

Activation is defined as:

> The user's first `journal_saved` event.

Therefore:

- Activation day = Day 0
- D1 = one calendar day after activation
- D7 = seven calendar days after activation
- D14 = fourteen calendar days after activation
- D30 = thirty calendar days after activation

Users who never activate are not included in the retention
denominator.

---

## Retention Definition

A user is considered retained at a milestone if they save at
least one journal on that specific calendar day.

For example:

### D7 retention

A user is D7 retained if they save at least one journal exactly
seven days after their activation date.

The user does not need to save multiple journals.

---

## Important Interpretation

Milestone retention does NOT measure continuous engagement.

For example:

A user who saves one journal on D30 is counted as D30 retained,
even if they were inactive throughout most of the preceding
30 days.

Similarly:

D30 retention does not mean:

- the user saved 30 journals
- the user used the app for 30 days
- the user maintained a 30-day streak

It only means the user had at least one `journal_saved` event
on the D30 calendar day.

---

## Why Retention and Engagement Are Separate

Milestone retention answers:

> Do activated users return at important points after activation?

The 30-day engagement analysis answers a different question:

> Do activated users continue using the journal throughout the
30-day period?

Therefore the project uses two complementary measures.

### Retention

- D1
- D7
- D14
- D30

### 30-Day Engagement

- Journal active days
- Longest journal streak
- Four-period consistency

The engagement metrics provide a stronger view of sustained
product usage.

---

## Overall Retention

The primary retention analysis reports:

- Activated users
- D1 retained users and rate
- D7 retained users and rate
- D14 retained users and rate
- D30 retained users and rate

The denominator for all milestone retention rates is the number
of activated users.

---

## Experiment Cohort Comparison

Retention is also compared between:

- Control
- Variant

This comparison helps determine whether the onboarding
experience is associated with differences in post-activation
return behavior.

However, cohort differences should be interpreted as observed
differences in this synthetic dataset rather than automatically
ascribing the difference to a specific product feature.

---

## Relationship to the 30-Day Engagement Analysis

The retention analysis should not be used alone to judge whether
the journal experience is creating sustained usage.

The 30-day engagement analysis provides additional evidence by
measuring:

- how many distinct days users saved journals
- their longest consecutive active streak
- whether they remained active across multiple periods of the
  30-day window

These measures better capture repeated usage over time.

---

## Analytical Limitation

D30 retention is a milestone measure rather than a continuous
engagement measure.

Because of this, D30 retention should not be interpreted as
evidence that a user consistently used NiyyahLy throughout the
30-day period.

The stronger product-health assessment should combine milestone
retention with sustained 30-day engagement.
