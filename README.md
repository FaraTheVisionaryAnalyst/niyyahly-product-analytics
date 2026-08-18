# NiyyahLy Product Analytics

## Product Analytics Case Study

NiyyahLy is a synthetic digital reflection product designed to help users engage with guided journaling and personal reflection.

This project demonstrates an end-to-end Product Analytics workflow using synthetic product event data.

The analysis focuses on the product journey:

```text
Onboarding
    ↓
Activation
    ↓
Retention
    ↓
30-Day Engagement
    ↓
Personalization Hypothesis
````

The project explores how onboarding design, activation, user behavior and personalization relate to downstream engagement.

---

# Business Problem

The NiyyahLy onboarding experience includes a personality-related step.

The original onboarding experience requires users to complete a personality test, while a proposed lower-friction experience gives users additional flexibility.

The initial product hypothesis was:

> Reducing onboarding friction may help more users complete onboarding and reach the core reflection experience.

The analysis therefore investigates:

1. Does the lower-friction onboarding experience improve onboarding completion?
2. Does it increase activation?
3. Once users activate, do they return to the product?
4. Does the onboarding experience relate to downstream retention?
5. What does continued 30-day journal engagement look like?
6. Is MBTI-based personalization associated with stronger engagement?
7. What product opportunity should be prioritized next?
8. What experiment is required to test the personalization hypothesis more rigorously?

---

# Experiment Design

The synthetic dataset models one NiyyahLy product with two concurrently running onboarding experiences.

```text
                         NiyyahLy
                            │
                    Experiment assignment
                            │
              ┌─────────────┴─────────────┐
              │                           │
           CONTROL                     VARIANT
              │                           │
       mandatory_test          Lower-friction onboarding
                                      │
                              ┌───────┴────────┐
                              │                │
                         self_select      test_or_skip
```

### Control

Users receive the original onboarding experience:

`mandatory_test`

### Variant

Users receive a lower-friction onboarding experience that allows different paths, including:

* `self_select`
* `test_or_skip`

`cohort` represents the experiment assignment.

`onboarding_path` represents the observed path through onboarding and is therefore treated as a behavioral segmentation variable rather than an independent experimental group.

The control and variant cohorts are modeled as running concurrently within the same overall experiment period.

---

# Dataset

The project uses synthetic NiyyahLy Product Analytics V1 data.

The dataset contains:

* 3,000 synthetic users
* 110,519 synthetic product events
* Control and variant experiment cohorts
* Onboarding path information
* MBTI familiarity
* Platform information
* Product interaction events
* Journal activity
* Downstream retention events

No real customer data is used.

---

# Analytical Approach

The project follows a structured Product Analytics workflow:

```text
Raw Synthetic Data
        ↓
Data Quality Checks
        ↓
Analytical Data Model
        ↓
Onboarding Analysis
        ↓
Activation Analysis
        ↓
Retention Analysis
        ↓
30-Day Engagement Analysis
        ↓
Personalization Exploration
        ↓
Product Recommendations
```

The analysis is performed using BigQuery and SQL, with GitHub used for version control and documentation.

---

# Tools

* **BigQuery** — SQL analysis and analytical data modeling
* **SQL** — Data quality checks, transformations and product analysis
* **Python** — Supporting analytical workflow
* **Tableau** — Product analytics visualization
* **GitHub** — Documentation, SQL version control and portfolio presentation

---

# Onboarding Analysis

## Product Question

Does reducing onboarding friction help more users reach the NiyyahLy reflection experience?

The onboarding completion rate is defined as:

```text
Completed onboarding
/
Users who started onboarding
```

## Overall Result

**3,000 users** started onboarding.

**2,192 users** completed onboarding.

Overall onboarding completion:

**73.1%**

| Cohort  | Users | Onboarding Completion |
| ------- | ----: | --------------------: |
| Control | 1,505 |                 69.0% |
| Variant | 1,495 |                 77.1% |

The variant had an approximately **8.1 percentage-point higher onboarding completion rate** than the control.

The result is directionally consistent with the hypothesis that reducing onboarding friction may help more users complete onboarding.

---

# Activation Analysis

## Product Question

After completing onboarding, do users reach NiyyahLy's core reflection experience?

Activation represents reaching the core NiyyahLy reflection experience.

A user is classified as activated when all of the following events occur within 24 hours of signup:

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
```

## Overall Activation

There were:

* 3,000 total users
* 2,192 onboarding completers
* 1,007 activated users

Activation among onboarding completers:

**45.9%**

