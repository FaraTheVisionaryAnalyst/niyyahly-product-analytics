# NiyyahLy Product Analytics

## Product Analytics Case Study

NiyyahLy is a synthetic digital reflection product designed to help users engage with guided journaling and personal reflection.

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
3. Are activated users more likely to return?
4. Does the onboarding experience relate to downstream retention?
5. Are there meaningful differences across user segments?
6. What product opportunity should be prioritized next?

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
Product Interpretation
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

Do users return to NiyyahLy after their initial product experience?

Retention is measured using `journal_saved` as the meaningful core-product activity.

The retention windows analyzed are:

* D1
* D7
* D14
* D30

### Important Retention Definition

Retention is calculated using **calendar days after signup**, not a rolling 24-hour window.

For example:

```text
Signup: January 1
D1:     January 2
D7:     January 8
D14:    January 15
D30:    January 31
```

A user is considered retained for a particular window when they have a `journal_saved` event on that specified calendar day.

D1, D7, D14 and D30 are therefore separate retention measurements rather than sequential stages of a funnel.

---

# Overall Retention Results

| Retention Window | Retained Users | Retention Rate |
| ---------------- | -------------: | -------------: |
| D1               |            334 |         11.13% |
| D7               |            296 |          9.87% |
| D14              |            207 |          6.90% |
| D30              |            120 |          4.00% |

The measured retention rates are lower at later checkpoints in the synthetic dataset.

However, these measurements should be treated primarily as **descriptive baseline metrics**.

The data does not by itself establish why retention differs between checkpoints or whether the observed decline represents a specific churn mechanism.

---

# Activation and Retention Relationship

One of the strongest patterns in the analysis is the difference in retention between activated and non-activated users.

| User Group    |     D1 |     D7 |    D14 |   D30 |
| ------------- | -----: | -----: | -----: | ----: |
| Activated     | 24.83% | 21.25% | 13.90% | 8.34% |
| Not activated |  4.21% |  4.11% |  3.36% | 1.81% |

Activated users had substantially higher observed retention at every measured checkpoint.

For example, D1 retention among activated users was **24.83%**, compared with **4.21%** among users who did not activate.

At D30, the corresponding rates were **8.34%** and **1.81%**.

This suggests a strong association between reaching the core reflection experience and subsequent engagement.

However, this is an observational relationship and should not be interpreted as proof that activation itself causes higher retention.

---

# Retention by Experiment Cohort

| Cohort  |     D1 |     D7 |   D14 |   D30 |
| ------- | -----: | -----: | ----: | ----: |
| Control |  8.84% |  8.50% | 5.91% | 3.19% |
| Variant | 13.44% | 11.24% | 7.89% | 4.82% |

The variant had higher observed retention across every measured window.

This is directionally consistent with the earlier onboarding and activation findings.

The absolute retention differences were:

* D1: **+4.61 percentage points**
* D7: **+2.73 percentage points**
* D14: **+1.98 percentage points**
* D30: **+1.63 percentage points**

The cohort comparison should be interpreted as evidence of an observed association within the synthetic experiment dataset rather than definitive causal evidence.

A real experiment would require appropriate statistical testing and experiment validation.

---

# Retention by MBTI Familiarity

| MBTI Familiarity | Users |     D1 |     D7 |   D14 |   D30 |
| ---------------- | ----: | -----: | -----: | ----: | ----: |
| Do not know MBTI | 1,689 | 10.42% |  9.00% | 5.92% | 3.73% |
| Know MBTI        | 1,311 | 12.05% | 10.98% | 8.16% | 4.35% |

Users who already knew their MBTI had higher observed retention across all measured windows.

The differences were relatively small compared with the much larger difference observed between activated and non-activated users.

Therefore, MBTI familiarity is treated as a useful segmentation variable rather than evidence that MBTI familiarity itself causes higher retention.

---

# Retention by Platform

| Platform | Users |     D1 |     D7 |   D14 |   D30 |
| -------- | ----: | -----: | -----: | ----: | ----: |
| Android  | 1,253 | 11.41% |  9.58% | 7.50% | 3.67% |
| iOS      | 1,463 | 11.21% |  9.84% | 6.63% | 4.17% |
| Web      |   284 |  9.51% | 11.27% | 5.63% | 4.58% |

Retention was broadly similar across platforms.

The platform with the highest observed retention varied across the different retention windows.

No consistent platform-specific retention problem was identified.

The Web population is substantially smaller than the Android and iOS populations, so differences involving Web should be interpreted cautiously.

---

# Retention by Onboarding Path

| Onboarding Path  | Users |     D1 |     D7 |   D14 |   D30 |
| ---------------- | ----: | -----: | -----: | ----: | ----: |
| `mandatory_test` | 1,505 |  8.84% |  8.50% | 5.91% | 3.19% |
| `self_select`    |   649 | 14.64% | 13.25% | 9.40% | 5.55% |
| `test_or_skip`   |   846 | 12.53% |  9.69% | 6.74% | 4.26% |

Users in the `self_select` path had the highest observed retention across all measured windows.

Both variant paths had higher observed retention than the `mandatory_test` control path.

However, these paths are not three independent randomized experiment groups.

The `mandatory_test` path corresponds to the control experience, while `self_select` and `test_or_skip` occur within the variant experience.

Users may also select different paths based on their own characteristics or preferences.

