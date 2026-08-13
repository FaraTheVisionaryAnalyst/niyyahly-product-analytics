# NiyyahLy Onboarding Analysis

## Product Question

Does reducing onboarding friction help more users reach the
NiyyahLy reflection experience?

## Hypothesis

A lower-friction onboarding approach may increase onboarding
completion and reduce the time required to complete onboarding.

## Dataset

Synthetic NiyyahLy Product Analytics V1.

The dataset contains 3,000 synthetic users and event-level
product behavior.

All data is synthetic and is used for portfolio and educational
purposes only.

## Onboarding Definition

Onboarding completion rate is defined as:

> Completed onboarding / Users who started onboarding

## Analysis Dimensions

The onboarding journey was analyzed by:

- Experiment cohort
- Onboarding path
- MBTI familiarity
- Platform
- Onboarding duration

---

## Key Metrics

### Overall onboarding completion

| Metric | Users |
|---|---:|
| Users who started onboarding | 3,000 |
| Users who completed onboarding | 2,192 |
| Completion rate | **73.1%** |

### Control vs. Variant

| Cohort | Users | Started | Completed | Completion Rate |
|---|---:|---:|---:|---:|
| Control | 1,505 | 1,505 | 1,039 | 69.0% |
| Variant | 1,495 | 1,495 | 1,153 | 77.1% |

The variant was **8.1 percentage points higher** than control.

### By Onboarding Path

| Onboarding Path | Users | Started | Completed | Completion Rate |
|---|---:|---:|---:|---:|
| Self-select | 649 | 649 | 521 | 80.3% |
| Test-or-skip | 846 | 846 | 632 | 74.7% |
| Mandatory test | 1,505 | 1,505 | 1,039 | 69.0% |

### By MBTI Familiarity

| Knows MBTI | Users | Completed | Completion Rate |
|---|---:|---:|---:|
| No | 1,689 | 1,179 | 69.8% |
| Yes | 1,311 | 1,013 | 77.3% |

### Onboarding Duration

Completed users only.

| Cohort | Completed Users | Average Duration (sec) | Median Duration (sec) |
|---|---:|---:|---:|
| Control | 1,039 | 451.4 | 420 |
| Variant | 1,153 | 270.7 | 300 |

---

## Initial Observations

### 1. The variant is directionally consistent with the hypothesis

The variant cohort completed onboarding at a higher rate than
control (77.1% vs. 69.0%), representing an **8.1 percentage-point
difference**.

The variant also had a lower median onboarding duration:

- Control: 420 seconds
- Variant: 300 seconds
- Reduction: approximately **29%**

Both completion and completion speed moved in the direction
expected from a lower-friction onboarding design.

### 2. Onboarding path is nested within the experiment cohort

The onboarding path is not an independent experimental dimension.

The data shows:

- `mandatory_test` = entire control cohort
- `self_select` + `test_or_skip` = entire variant cohort

Therefore, the three onboarding paths should **not** be interpreted
as three independently randomized groups.

The higher completion rate for `self_select` (80.3%) may partly reflect
self-selection: users who already know their MBTI or are comfortable
continuing may be more likely to choose this path.

Therefore, the path-level results are descriptive rather than
causal.

### 3. MBTI familiarity is associated with completion

Users who reported already knowing their MBTI had a higher completion
rate than users who did not:

- Knows MBTI: 77.3%
- Does not know MBTI: 69.8%

However, this does not establish that MBTI familiarity causes higher
completion.

The next analysis should examine whether MBTI familiarity is balanced
across the control and variant cohorts.

### 4. Platform should be checked as a potential segmentation factor

Platform-level results should be reviewed to determine whether the
observed onboarding differences are consistent across devices.

---

## Important Interpretation Note

These results are generated from synthetic data.

The observed difference between control and variant should not yet be
interpreted as causal evidence that the lower-friction onboarding
design caused higher completion.

Further analysis should evaluate:

1. Cohort balance
2. MBTI familiarity balance
3. Platform distribution
4. Statistical uncertainty around the completion-rate difference
5. Downstream activation and retention

---

## Product Implication

The synthetic results provide an initial signal that reducing
onboarding friction may help users reach the core NiyyahLy experience
more efficiently.

However, onboarding completion alone is not sufficient to determine
whether the change created additional product value.

The next question is therefore:

> **Does improved onboarding translate into activation?**

This will be investigated in the next stage.
