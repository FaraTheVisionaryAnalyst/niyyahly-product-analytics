# NiyyahLy Data Quality Checks

## Purpose

Before performing Product Analytics analysis, I validated the
synthetic NiyyahLy raw data in BigQuery.

The purpose of these checks was to confirm that the data was
structurally consistent and suitable for downstream analysis.

## Checks performed

| Check | Purpose | Result |
|---|---|---|
| User row count | Confirm expected dataset size | Passed |
| Event row count | Confirm event data loaded | Passed |
| Duplicate event IDs | Check event uniqueness | Passed |
| Orphan events | Check referential integrity | Passed |
| Event date range | Validate temporal coverage | Passed |
| Event distribution | Check event tracking coverage | Passed |
| JSON property extraction | Validate event properties | Passed |
| Onboarding event coverage | Confirm onboarding events exist | Passed |

## Key result

The synthetic dataset passed the initial data-quality checks and
was considered suitable for downstream Product Analytics analysis.

## Important limitation

This dataset is synthetic and was created specifically for this
portfolio project. The quality checks therefore validate the
technical consistency of the generated dataset rather than the
accuracy of real-world customer behavior.

# Results

### Users

Total users: 3,000

### Onboarding

Overall onboarding completion rate: 73.07%

### Event integrity

Duplicate event IDs: 0

Orphan events: 0

valid event timestamps
valid event properties
