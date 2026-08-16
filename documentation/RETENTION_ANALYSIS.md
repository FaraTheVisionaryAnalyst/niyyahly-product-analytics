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

**To be calculated from BigQuery.**

---

# Retention by Platform

## Product Question

Does retention differ across Web, Android and iOS?

**To be calculated from BigQuery.**

---

# Retention by Onboarding Path

## Product Question

Does retention differ across the different onboarding paths?

The onboarding paths include:

* `mandatory_test`
* `test_or_skip`
* `self_select`

Important interpretation note:

`onboarding_path` is not an independent randomized experiment dimension.

As identified during the onboarding analysis, the paths are connected to the control and variant onboarding experiences.

Therefore, differences in retention between onboarding paths should be interpreted as behavioral associations rather than causal effects.

**To be calculated from BigQuery.**

---

# Initial Observations

**To be completed after the remaining retention segmentation analyses.**

The final observations will focus on:

1. Overall retention trajectory
2. Control vs. variant retention
3. Activation and subsequent retention
4. MBTI familiarity
5. Platform
6. Onboarding path
7. The relationship between activation and long-term engagement

---

# Product Interpretation

**To be completed after the remaining retention segmentation analyses.**

The final product interpretation will answer:

> Does improving onboarding and increasing activation appear to be associated with stronger long-term engagement?

The analysis will distinguish between:

### Onboarding

Whether users complete the onboarding journey.

### Activation

Whether users reach the core reflection experience.

### Retention

Whether users return and perform a meaningful reflection action later.

The final recommendation will be based on the combined evidence from these three stages.

---

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