Therefore, onboarding-path results are treated as descriptive behavioral analysis rather than evidence that a particular path causes higher retention.

---

# Main Product Opportunity

The clearest immediate product opportunity identified in the V1 analysis is **improving activation**.

Of the 2,192 users who completed onboarding, 1,007 were classified as activated.

This represents approximately **45.9% activation among onboarding completers**.

The analysis therefore identifies a substantial transition gap between completing onboarding and reaching the core reflection experience.

Potential areas for investigation include:

* Clarity of the transition from onboarding to reflection
* Whether the next action is obvious
* Unnecessary friction before the first reflection
* Communication of the value of the reflection experience
* User motivation at the transition point

The next product iteration should investigate this transition and determine whether improving it increases activation.

---

# Activation and Retention as Separate Product Questions

The analysis suggests that activation and retention should not be treated as one continuous funnel.

The activation journey is a sequential product journey:

```text
Signup
  ↓
Onboarding
  ↓
Reflection experience
  ↓
Activation
```

Retention is measured separately at specific calendar-day checkpoints:

```text
Signup
  │
  ├── D1 journal activity?
  │
  ├── D7 journal activity?
  │
  ├── D14 journal activity?
  │
  └── D30 journal activity?
```

Therefore, a user who does not save a journal on D7 is not necessarily a permanently lost user.

The current dataset provides useful baseline retention measurements, but it does not provide enough evidence by itself to explain the causes of later-stage retention differences.

The strongest current retention finding is the large difference between activated and non-activated users.

---

# Product Interpretation

The V1 analysis identifies two related but distinct product questions.

## Question 1: How do we get more users to experience the core product value?

The activation analysis shows a substantial gap between onboarding completion and activation.

Improving the onboarding-to-reflection transition should therefore be the immediate product priority.

The objective is to increase the proportion of users who reach and experience the core NiyyahLy reflection journey.

## Question 2: What makes users continue engaging after experiencing the core product?

Activated users show substantially higher observed retention at D1, D7, D14 and D30.

This indicates that reaching the core product experience is strongly associated with subsequent engagement.

However, the current V1 data does not explain why some activated users return while others do not.

Further behavioral analysis or experimentation would be required to understand the mechanisms behind continued engagement.

---

# Future Product Hypothesis: Personalization

The next product hypothesis can build on the core NiyyahLy value proposition.

The product can potentially combine:

```text
Personality profile
        +
Current mood
        +
Reflection topic
        ↓
Personalized reflection prompt
```

The hypothesis is:

> Users who receive personality- and mood-informed reflection prompts may find the experience more relevant and engaging, leading to higher reflection engagement and subsequent retention.

This hypothesis is **not proven by the current V1 analysis**.

The current analysis only establishes that users who reach activation have substantially higher observed retention.

A future controlled experiment would be required to determine whether personalization itself improves engagement and retention.

---

# Recommended Product Roadmap

```text
V1
Understand the product funnel
        ↓
Identify activation opportunity
        ↓
Improve onboarding → reflection transition
        ↓
Measure activation improvement
        ↓
────────────────────────────────
Use retention as a downstream outcome
        ↓
Understand continued engagement
        ↓
Identify behavioral drivers of return
        ↓
────────────────────────────────
Future Experiment
Test personality + mood personalization
        ↓
Measure reflection engagement
        ↓
Measure D7 / D14 / D30 retention
```

The sequence intentionally prioritizes activation before introducing the deeper personalization hypothesis.

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
        └── mart_retention
```

The analytical marts provide reusable tables for product analysis rather than repeatedly querying the raw event data.

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
└── 05_retention/
    ├── 01_create_mart_retention.sql
    └── 02_retention_analysis.sql
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

---

# Tableau

The validated BigQuery outputs will be used to build a Tableau product analytics dashboard.

The dashboard will focus on the product journey:

```text
Onboarding
    ↓
Activation
    ↓
Retention
```

The visualization will emphasize:

* Funnel progression
* Control vs variant comparison
* Activation performance
* Retention checkpoints
* Key user segments
* Product opportunities

The Tableau dashboard will be based on the validated analytical tables and documented metrics rather than directly connecting to raw event data.

---

# Limitations

This project uses synthetic data and is intended as a Product Analytics portfolio case study.

The observed differences between cohorts should not be treated as definitive causal evidence.

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

Retention is measured using `journal_saved`, which represents meaningful reflection activity but does not capture every possible form of product engagement.

D1, D7, D14 and D30 are separate calendar-day retention measurements rather than sequential churn stages.

The relatively small number of retained users at later checkpoints also limits the strength of conclusions that can be drawn about long-term retention behavior.

---

# Conclusion

The V1 analysis suggests that the lower-friction onboarding experience is associated with higher onboarding completion, activation and observed retention.

The clearest immediate product opportunity is improving the transition from onboarding completion into the core reflection experience.

Activation is also strongly associated with subsequent retention, making it an important product milestone.

At the same time, the retention analysis should be treated as a baseline descriptive view rather than sufficient evidence to explain the causes of later-stage engagement or churn.

The next product iteration should therefore focus first on improving activation while using retention as a downstream outcome.

Once the activation experience is improved, a future controlled experiment can investigate whether deeper personalization — particularly combining personality and current mood with reflection topics — increases reflection engagement and long-term retention.

````
