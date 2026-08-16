# NiyyahLy Retention Analysis

## Product Question

Do users return to NiyyahLy after their initial product experience?

---

## Background

The activation analysis examined whether users reached NiyyahLy's core reflection experience.

The next product question is whether users continue to engage with the product after signup.

Retention is therefore analyzed using later `journal_saved` activity.

The analysis also examines whether reaching activation is associated with stronger subsequent retention.

---

# Retention Definition

## What is Retention?

For this portfolio, retention represents a user returning to NiyyahLy and performing a meaningful core-product action after signup.

The retained activity event is:

`journal_saved`

This event was selected because saving a journal represents meaningful interaction with NiyyahLy's core reflection experience rather than simply opening the application.

---

## Retention Windows

The analysis uses four retention windows:

- D1
- D7
- D14
- D30

Retention is based on the calendar day difference between the user's signup date and the date of the `journal_saved` event.

For example:

```text
Signup date
    ↓
Day 1  → D1
Day 7  → D7
Day 14 → D14
Day 30 → D30
````

A user is considered retained at a given window when they have at least one `journal_saved` event on that specific calendar day after signup.

---

## Retention Formula

Retention rate is calculated as:

```text
Retained Users on Day N
/
Total Users
```

For example:

```text
D7 Retention
=
Users who saved a journal on D7
/
Total users
```

---

# Analytical Grain

The `mart_retention` table has a **one-row-per-user** grain.

Each user has retention flags for:

* `retained_d1`
* `retained_d7`
* `retained_d14`
* `retained_d30`

A value of `1` means the user had a `journal_saved` event on that calendar day after signup.

A value of `0` means the user did not have a qualifying `journal_saved` event on that day.

---

# Retention Analytical Table

The retention analysis uses:

```text
mart_retention
```

The table is created from:

```text
dim_users
+
facts_events
```

The retention event used from `facts_events` is:

```text
journal_saved
```

The resulting table contains one row per user and provides the D1, D7, D14 and D30 retention flags.

# SQL Analysis

The SQL used for the retention analysis is stored in:

```text
sql/05_retention/
```
The retention SQL is separated into two stages:

1. Create the analytical table

The mart_retention table is created from the user and event data.

```text
sql/05_retention/01_create_mart_retention.sql
```

This SQL transforms the event-level data into a one-row-per-user retention table containing:

User attributes
Signup information
D1 retention flag
D7 retention flag
D14 retention flag
D30 retention flag
2. Analyze retention

The retention analysis queries are stored in:

```text
sql/05_retention/02_retention_analysis.sql
```

The analysis SQL covers:

Overall retention
Retention by experiment cohort
Retention by activation status
Retention by MBTI familiarity
Retention by platform
Retention by onboarding path

The analysis queries use mart_retention as the primary analytical table.

---

# Data Quality Validation

Before performing the retention analysis, the retention mart was validated.

The following checks were completed:

### 1. User grain

The table contains one row per user.

Expected:

```text
3,000 rows
3,000 unique users
```

### 2. Retention flag counts

The retention flags were checked against the underlying event timestamps.

The observed counts were:

* D1: 334 users
* D7: 296 users
* D14: 207 users
* D30: 120 users

### 3. Retention flag values

The retention flags were checked to ensure they contain valid binary values:

```text
0 = not retained
1 = retained
```

No invalid values or NULL retention flags were found.

### 4. Duplicate users

The retention mart was checked for duplicate `user_id` values.

No duplicate users were found.

All four retention quality checks passed before analysis.

---

# Analysis Questions

The retention analysis is designed to answer the following questions:

### Question 1

What percentage of users return to NiyyahLy on D1, D7, D14 and D30?

### Question 2

Does retention differ between the control and variant onboarding cohorts?

### Question 3

Are users who reach activation more likely to return than users who do not activate?

### Question 4

Does retention differ between users who already know their MBTI and users who do not?

### Question 5

Does retention differ across Web, Android and iOS?

### Question 6

Does retention differ across the different onboarding paths?

---

# Overall Retention

## Definition

Overall retention measures the percentage of all signed-up users who save a journal on each retention day.

```text
Retained Users on Day N
/
Total Users
```

---

## Result

| Retention Window | Retained Users | Retention Rate |
| ---------------- | -------------: | -------------: |
| D1               |            334 |         11.13% |
| D7               |            296 |          9.87% |
| D14              |            207 |          6.90% |
| D30              |            120 |          4.00% |

Retention declined as the time from signup increased:

* D1: **11.13%**
* D7: **9.87%**
* D14: **6.90%**
* D30: **4.00%**

This indicates that the proportion of users returning to save a journal decreases over time.

The overall retention rate should not be directly compared with the activation rate because the two metrics measure different behaviors.

Activation measures whether users reach the core reflection experience within 24 hours of signup, while retention measures whether users return on a later calendar day and save a journal.

---

# Retention by Experiment Cohort

## Product Question

Does the lower-friction onboarding experience have an association with stronger subsequent retention?

The two cohorts are:

* Control
* Variant

---

## Result

| Cohort  | Users | D1 Retention | D7 Retention | D14 Retention | D30 Retention |
| ------- | ----: | -----------: | -----------: | ------------: | ------------: |
| Control | 1,505 |        8.84% |        8.50% |         5.91% |         3.19% |
| Variant | 1,495 |       13.44% |       11.24% |         7.89% |         4.82% |

The variant cohort had higher retention than the control cohort across every measured retention window.

Absolute differences were:

* D1: **+4.61 percentage points**
* D7: **+2.73 percentage points**
* D14: **+1.98 percentage points**
* D30: **+1.63 percentage points**

The largest absolute difference occurred at D1:

* Control: **8.84%**
* Variant: **13.44%**

The retention advantage remained visible through D30, although the difference became smaller over time.

These results show an association between the lower-friction onboarding experience and stronger subsequent retention in the synthetic dataset.

They should not yet be interpreted as proof of a causal effect.

---

# Retention Among Activated Users

## Product Question

Are users who reach the core NiyyahLy reflection experience more likely to return than users who do not activate?

This analysis connects the product funnel:

```text
Onboarding
    ↓