| Cohort  | Users | Onboarding Completion | Activation Rate |
| ------- | ----: | --------------------: | --------------: |
| Control | 1,505 |                 69.0% |           30.3% |
| Variant | 1,495 |                 77.1% |           36.9% |

The variant showed a higher activation rate than the control.

The analysis therefore provides directional evidence that the lower-friction onboarding experience is associated with better progression into the core product experience.

---

# Retention Analysis

## Product Question

Once users reach activation, do they return to NiyyahLy and save journals again?

Retention is now measured **among activated users only**.

This is an important change from the earlier signup-based retention analysis.

The retention population consists of:

**1,007 activated users**

Activation is defined by the user's first `journal_saved` event.

Therefore:

```text
Activation = Day 0
D1         = 1 day after activation
D7         = 7 days after activation
D14        = 14 days after activation
D30        = 30 days after activation
```

The retention mart contains **one row per activated user**.

---

## Retention Definition

A user is considered retained at a milestone if they save at least one journal on that specific calendar day after activation.

For example:

```text
Activation: January 1

D1:  January 2
D7:  January 8
D14: January 15
D30: January 31
```

A user who saves multiple journals on D30 is still counted as **one D30-retained user**.

A user who saves one journal on D30 is also counted as **one D30-retained user**.

Therefore:

> D30 retention does not mean 30 journals, 30 active days, or a 30-day streak.

It is a **milestone retention measurement**, not a continuous-engagement measurement.

---

## Why Retention and Engagement Are Separate

Milestone retention answers:

> Do activated users return at specific points after activation?

The 30-day engagement analysis answers:

> Do activated users continue using the journal throughout the 30-day period?

These are different questions.

```text
RETENTION

Activation
    ↓
D1
    ↓
D7
    ↓
D14
    ↓
D30
```

versus:

```text
SUSTAINED ENGAGEMENT

Activation
    ↓
Days 1–30
    ↓
Active days
Longest streak
4-period consistency
```

A user can be D30 retained while having very little activity during the rest of the 30-day period.

For that reason, milestone retention should not be used alone to judge the quality of the journal experience.

---

# Overall Retention Results

The corrected retention analysis uses the **1,007 activated users** as the denominator.

The final D1, D7, D14 and D30 rates should be taken from the validated output of:

`sql/05_retention/02_retention_analysis.sql`

and not from the previous signup-based analysis.

This distinction is important because the previous retention table used all 3,000 signed-up users as the denominator.

The corrected analysis measures:

```text
Retained activated users
/
Activated users
```

rather than:

```text
Retained signed-up users
/
All signed-up users
```

---

# Retention by Experiment Cohort

Retention can also be compared between:

* Control
* Variant

This comparison answers:

> Among users who activated, does milestone retention differ between the two onboarding cohorts?

This is a more focused question than comparing retention across all signed-up users.

However, the result should still be interpreted as an observed cohort difference rather than definitive causal evidence for a specific onboarding feature.

The experiment cohort comparison should be generated from the corrected activated-user retention mart.

---

# Retention Interpretation

The D1, D7, D14 and D30 measurements should not be interpreted as sequential funnel stages.

For example:

```text
D1 = 25%
D7 = 20%
D14 = 14%
D30 = 8%
```

does not mean that exactly 25% moved to D7 and then 20% of those users moved to D14.

Each milestone has its own definition:

> Did the activated user save at least one journal on this specific calendar day?

The later checkpoints may have smaller populations and therefore should be interpreted cautiously.

In particular, D30 retention should not be used by itself to conclude that long-term engagement is poor or strong.

The 30-day engagement analysis provides the additional context required to evaluate sustained usage.

---

# 30-Day Post-Activation Engagement

## Why a Second Engagement Measure Is Needed

Exact-day retention provides useful information about whether users returned on D1, D7, D14 or D30.

However, it does not measure how consistently users used the journal during the entire 30-day period.

For example:

> A user who saves one journal on Day 30 is counted as D30 retained.

This does **not** mean that the user saved 30 journals or used the product consistently throughout the month.

Therefore, a separate post-activation engagement analysis was introduced.

The population for this analysis is **activated users only**.

Activation day is treated as Day 0.

The 30-day engagement window measures activity during Days 1–30 after activation.

---

## Active Journal Days

`journal_active_days_30d` measures the number of distinct calendar days on which an activated user saved at least one journal during the 30-day post-activation period.

Among 1,007 activated users:

| Metric                      |    Result |
| --------------------------- | --------: |
| Average active journal days |  **4.67** |
| Median active journal days  |     **5** |
| Minimum                     |     **0** |
| Maximum                     |    **12** |
| Active at least 1 day       | **99.1%** |
| Active at least 3 days      | **86.0%** |
| Active at least 7 days      | **17.6%** |
| Active at least 10 days     |  **1.5%** |

