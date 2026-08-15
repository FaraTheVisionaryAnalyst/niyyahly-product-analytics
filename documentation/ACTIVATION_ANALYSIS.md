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
````

---

# Analytical Grain

The `mart_activation` table has a **one-row-per-user** grain.

Each row represents one synthetic NiyyahLy user.

The table combines user attributes from `dim_users` with the first relevant product events from `facts_events`.

Important fields include:

* `user_id`
* `cohort`
* `onboarding_version`
* `onboarding_path`
* `knows_mbti`
* `platform`
* `signup_completed_at`
* `onboarding_completed_at`
* `first_mood_selected_at`
* `first_topic_selected_at`
* `first_tone_selected_at`
* `first_prompt_generated_at`
* `first_journal_saved_at`
* `activated`

---

# Activation Funnel

The activation funnel is analyzed as:

```text
All Users
    ↓
Onboarding Completed
    ↓
Mood Selected
    ↓
Topic Selected
    ↓
Tone Selected
    ↓
Prompt Generated
    ↓
Journal Saved
    ↓
Activated
```

This funnel helps identify where users fail to progress toward the core product experience.

---

# Key Metrics

## 1. Overall Activation Rate

### Definition

```text
Activated Users / Total Users
```

This metric answers:

> What percentage of all users reached the defined Niyyahly core experience within 24 hours of signup?

### Result

- Total users: 3,000
- Activated users: 1,007
- Activation rate: **33.57%**

This means that approximately 33.57% of users reached the defined Niyyahly core reflection experience within 24 hours of signup.

---

## 2. Activation Among Onboarding Completers

### Definition

```text
Activated Users / Users Who Completed Onboarding
```

This metric answers:

> Once users successfully complete onboarding, how many continue to the core reflection experience?

### Result

- Total users: 3000
- Onboarding completers: 2192
- Activated users: 1007
- Activation rate among onboarding completers: **0.459**


This metric measures the proportion of users who reached the defined activation experience after successfully completing onboarding.

---

## 3. Activation by Experiment Cohort

Activation will be compared between:

* Control
* Variant

This analysis evaluates whether the lower-friction onboarding experience is associated with different downstream activation behavior.

### Metrics

For each cohort:

* Total users
* Onboarding completion rate
* Activation rate
* Activation rate among onboarding completers

### Result

| Cohort | Users | Onboarding Completers | Onboarding Completion Rate | Activated Users | Activation Rate | Activation Rate Among Completers |
|---|---:|---:|---:|---:|---:|---:|
| Control | 1,505 | 1,039 | 69.04% | 456 | 30.30% | 43.89% |
| Variant | 1,495 | 1,153 | 77.12% | 551 | 36.86% | 47.79% |

The variant cohort had a higher activation rate than the control cohort:

- Control activation rate: **30.30%**
- Variant activation rate: **36.86%**
- Difference: **6.56 percentage points**

Activation among users who completed onboarding was also higher in the variant:

- Control: **43.89%**
- Variant: **47.79%**
- Difference: **3.90 percentage points**

These results indicate that the variant was associated with higher downstream activation as well as higher onboarding completion in this synthetic dataset.

---

## 4. Activation Lift

The difference between the variant and control cohorts will be evaluated using:

### Absolute lift

```text
Variant Activation Rate - Control Activation Rate
```

This will be reported in **percentage points**.

### Relative lift

```text
(Variant Activation Rate - Control Activation Rate)
/
Control Activation Rate
```

This expresses the difference relative to the control cohort.

### Result

- Control activation rate: **30.30%**
- Variant activation rate: **36.86%**
- Absolute lift: **6.56 percentage points**
- Relative lift: **21.64%**

The variant activation rate was 6.56 percentage points higher than the control activation rate.

Relative to the control cohort, the variant showed a 21.64% higher activation rate.

This suggests that the lower-friction onboarding experience was associated with stronger downstream activation in the synthetic dataset.

The result should not be interpreted as proof of a causal product impact without further statistical evaluation of the experiment.

---

# Time to Activation

## Definition

Time to activation is measured as:

```text
first_journal_saved_at - signup_completed_at
```

Only users classified as activated are included.

Both average and median time will be examined.

### Why Use Both Average and Median?

The **average** provides an overall measure of elapsed time.

The **median** represents the middle user and is less affected by unusually long journeys.

### Metrics

* Average minutes to activation
* Median minutes to activation

### Result

| Cohort | Activated Users | Average Minutes to Activation | Median Minutes to Activation |
|---|---:|---:|---:|
| Control | 456 | 46.35 | 44 |
| Variant | 551 | 46.42 | 43 |

The average time to activation was almost identical between the two cohorts:

- Control: **46.35 minutes**
- Variant: **46.42 minutes**

The median time to activation was:

- Control: **44 minutes**
- Variant: **43 minutes**

The variant therefore showed only a 1-minute difference in median time to activation.

This suggests that the lower-friction onboarding experience was associated with a higher proportion of users reaching activation, but it did not materially change the time required for activated users to reach their first saved journal.

This distinction is important: the primary difference between the cohorts appears to be **whether users reach activation**, rather than **how quickly activated users reach it**.

---

# Reflection Journey Duration

In addition to signup-to-activation time, the analysis examines the active reflection journey itself.

This is measured as:

```text
first_journal_saved_at - first_mood_selected_at
```

This metric is intended to represent the time spent progressing through the core reflection experience.

It avoids interpreting the entire elapsed period between signup and first product use as active product interaction.

### Metrics

* Average reflection journey duration
* Median reflection journey duration

### Result

| Cohort | Activated Users | Average Reflection Journey | Median Reflection Journey |
|---|---:|---:|---:|
| Control | 456 | 20.02 minutes | 20 minutes |
| Variant | 551 | 19.89 minutes | 20 minutes |

The reflection journey duration was very similar between the two cohorts.

- Control average: **20.02 minutes**
- Variant average: **19.89 minutes**
- Control median: **20 minutes**
- Variant median: **20 minutes**

The difference in average reflection journey duration was approximately **0.12 minutes**, or about **7 seconds**.

This suggests that the lower-friction onboarding experience was associated with more users reaching activation, but it did not materially change the duration of the core reflection journey among users who activated.

This provides an important distinction between **activation volume** and **activation experience**: the variant appears to improve the number of users reaching the core experience, while the time spent progressing through that experience remains broadly similar.

---

# Activation by MBTI Familiarity

MBTI familiarity is analyzed as a user segment.

Users are divided into:

* `knows_mbti = true`
* `knows_mbti = false`

The analysis examines whether activation differs between these groups.

### Metrics

* Number of users
* Onboarding completion rate
* Activation rate
* Activated users

### Important Interpretation Note

A difference between MBTI familiarity groups should be interpreted as an association rather than a causal effect.

For example:

> If users familiar with MBTI have a higher activation rate, this does not mean that MBTI familiarity causes higher activation.

Other differences between the groups may contribute to the observed relationship.

### Result

| MBTI Familiarity | Users | Onboarding Completers | Onboarding Completion Rate | Activated Users | Activation Rate |
|---|---:|---:|---:|---:|---:|
| Does not know MBTI | 1,689 | 1,179 | 69.80% | 526 | 31.14% |
| Knows MBTI | 1,311 | 1,013 | 77.27% | 481 | 36.69% |

Users who already knew their MBTI had a higher activation rate than users who did not:

- Does not know MBTI: **31.14%**
- Knows MBTI: **36.69%**
- Difference: **5.55 percentage points**

The same pattern was observed during onboarding. Users who knew their MBTI had a higher onboarding completion rate than users who did not know their MBTI.

This suggests that MBTI familiarity is associated with stronger progression through both onboarding and activation in the synthetic dataset.

However, this should not be interpreted as evidence that MBTI familiarity causes higher activation. MBTI familiarity may be related to other user characteristics or behaviors that are not controlled for in this analysis.

---

# Activation by Platform

Activation is also analyzed by platform.

The analysis examines whether users on different platforms show different activation behavior.

### Metrics

* Number of users
* Activated users
* Activation rate

### Result

| Platform | Users | Activated Users | Activation Rate |
|---|---:|---:|---:|
| Web | 284 | 100 | 35.21% |
| Android | 1,253 | 419 | 33.44% |
| iOS | 1,463 | 488 | 33.36% |

Activation rates were relatively similar across platforms:

- Web: **35.21%**
- Android: **33.44%**
- iOS: **33.36%**

Web had the highest activation rate, but the difference between platforms was relatively small. The difference between Web and iOS was approximately **1.85 percentage points**.

Based on this analysis, platform does not appear to be a major source of activation differences in the synthetic dataset.

This segmentation is useful as a diagnostic check, but the relatively small differences do not provide strong evidence of a platform-specific activation problem.

---

# Activation Funnel Analysis

The following stages will be compared:

| Funnel Stage         | Metric                                     |
| -------------------- | ------------------------------------------ |
| Signup               | Total users                                |
| Onboarding completed | Users completing onboarding                |
| Mood selected        | Users reaching reflection                  |
| Topic selected       | Users selecting a topic                    |
| Tone selected        | Users selecting a tone                     |
| Prompt generated     | Users receiving a generated prompt         |
| Journal saved        | Users saving a journal                     |
| Activated            | Users completing the activation definition |

The purpose is to identify where the largest amount of user drop-off occurs.

### Result