Activation
    ↓
Retention
```

---

## Result

| User Group    | Users | D1 Retention | D7 Retention | D14 Retention | D30 Retention |
| ------------- | ----: | -----------: | -----------: | ------------: | ------------: |
| Activated     | 1,007 |       24.83% |       21.25% |        13.90% |         8.34% |
| Not activated | 1,993 |        4.21% |        4.11% |         3.36% |         1.81% |

Users who reached activation had substantially higher retention than users who did not activate across every measured retention window.

### D1

* Activated: **24.83%**
* Not activated: **4.21%**

### D7

* Activated: **21.25%**
* Not activated: **4.11%**

### D14

* Activated: **13.90%**
* Not activated: **3.36%**

### D30

* Activated: **8.34%**
* Not activated: **1.81%**

This represents a strong association between reaching the core NiyyahLy reflection experience and subsequent engagement.

However, this analysis does not establish that activation causes retention.

Users who activate may differ from non-activated users in other characteristics or behaviors that influence their likelihood of returning.

---

# Retention by MBTI Familiarity

## Product Question

Does retention differ between users who already know their MBTI type and users who do not?

---

## Result

| MBTI Familiarity | Users | D1 Retention | D7 Retention | D14 Retention | D30 Retention |
|---|---:|---:|---:|---:|---:|
| Do not know MBTI | 1,689 | 10.42% | 9.00% | 5.92% | 3.73% |
| Know MBTI | 1,311 | 12.05% | 10.98% | 8.16% | 4.35% |

Users who already knew their MBTI had higher retention across all measured retention windows.

The absolute differences were:

- D1: **+1.63 percentage points**
- D7: **+1.98 percentage points**
- D14: **+2.24 percentage points**
- D30: **+0.72 percentage points**

The difference was largest at D14, where retention was 8.16% among users who knew their MBTI compared with 5.92% among users who did not.

The relationship is relatively small compared with the much larger retention difference observed between activated and non-activated users.

This suggests that MBTI familiarity may be associated with slightly stronger retention, but it does not appear to be the primary retention driver in this analysis.

The result should be interpreted as an association rather than evidence that MBTI familiarity causes higher retention.

---

# Retention by Platform

## Product Question

Does retention differ across Web, Android and iOS?

---

## Result

| Platform | Users | D1 Retention | D7 Retention | D14 Retention | D30 Retention |
|---|---:|---:|---:|---:|---:|
| Android | 1,253 | 11.41% | 9.58% | 7.50% | 3.67% |
| iOS | 1,463 | 11.21% | 9.84% | 6.63% | 4.17% |
| Web | 284 | 9.51% | 11.27% | 5.63% | 4.58% |

Retention was broadly similar across platforms, with no clear or consistent platform-specific retention problem.

The platform with the highest retention varied by retention window:

- D1: Android at **11.41%**
- D7: Web at **11.27%**
- D14: Android at **7.50%**
- D30: Web at **4.58%**

The Web population is substantially smaller than the Android and iOS populations, with only 284 users. Therefore, the higher Web retention observed at some later windows should be interpreted cautiously.

Overall, platform does not appear to be a major driver of retention differences in this synthetic dataset.

This analysis is a segmentation analysis and does not establish that platform causes differences in retention.

---

# Retention by Onboarding Path

## Product Question

Does retention differ across the different onboarding paths?

The onboarding paths analyzed are:

- `mandatory_test`
- `self_select`
- `test_or_skip`

---

## Result

| Onboarding Path | Users | D1 Retention | D7 Retention | D14 Retention | D30 Retention |
|---|---:|---:|---:|---:|---:|
| `mandatory_test` | 1,505 | 8.84% | 8.50% | 5.91% | 3.19% |
| `self_select` | 649 | 14.64% | 13.25% | 9.40% | 5.55% |
| `test_or_skip` | 846 | 12.53% | 9.69% | 6.74% | 4.26% |

Users in the `self_select` path had the highest observed retention across every measured retention window.

Compared with the `mandatory_test` path:

- D1 retention was **5.80 percentage points higher**
- D7 retention was **4.75 percentage points higher**
- D14 retention was **3.49 percentage points higher**
- D30 retention was **2.36 percentage points higher**

The `test_or_skip` path also had higher retention than `mandatory_test` across every measured retention window.

However, onboarding path is not an independent randomized experiment dimension. The `mandatory_test` path corresponds to the control experience, while `self_select` and `test_or_skip` occur within the variant experience.

In addition, users may have selected different paths based on their own preferences or familiarity with MBTI.

Therefore, these results should be interpreted as descriptive associations rather than evidence that a particular onboarding path causes higher retention.

The results suggest that the lower-friction variant paths are associated with stronger retention, while also highlighting the need to account for self-selection when interpreting the difference between individual onboarding paths.

---

# Initial Observations

Several important patterns emerged from the retention analysis.

## 1. Retention declines substantially over time

Overall retention decreased from **11.13% on D1** to **4.00% on D30**.

| Retention Window | Retention |
|---|---:|
| D1 | 11.13% |
| D7 | 9.87% |
| D14 | 6.90% |
| D30 | 4.00% |

This indicates that a relatively small proportion of signed-up users return to perform the defined core reflection action on later days.

The largest product opportunity therefore appears to be improving the number of users who experience enough value to return after their initial interaction.

---

## 2. The largest problem occurs before users fully reach the core product experience

The activation funnel identified a major drop between onboarding completion and reaching the reflection experience.

Of the **2,192 users who completed onboarding**, only **1,008** reached the first reflection interaction.

This represents approximately **45.99%** conversion from onboarding completion to reaching the reflection experience.

However, once users reached the reflection flow, progression through the remaining steps was extremely high.

This suggests that the primary activation opportunity is the transition from onboarding into the first reflection experience rather than the later reflection steps.

---

## 3. Activation is strongly associated with subsequent retention

Activated users showed substantially higher retention than non-activated users across every retention window.

| User Group | D1 | D7 | D14 | D30 |
|---|---:|---:|---:|---:|
| Activated | 24.83% | 21.25% | 13.90% | 8.34% |
| Not activated | 4.21% | 4.11% | 3.36% | 1.81% |

The difference is particularly large at D1 and remains visible through D30.

This suggests that reaching the core reflection experience is strongly associated with continued engagement.

However, this is an observational relationship and does not establish that activation itself causes higher retention.

---

## 4. The lower-friction onboarding variant was associated with stronger retention

The variant cohort had higher retention than the control cohort at every measured retention window.

| Cohort | D1 | D7 | D14 | D30 |
|---|---:|---:|---:|---:|
| Control | 8.84% | 8.50% | 5.91% | 3.19% |
| Variant | 13.44% | 11.24% | 7.89% | 4.82% |

The absolute retention difference was:

- D1: **+4.61 percentage points**
- D7: **+2.73 percentage points**
- D14: **+1.98 percentage points**
- D30: **+1.63 percentage points**

This is directionally consistent with the earlier onboarding and activation findings, where the variant also had higher onboarding completion and activation.

The results provide evidence that the lower-friction onboarding experience is associated with stronger downstream engagement in the synthetic dataset.

However, causal interpretation would require further experiment validation and statistical testing.

---

## 5. MBTI familiarity showed a smaller positive association with retention

Users who already knew their MBTI had slightly higher retention than users who did not know their MBTI.

| MBTI Familiarity | D1 | D7 | D14 | D30 |
|---|---:|---:|---:|---:|
| Do not know MBTI | 10.42% | 9.00% | 5.92% | 3.73% |
| Know MBTI | 12.05% | 10.98% | 8.16% | 4.35% |

The difference was relatively small compared with the much larger difference between activated and non-activated users.

This suggests that MBTI familiarity may be a useful segmentation variable, but the current data does not establish that MBTI familiarity itself is responsible for higher retention.

---

## 6. Platform does not appear to be a major retention driver

Retention was broadly similar across Android, iOS and Web.

The platform with the highest retention varied across the different retention windows.

No consistent platform-specific retention problem was identified.

The Web population was also substantially smaller than the Android and iOS populations, so differences observed for Web should be interpreted cautiously.

---

## 7. Users taking lower-friction onboarding paths showed higher observed retention

The `self_select` path had the highest observed retention across all measured windows.

| Onboarding Path | D1 | D7 | D14 | D30 |
|---|---:|---:|---:|---:|
| `mandatory_test` | 8.84% | 8.50% | 5.91% | 3.19% |
| `self_select` | 14.64% | 13.25% | 9.40% | 5.55% |
| `test_or_skip` | 12.53% | 9.69% | 6.74% | 4.26% |

Both variant paths had higher observed retention than the mandatory-test control path.

However, these paths should not be interpreted as three independent experimental groups.

Users may have selected different paths based on their own preferences or characteristics, creating potential self-selection bias.

Therefore, the strongest experiment comparison remains **control vs variant**, while onboarding-path results are treated as exploratory behavioral analysis.

---

## 8. The main product opportunity is improving activation before optimizing long-term retention

The combined onboarding, activation and retention analysis suggests that the largest immediate opportunity is to increase the number of users who reach the core reflection experience.

The current journey can be summarized as:

```text
3,000 signed-up users
        ↓