This indicates that most activated users returned at least occasionally, but relatively few demonstrated high-frequency journal usage.

---

## Longest Journal Streak

`longest_journal_streak_30d` measures the longest sequence of consecutive calendar days on which an activated user saved at least one journal.

Among activated users:

| Metric                 |        Result |
| ---------------------- | ------------: |
| Average longest streak | **1.62 days** |
| Median longest streak  |     **1 day** |
| Maximum                |    **5 days** |
| At least 1-day streak  |     **99.1%** |
| At least 2-day streak  |     **49.7%** |
| At least 3-day streak  |     **10.8%** |
| At least 5-day streak  |      **0.2%** |

The low median streak indicates that sustained consecutive daily behavior is currently uncommon.

However, streak length should be treated as a supporting engagement metric rather than the primary product success metric.

---

## 30-Day Consistency

The 30-day period is divided into four post-activation consistency periods:

```text
Period 1 → Days 1–7
Period 2 → Days 8–14
Period 3 → Days 15–21
Period 4 → Days 22–30
```

A user is considered active in a period if they save at least one journal during that period.

This measures whether engagement is distributed across the month rather than concentrated in a short burst.

Among activated users:

| Metric                           | Control | Variant |
| -------------------------------- | ------: | ------: |
| Activated users                  |     456 |     551 |
| Average active days              |    4.27 |    5.01 |
| Median active days               |       4 |       5 |
| Average longest streak           |    1.57 |    1.66 |
| Median longest streak            |       1 |       2 |
| Active across at least 3 periods |   60.1% |   72.1% |
| Active across all 4 periods      |   18.2% |   31.4% |

The variant showed stronger sustained engagement across the 30-day period.

The difference in the percentage active across all four periods was:

**+13.20 percentage points**

A two-proportion z-test produced:

**z = 4.79**

This indicates a statistically significant difference in the synthetic experiment dataset.

However, the result should still be interpreted as an observed cohort difference and not automatically attributed to a specific product feature.

---

# Personalization Exploration

## Product Hypothesis

The next product hypothesis is:

> Users who receive reflection prompts personalized using their personality profile and current mood may demonstrate stronger sustained engagement than users receiving non-personalized prompts.

The expected mechanism is that more personally relevant reflection prompts may make users feel more understood and increase their motivation to continue using the reflection experience.

---

## Personalization Exposure

`knows_mbti` alone is not a sufficient measure of personalization exposure.

Users who initially do not know their MBTI may:

* complete the personality test
* receive an MBTI result
* subsequently become eligible for personalized content

Users who already know their MBTI may also select their MBTI directly.

Therefore, MBTI familiarity should not be treated as a direct proxy for whether a personalized prompt was actually delivered.

---

## Exploratory Personalization Result

The current analysis identifies:

| Personalization Group | Activated Users | Average Active Journal Days | Active Across All 4 Periods |
| --------------------- | --------------: | --------------------------: | --------------------------: |
| Personalized          |             901 |                        4.64 |                      24.31% |
| Not personalized      |             106 |                        4.93 |                      34.91% |

The observed result does not support the original hypothesis descriptively.

However, this should **not** be interpreted as evidence that personalization reduces engagement.

There are two important limitations.

### 1. Exposure was not randomized

Users did not randomly enter the personalized and non-personalized groups.

The observed comparison is therefore:

```text
Personalization exposure
        +
User characteristics
        +
User onboarding behavior
        ↓
Observed engagement
```

rather than a clean randomized experiment.

Therefore:

> Observed difference ≠ causal effect.

### 2. The comparison group is small

Only **106 activated users** were classified as not personalized, compared with **901 personalized users**.

The substantial group imbalance further limits the reliability of the comparison.

The personalization result should therefore be treated as **exploratory evidence only**.

---

# Main Product Opportunities

The current analysis identifies two immediate product opportunities.

## Opportunity 1 — Improve Activation

The largest early funnel loss occurs before users reach the core reflection experience.

Of the:

**2,192 onboarding completers**

only:

**1,007 activated**

This represents:

**45.9% activation among onboarding completers.**

The immediate priority is therefore to improve the transition from onboarding completion into the first meaningful reflection experience.

Potential areas for investigation include:

* Clarity of the next action
* Friction before the first reflection
* Value communication
* User motivation at the transition
* Whether the reflection experience is immediately understandable

---

## Opportunity 2 — Improve Sustained Engagement

Activation is associated with substantially stronger downstream return behavior.

However, activated users still demonstrate relatively shallow repeated usage.