| Funnel Stage | Users | Conversion from Previous Stage |
|---|---:|---:|
| Total users | 3,000 | — |
| Onboarding completed | 2,192 | 73.07% |
| Reached reflection | 1,008 | 45.99% |
| Selected topic | 1,008 | 100.00% |
| Selected tone | 1,008 | 100.00% |
| Generated prompt | 1,008 | 100.00% |
| Journal saved / Activated | 1,007 | 99.90% |

The largest drop-off occurs between onboarding completion and reaching the reflection experience.

Of the 2,192 users who completed onboarding, 1,008 reached the reflection flow. This represents a conversion rate of approximately **45.99%** from onboarding completion to reflection.

Once users reached the reflection experience, progression through the remaining steps was very high:

- Topic selection: **100.00%**
- Tone selection: **100.00%**
- Prompt generation: **100.00%**
- Journal save / activation: **99.90%**

This indicates that the primary activation bottleneck in the synthetic dataset is the transition from completed onboarding into the first reflection interaction, rather than the subsequent reflection steps.

From a product perspective, this suggests that future investigation should focus on the transition between onboarding and the core reflection experience.

---

# Experiment Analysis

The main product comparison is:

```text
Control
vs.
Variant
```

The analysis will examine whether the lower-friction onboarding approach is associated with improvement beyond onboarding completion.

The key comparison is:

```text
Control onboarding
        ↓
Control activation

vs.

Variant onboarding
        ↓
Variant activation
```

The analysis will also compare:

```text
Activation among control onboarding completers

vs.

Activation among variant onboarding completers
```

This distinction is important because an onboarding redesign can increase the number of users who complete onboarding without necessarily increasing the proportion of those users who reach core product value.

---

# Initial Observations

**To be completed after the BigQuery analysis.**

The observations will focus on:

1. Overall activation
2. Control vs. variant activation
3. Activation among onboarding completers
4. Activation lift
5. Time to activation
6. Reflection journey duration
7. MBTI familiarity differences
8. Platform differences
9. Major funnel drop-off points

No conclusions will be written until the SQL results have been reviewed.

---

# Product Interpretation

**To be completed after the analysis.**

The final interpretation will answer:

> Does the lower-friction onboarding experience appear to help more users reach Niyyahly's core reflection experience?

The analysis will distinguish between:

### Onboarding performance

Whether users complete onboarding.

### Activation performance

Whether users progress from onboarding into the core reflection experience.

This distinction helps determine whether an improvement in onboarding actually translates into downstream product engagement.

---

# Limitations

## Synthetic Data

All data in this project is synthetic.

The results should therefore be treated as an analytical case study rather than evidence about real Niyyahly users.

---

## Experiment Interpretation

Differences between control and variant should not automatically be interpreted as causal effects.

A proper experiment evaluation would require additional statistical analysis and validation of the experimental design.

---

## MBTI Interpretation

MBTI familiarity is used as a segmentation variable.

Differences between users who know and do not know their MBTI type should not be interpreted as evidence that MBTI familiarity causes activation.

---

## Timestamp Quality Review

During development, unusually long signup-to-activation times were identified during data quality analysis.

The raw V1 event data showed that signup events were concentrated near the beginning of the day while subsequent reflection activity frequently occurred much later.

The SQL calculations were technically correct, but this synthetic timestamp pattern created an unrealistic elapsed-time distribution.

The event timestamps were therefore regenerated to provide more realistic product-session timing.

The timestamp regeneration preserved:

* 3,000 users
* 110,519 events
* User IDs
* Event IDs
* Session IDs
* Event names
* Platform information
* App versions
* Event properties
* Control and variant structure
* Onboarding behavior
* MBTI-related variables
* Downstream behavioral events

The activation population was preserved while the event timing was made more realistic.

The original raw event table was retained as a backup during the migration and quality-control process.

---

# Data Quality Checks

Before analysis, the following checks were performed on `mart_activation`:

### User grain

The table contains one row per user.

### Duplicate users

No user appears more than once.

### Activation sequence

Activated users follow the expected event sequence:

```text
signup
→ onboarding
→ mood
→ topic
→ tone
→ prompt
→ journal
```

### Activation window

Activated users complete the required journey within 24 hours of signup.

### Timestamp validation

The regenerated timestamps produce realistic elapsed times between signup and the core reflection journey.

---

# Next Product Question

The next question is:

> **Do activated users return to Niyyahly at higher rates than users who do not activate?**

This will be investigated using:

* D1 retention
* D7 retention
* D14 retention
* D30 retention

The purpose is to determine whether reaching the core reflection experience is associated with stronger ongoing product engagement.

````

## Then do only this

1. Open `documentation/ACTIVATION_ANALYSIS.md`.
2. **Select all existing content and replace it** with the complete version above.
3. Commit it with:

```text
Complete activation analysis documentation
````