2,192 onboarding completers
        ↓
1,008 reach reflection
        ↓
1,007 activated
        ↓
334 D1 retained
        ↓
120 D30 retained
````
---

# Product Interpretation


The retention analysis suggests that the most important near-term product opportunity is improving the transition from onboarding completion into the core NiyyahLy reflection experience.

The data shows a consistent pattern across the funnel:

```text
Signup
  ↓
Onboarding
  ↓
Activation
  ↓
Retention
````

The lower-friction onboarding variant was associated with higher onboarding completion, higher activation and higher retention than the control cohort.

However, the largest observed funnel bottleneck occurs after onboarding completion and before users reach the core reflection experience.

Of the 2,192 users who completed onboarding, 1,008 reached the reflection experience. This represents approximately 45.99% conversion from onboarding completion to reaching the reflection experience.

At the same time, activated users showed substantially stronger subsequent retention than non-activated users:

* D1: 24.83% vs 4.21%
* D7: 21.25% vs 4.11%
* D14: 13.90% vs 3.36%
* D30: 8.34% vs 1.81%

This suggests that increasing the number of users who reach activation may be a higher-priority opportunity than optimizing later stages of the reflection journey at this stage.

---

## Recommended Product Priority

The first priority should be to investigate and reduce the drop-off between onboarding completion and the first meaningful reflection interaction.

Potential areas for investigation include:

* Whether users understand what to do after onboarding
* Whether the transition from onboarding to the reflection experience is clear
* Whether users encounter unnecessary friction before selecting their first mood or topic
* Whether the value of the reflection experience is communicated clearly
* Whether users have sufficient motivation or context to begin their first reflection

These areas should be investigated using additional behavioral analysis and, where possible, user research.

---

## Personalization as the Next Product Hypothesis

The current analysis also provides a basis for a future product hypothesis around personalization.

NiyyahLy's intended reflection experience can combine information such as:

* Personality profile
* Current mood
* Reflection topic
* User preferences

to generate a more personalized reflection prompt.

A future hypothesis could therefore be:

> Users who receive personality- and mood-informed reflection prompts may find the experience more relevant and engaging, leading to higher reflection engagement and subsequent retention.

This hypothesis has not been proven by the current V1 analysis.

The current data only shows that users who reach activation have substantially higher subsequent retention.

A future experiment would be required to determine whether personalization itself improves engagement and retention.

---

## Recommended Next Experiment

A future personalization experiment should ideally compare users who reach the reflection experience under two controlled conditions:

### Control

Users receive a standard reflection prompt.

### Personalization Variant

Users receive a prompt personalized using available personality and mood information.

The experiment should keep the rest of the reflection experience as consistent as possible so that the primary difference is the level of personalization.

Potential metrics include:

### Primary metrics

* D7 retention
* Journal save rate

### Secondary metrics

* Reflection completion rate
* Prompt favorite rate
* Prompt regeneration rate
* Reflection journey duration
* D14 retention
* D30 retention

If the product team wants to measure whether users actually feel more understood or that the prompts are more relevant, a qualitative or survey-based metric should also be introduced rather than attempting to infer those feelings solely from behavioral events.

---

## Decision Framework

The current V1 results support the following product sequence:

```text
1. Improve onboarding-to-reflection transition
                ↓
