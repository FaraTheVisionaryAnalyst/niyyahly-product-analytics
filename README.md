# NiyyahLy Product Analytics

## Product Analytics Case Study

NiyyahLy is a synthetic digital reflection product designed to help users engage in guided journaling and personal reflection.

This project demonstrates an end-to-end Product Analytics workflow using synthetic product event data.

The analysis focuses on the relationship between:

```text
Onboarding
    ↓
Activation
    ↓
Retention
````

The project also explores how onboarding design, user characteristics and product behavior relate to downstream engagement.

---

# Business Problem

The NiyyahLy onboarding experience includes a personality-related step.

The original onboarding experience requires users to complete a personality test, while a proposed lower-friction experience gives users additional flexibility.

The initial product hypothesis was:

> Reducing onboarding friction may help more users complete onboarding and reach the core reflection experience.

The analysis therefore investigates:

1. Does the lower-friction onboarding experience improve onboarding completion?
2. Does it increase activation?
3. Do activated users show stronger retention?
4. Does the onboarding experience relate to longer-term retention?
5. Are there meaningful differences across user segments?

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

The project follows a structured analytical workflow:

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
Product Interpretation
```

---

# Tools

* **BigQuery** — SQL analysis and analytical data modeling
* **SQL** — Data quality checks, transformations and product analysis
* **Python** — Supporting analytical workflow
* **Tableau** — Product analytics visualization
* **GitHub** — Documentation, SQL version control and portfolio presentation

---

# Key Metrics

## Onboarding

Onboarding completion is defined as:

```text
Users completing onboarding
/
Users starting onboarding
```

Overall onboarding completion:

**73.1%**

| Cohort  | Completion |
| ------- | ---------: |
| Control |      69.0% |
| Variant |      77.1% |

The variant showed an approximately **8.1 percentage-point improvement** in onboarding completion.

---

# Activation

Activation represents reaching the core NiyyahLy reflection experience.

A user is classified as activated when the required reflection journey is completed within 24 hours of signup:

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

Overall activation among onboarding completers:

**46.0%**

| Cohort  | Activation Rate |
| ------- | --------------: |
| Control |           30.3% |
| Variant |           36.9% |

The variant showed a higher activation rate than the control.

---

# Retention

Retention is measured using `journal_saved` as the meaningful core-product activity.

Retention is calculated using calendar days after signup:

* D1
* D7
* D14
* D30

Overall retention:

| Retention Window | Retention |
| ---------------- | --------: |
| D1               |    11.13% |
| D7               |     9.87% |
| D14              |     6.90% |
| D30              |     4.00% |

---

# Key Finding: Activation and Retention

One of the strongest patterns in the analysis is the difference in retention between activated and non-activated users.

| User Group    |     D1 |     D7 |    D14 |   D30 |
| ------------- | -----: | -----: | -----: | ----: |
| Activated     | 24.83% | 21.25% | 13.90% | 8.34% |
| Not activated |  4.21% |  4.11% |  3.36% | 1.81% |

Activated users showed substantially higher retention across every measured retention window.

This suggests that reaching the core reflection experience is strongly associated with continued engagement.

This is an observational relationship and should not be interpreted as proof that activation itself causes retention.

---

# Retention by Experiment Cohort

| Cohort  |     D1 |     D7 |   D14 |   D30 |
| ------- | -----: | -----: | ----: | ----: |
| Control |  8.84% |  8.50% | 5.91% | 3.19% |
| Variant | 13.44% | 11.24% | 7.89% | 4.82% |

The variant had higher retention across all measured windows.

The results are directionally consistent with the earlier onboarding and activation findings.

However, causal interpretation would require further statistical and experimental validation.

---

# Main Product Opportunity

The analysis suggests that the largest immediate opportunity is not simply improving long-term retention.

The larger funnel issue occurs between onboarding completion and reaching the core reflection experience.

The current funnel is approximately:

```text
3,000 signed up
      ↓
2,192 onboarding completers
      ↓
1,008 reached reflection
      ↓
1,007 activated
      ↓
334 D1 retained
      ↓
120 D30 retained
```

The most significant activation bottleneck occurs before users reach the first reflection experience.

At the same time, users who reach activation show substantially stronger subsequent retention.

