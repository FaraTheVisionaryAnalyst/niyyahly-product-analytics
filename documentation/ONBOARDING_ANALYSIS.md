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

## Onboarding Definition

Onboarding completion rate is defined as:

Completed onboarding / Users who started onboarding.

## Analysis Dimensions

The onboarding journey was analyzed by:

- Experiment cohort
- Onboarding path
- MBTI familiarity
- Platform
- Onboarding duration

## Key Metrics

### Overall onboarding completion



### Control vs Variant

cohort	users	started	completed	onboarding_completion_rate
control	1505	1505	1039	0.69036544850498338
variant	1495	1495	1153	0.77123745819397993

### By onboarding path

onboarding_path	users	started	completed	completion_rate
self_select	649	649	521	0.802773497688752
test_or_skip	846	846	632	0.74704491725768318
mandatory_test	1505	1505	1039	0.69036544850498338


### By MBTI familiarity

knows_mbti	users	completed	completion_rate
false	1689	1179	0.69804618117229134
true	1311	1013	0.77269260106788706

### Median onboarding duration

cohort	completed_users	average_duration_seconds	median_duration_seconds
control	1039	451.35707410972122	420
variant	1153	270.65047701647893	300

## Initial Observations

[WRITE 2–3 OBSERVATIONS AFTER ANALYZING THE RESULTS]

## Important Interpretation Note

These results are generated from synthetic data.

Differences between cohorts should not be interpreted as evidence
of causal product impact until the experiment design and statistical
analysis have been evaluated.

## Next Question

Does improved onboarding translate into activation?

This will be investigated in the next stage.