2. Increase activation
                ↓
3. Measure whether increased activation
   produces stronger retention
                ↓
4. Optimize the reflection experience
                ↓
5. Test personality + mood personalization
                ↓
6. Measure engagement and retention impact
```

This approach prioritizes the largest observed funnel opportunity before introducing a more advanced personalization hypothesis.

---

## Causal Interpretation

The control-versus-variant results are directionally consistent across onboarding completion, activation and retention.

However, the current analysis should not be presented as definitive causal evidence.

The synthetic dataset is intended to demonstrate product analytics methodology.

A real product experiment would require:

* Valid random assignment
* Experiment exposure validation
* Sample-size planning
* Statistical significance testing
* Confidence intervals
* Monitoring for experiment imbalance
* Consideration of experiment duration and seasonality
* Evaluation of potential novelty or selection effects

The onboarding-path analysis requires additional caution because users may select different paths within the variant experience.

---

## Final Product Interpretation

The central finding from the V1 analysis is not simply that retention is low.

The more actionable finding is that **activation is strongly associated with subsequent retention, while a substantial proportion of users who complete onboarding do not reach the core reflection experience.**

Therefore, the immediate product opportunity is to improve activation.

Once more users consistently reach the core reflection experience, NiyyahLy can then test whether deeper personalization — particularly combining personality and current mood with reflection topics — can increase engagement and long-term retention.

This creates a progression from:

```text
Reduce onboarding friction
        ↓
Increase activation
        ↓
Deliver core product value
        ↓
Improve engagement
        ↓
Test personalization
        ↓
Improve retention
```



# Limitations

## Synthetic Data

All data in this analysis is synthetic.

The results should therefore be treated as a product analytics case study rather than evidence about real NiyyahLy users.

---

## Retention Definition

Retention is based on `journal_saved`.

This measures return to a meaningful reflection action rather than simply opening the application.

Therefore, the metric represents **behavioral engagement with the core reflection experience**, not general application usage.

---

## Calendar-Day Retention

D1, D7, D14 and D30 are based on calendar-day differences between signup and journal activity.

They should not be interpreted as exact 24-hour, 168-hour or other rolling time windows.

---

## Causal Interpretation

Differences between control and variant retention should not automatically be interpreted as causal effects.

Additional statistical testing and experiment validation would be required before making a causal product decision.

---

## Activation and Retention Relationship

The strong difference in retention between activated and non-activated users represents an association.

It does not establish that activation itself causes higher retention.

Other user characteristics or behavioral differences may contribute to the observed relationship.

````