Among activated users:

* Average active journal days: **4.67**
* Median active journal days: **5**
* 17.6% reached at least 7 active days
* 1.5% reached at least 10 active days
* Median longest streak: **1 day**

This suggests that an important product objective is not simply getting users to return once.

It is helping users develop a sustainable reflection habit.

The 30-day consistency metric is therefore particularly useful for evaluating this objective.

---

# Product Interpretation

The V1 analysis identifies three related but distinct product questions.

## Question 1: How do we get more users to experience the core product value?

The activation analysis shows a substantial gap between onboarding completion and activation.

Improving the onboarding-to-reflection transition should therefore be the immediate product priority.

---

## Question 2: What makes users continue engaging after activation?

Activated users are the appropriate population for evaluating post-activation retention and engagement.

The retention analysis measures whether they return at specific milestones.

The 30-day engagement analysis measures whether they continue using the journal throughout the month.

The second question is particularly important because a single D30 return does not establish a sustained habit.

---

## Question 3: Does personalization increase sustained engagement?

The current observational personalization comparison does not show stronger engagement among users classified as personalized.

However, the result cannot establish causality because personalization was not randomly assigned.

Therefore, the current data does not prove or disprove the personalization hypothesis.

---

# Recommended Product Roadmap

```text
CURRENT V1
    │
    ├── Improve onboarding → reflection transition
    │
    ↓
Increase activation
    │
    ↓
Measure sustained post-activation engagement
    │
    ↓
────────────────────────────────
NEXT EXPERIMENT
    │
    ↓
Randomize personalization
    │
    ├── Control
    │     Generic reflection prompt
    │
    └── Variant
          Personality + mood personalized prompt
    │
    ↓
Measure 30-day engagement
    │
    ├── Primary:
    │     Active across all 4 periods
    │
    └── Supporting:
          Active journal days
          D1 / D7 / D14 / D30 retention
          Longest streak
```

The sequence prioritizes activation first, then sustained engagement, and finally a controlled test of personalization.

---

# Recommended Future Experiment

The next personalization experiment should randomly assign eligible users to:

### Control

Standard reflection prompt.

### Variant

Reflection prompt incorporating:

* Personality information
* Current mood
* Reflection topic

The experiment should keep all other aspects of the reflection experience as consistent as possible.

The primary success metric should be:

**Percentage of activated users active across all four 30-day consistency periods.**

Supporting metrics should include:

* Active journal days
* D1 retention
* D7 retention
* D14 retention
* D30 retention
* Longest journal streak

---

# Required Future Instrumentation

The product should explicitly record whether personalization was actually available and used.

Recommended events or fields include:

* `personality_context_available`
* `mood_context_available`
* `personality_context_used`
* `mood_context_used`
* `prompt_personalized`
* `prompt_generation_completed`
* `journal_saved`

This would allow future analysis to distinguish between:

```text
Personality information exists
        ↓
Personality information available
        ↓
Personality information used
        ↓
Mood information used
        ↓
Prompt personalized
        ↓
Journal saved
        ↓
Repeat engagement
```

This instrumentation would provide a much stronger basis for evaluating the personalization hypothesis.

---

# Decision Framework

If personalization produces a meaningful improvement in sustained engagement:

→ Continue investing in personalized reflection.

If personalization improves immediate prompt interaction but does not improve sustained engagement:

→ Investigate whether the experience is engaging in the moment but does not create a strong reason to return.

If personalization does not improve engagement in a properly randomized experiment:

→ Reconsider the personalization mechanism, the relevance of personality and mood inputs, or the broader reflection experience.

If activation remains the dominant bottleneck:

→ Prioritize getting more users into the first meaningful reflection experience before optimizing later-stage personalization.

---

# Data Quality and Analytical Modeling

The project includes explicit data quality checks before analysis.

The analytical model separates raw event-level data from user-level analytical tables.

```text
Raw synthetic data
        ↓
facts_events
        ↓
Analytical marts
        ├── mart_onboarding
        ├── mart_activation
        ├── mart_retention
        └── mart_30d_post_activation
```

The analytical marts provide reusable tables for product analysis rather than repeatedly querying the raw event data.

The retention mart contains:

* One row per activated user
* Activation date
* D1 retention flag
* D7 retention flag
* D14 retention flag
* D30 retention flag

The 30-day post-activation engagement mart uses:

* One row per activated user
* Distinct journal-active days
* Longest consecutive journal streak
* Four consistency periods across the 30-day window

---

# SQL and Documentation Structure

The SQL is organized by analytical stage.