Therefore, the immediate product priority is:

> **Improve the transition from onboarding completion into the first meaningful reflection experience.**

---

# Product Recommendation

The next product iteration should investigate why some onboarding completers do not proceed into the reflection experience.

Potential areas include:

* Clarity of the transition from onboarding to reflection
* Whether the next action is obvious
* Unnecessary friction before the first reflection
* Communication of the value of the reflection experience
* User motivation and context at the transition point

The objective is to increase activation before attempting to optimize later-stage retention.

---

# Future Product Hypothesis: Personalization

The current analysis also provides a basis for a future product hypothesis.

NiyyahLy can potentially combine:

```text
Personality profile
        +
Current mood
        +
Reflection topic
        ↓
Personalized reflection prompt
```

The future hypothesis is:

> Users who receive personality- and mood-informed reflection prompts may find the experience more relevant and engaging, leading to higher reflection engagement and subsequent retention.

This hypothesis is **not proven by the current V1 analysis**.

The current data only establishes a strong association between reaching activation and subsequent retention.

A future controlled experiment would be required to determine whether personalization itself improves engagement and retention.

---

# Recommended Product Roadmap

```text
V1
Diagnose the product funnel
        ↓
Identify activation bottleneck
        ↓
V2
Improve onboarding → reflection transition
        ↓
Increase activation
        ↓
Measure downstream retention
        ↓
Future Experiment
Test personality + mood personalization
        ↓
Measure engagement
        ↓
Measure retention
```

---

# Repository Structure

```text
├── data/
│   └── synthetic/
│
├── documentation/
│   ├── ACTIVATION_ANALYSIS.md
│   ├── DATA_DICTIONARY.md
│   ├── DATA_MODEL.md
│   ├── DATA_QUALITY_CHECKS.md
│   ├── METRIC_DEFINITIONS.md
│   ├── ONBOARDING_ANALYSIS.md
│   └── RETENTION_ANALYSIS.md
│
├── sql/
│   ├── 01_data_quality/
│   │   ├── 01_users_quality_check.sql
│   │   └── 02_events_quality_check.sql
│   │
│   ├── 02_analytical_model/
│   │   ├── 01_create_dim_users.sql
│   │   ├── 02_create_fact_events.sql
│   │   └── 03_validate_analytical_tables.sql
│   │
│   ├── 03_onboarding/
│   │   ├── 01_create_mart_onboarding.sql
│   │   └── 02_onboarding_analysis.sql
│   │
│   ├── 04_activation/
│   │   ├── 01_create_mart_activation.sql
│   │   └── 02_activation_analysis.sql
│   │
│   └── 05_retention/
│       ├── 01_create_mart_retention.sql
│       └── 02_retention_analysis.sql
│
└── README.md
```

---

# Documentation

Detailed methodology and results are available in:

* `documentation/DATA_DICTIONARY.md`
* `documentation/DATA_MODEL.md`
* `documentation/DATA_QUALITY_CHECKS.md`
* `documentation/METRIC_DEFINITIONS.md`
* `documentation/ONBOARDING_ANALYSIS.md`
* `documentation/ACTIVATION_ANALYSIS.md`
* `documentation/RETENTION_ANALYSIS.md`

The SQL used to reproduce the analysis is organized by analytical stage under `sql/`.

---

# Limitations

This project uses synthetic data and is intended as a Product Analytics portfolio case study.

The observed differences between cohorts should not be treated as definitive causal evidence.

A real-world experiment would require appropriate random assignment, experiment exposure validation, sample-size planning, statistical significance testing, confidence intervals, experiment monitoring and consideration of potential confounding factors.

The onboarding-path analysis also requires caution because users may select different paths within the variant experience.

Retention is measured using `journal_saved`, which represents meaningful reflection activity but does not capture every possible form of product engagement.

---

# Conclusion

The V1 analysis indicates that reducing onboarding friction is associated with higher onboarding completion, activation and retention.

The strongest actionable finding is that activated users are substantially more likely to return than users who do not activate.

This suggests that improving the onboarding-to-reflection transition should be the immediate product priority.

Once activation is improved, a future experiment can investigate whether deeper personalization using personality and mood information increases engagement and long-term retention.

````
