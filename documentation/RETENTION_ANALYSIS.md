# NiyyahLy Retention Analysis

## Product Question

Do users return to NiyyahLy after their initial product experience?

---

## Background

The activation analysis examined whether users reached NiyyahLy's core reflection experience.

The next product question is whether users continue to engage with the product after signup.

Retention is therefore analyzed using later `journal_saved` activity.

---

## Retention Definition

A user is considered retained when they save a journal on a specified calendar day after signup.

The retention windows analyzed are:

- D1
- D7
- D14
- D30

The retained activity event is:

`journal_saved`

This event was selected because saving a journal represents meaningful interaction with NiyyahLy's core reflection experience.

---

## Analytical Grain

The `mart_retention` table has a one-row-per-user grain.

Each user has retention flags for:

- `retained_d1`
- `retained_d7`
- `retained_d14`
- `retained_d30`

A value of `1` means the user had a `journal_saved` event on that calendar day after signup.

---

# Overall Retention

## Definition

Retention rate is calculated as:

```text
Retained Users on Day N / Total Users
````

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

Further cohort and activation analysis is required to understand whether the onboarding experience or reaching activation is associated with stronger long-term retention.

---

## Result

| Cohort | Users | D1 Retention | D7 Retention | D14 Retention | D30 Retention |
|---|---:|---:|---:|---:|---:|
| Control | 1,505 | 8.84% | 8.50% | 5.91% | 3.19% |
| Variant | 1,495 | 13.44% | 11.24% | 7.89% | 4.82% |

The variant cohort had higher retention than the control cohort across every measured retention window.

Absolute differences were:

- D1: **+4.61 percentage points**
- D7: **+2.73 percentage points**
- D14: **+1.98 percentage points**
- D30: **+1.63 percentage points**

The largest absolute difference occurred at D1, where retention was 13.44% for the variant compared with 8.84% for the control.

The retention advantage remained visible through D30, although the difference became smaller over time.

These results show an association between the lower-friction onboarding experience and stronger subsequent retention in the synthetic dataset. They should not yet be interpreted as proof of a causal effect.

---

## Result

| User Group | Users | D1 Retention | D7 Retention | D14 Retention | D30 Retention |
|---|---:|---:|---:|---:|---:|
| Activated | 1,007 | 24.83% | 21.25% | 13.90% | 8.34% |
| Not activated | 1,993 | 4.21% | 4.11% | 3.36% | 1.81% |

Users who reached activation had substantially higher retention than users who did not activate across every measured retention window.

For example:

- D1 retention was **24.83%** among activated users compared with **4.21%** among non-activated users.
- D7 retention was **21.25%** compared with **4.11%**.
- D14 retention was **13.90%** compared with **3.36%**.
- D30 retention was **8.34%** compared with **1.81%**.

This represents a strong association between reaching the core NiyyahLy reflection experience and subsequent engagement.

However, this analysis does not establish that activation causes retention. Users who activate may differ from non-activated users in other ways that influence their likelihood of returning.

---

# Retention by MBTI Familiarity

**To be calculated from BigQuery.**

---

# Retention by Platform

**To be calculated from BigQuery.**

---

# Retention by Onboarding Path

**To be calculated from BigQuery.**

---

# Initial Observations

**To be completed after the retention analysis.**

---

# Product Interpretation

**To be completed after the retention analysis.**

---

# Limitations

All data in this analysis is synthetic.

Retention represents `journal_saved` activity and therefore measures return to a meaningful reflection action rather than simply opening the application.

The results should be interpreted as a product analytics case study rather than evidence about real NiyyahLy users.

````