```text
sql/
│
├── 01_data_quality/
│   ├── 01_users_quality_check.sql
│   └── 02_events_quality_check.sql
│
├── 02_analytical_model/
│   ├── 01_create_dim_users.sql
│   ├── 02_create_fact_events.sql
│   └── 03_validate_analytical_tables.sql
│
├── 03_onboarding/
│   ├── 01_create_mart_onboarding.sql
│   └── 02_onboarding_analysis.sql
│
├── 04_activation/
│   ├── 01_create_mart_activation.sql
│   └── 02_activation_analysis.sql
│
├── 05_retention/
│   ├── 01_create_mart_retention.sql
│   └── 02_retention_analysis.sql
│
└── 06_engagement/
    ├── 01_create_mart_30d_post_activation.sql
    ├── 02_30d_engagement_analysis.sql
    └── 03_personalization_exposure.sql
```

Detailed analysis documentation is stored in:

```text
documentation/
```

including:

* `DATA_DICTIONARY.md`
* `DATA_MODEL.md`
* `DATA_QUALITY_CHECKS.md`
* `METRIC_DEFINITIONS.md`
* `ONBOARDING_ANALYSIS.md`
* `ACTIVATION_ANALYSIS.md`
* `RETENTION_ANALYSIS.md`
* `ENGAGEMENT_NEXT_STEPS.md`

---

# Tableau

The validated BigQuery outputs will be used to build a Tableau product analytics dashboard.

The dashboard should focus on the product journey:

```text
Onboarding
    ↓
Activation
    ↓
Retention
    ↓
Sustained Engagement
```

The visualization should emphasize:

* Funnel progression
* Control vs variant comparison
* Activation performance
* Retention checkpoints
* 30-day engagement
* Consistency across the 30-day period
* Key product opportunities

The personalization analysis should be presented as an **exploratory finding**, not as a causal experiment result.

The Tableau dashboard should be based on validated analytical tables and documented metrics rather than directly connecting to raw event data.

---

# Limitations

This project uses synthetic data and is intended as a Product Analytics portfolio case study.

The observed differences between cohorts should not be treated as definitive causal evidence without appropriate experiment validation.

A real-world experiment would require:

* Valid random assignment
* Experiment exposure validation
* Sample-size planning
* Statistical significance testing
* Confidence intervals
* Experiment balance checks
* Monitoring for experiment duration and seasonality
* Evaluation of potential confounding factors

The onboarding-path analysis requires additional caution because users may select different paths within the variant experience.

The personalization analysis has additional limitations:

* Personalization exposure is inferred from onboarding behavior
* The current dataset does not directly record personalized prompt delivery
* The non-personalized comparison group contains only 106 activated users
* Personalized and non-personalized users were not randomly assigned

Therefore, the personalization comparison cannot establish a causal effect.

Retention is measured using `journal_saved`, which represents meaningful reflection activity.

D1, D7, D14 and D30 are separate calendar-day retention measurements rather than sequential churn stages.

The later retention checkpoints should be interpreted cautiously because fewer users remain active at those specific milestones.

Most importantly, milestone retention should not be interpreted as a measure of continuous 30-day product usage.

The 30-day engagement analysis provides the stronger evidence for repeated usage over the full post-activation period.

---

# Conclusion

The V1 analysis suggests that the lower-friction onboarding experience is associated with higher onboarding completion and activation.

The clearest immediate product opportunity is improving the transition from onboarding completion into the core reflection experience.

Once users activate, milestone retention provides a useful view of whether they return at specific points after their first meaningful experience.

However, milestone retention alone does not tell us whether users develop a sustained journaling habit.

The 30-day engagement analysis therefore adds an important second layer by measuring active days, streak behavior and consistency across the month.

The strongest experiment-level engagement signal is the difference in four-period consistency between the control and variant cohorts.

The exploratory personalization analysis does not show higher engagement among users classified as personalization-exposed. However, this comparison is observational and includes a much smaller non-personalized group, so it cannot establish whether personalization itself improves or reduces engagement.

The next product stage should therefore:

1. Improve activation and the onboarding-to-reflection transition.
2. Optimize for sustained post-activation engagement rather than single-day retention alone.
3. Instrument personalization exposure directly.
4. Run a randomized experiment comparing generic versus personality- and mood-personalized reflection prompts.
5. Measure sustained 30-day engagement as the primary outcome.

This creates a clear progression from:

```text
Understand the funnel
        ↓
Improve activation
        ↓
Improve sustained engagement
        ↓
Test personalization causally
```

The goal is not simply to increase the number of users who return once.

The longer-term product goal is to create a reflection experience that users find sufficiently valuable and personally relevant to return to consistently over time.

```
