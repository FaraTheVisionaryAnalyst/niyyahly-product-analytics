# NiyyahLy Product Analytics Data Model

## Purpose

The analytical layer separates source/raw data from tables designed
for Product Analytics analysis.

The raw dataset is stored in `niyyahly_raw`.

The analytical tables are stored in `niyyahly_analytics`.

---

## Architecture

Raw CSV data
↓
BigQuery `niyyahly_raw`
↓
Transformation
↓
BigQuery `niyyahly_analytics`
↓
Product Analytics marts
↓
Tableau

---

## Analytical Tables

### dim_users

**Grain:** One row per user.

Purpose:

- User-level product attributes
- Signup information
- Experiment cohort
- Onboarding configuration
- MBTI availability
- Personalization attributes
- Activation status

Source:

`niyyahly_raw.users`

---

### fact_events

**Grain:** One row per product event.

Purpose:

- Product behavioral events
- User journey analysis
- Session analysis
- Funnel analysis
- Activation analysis
- Retention analysis

Source:

`niyyahly_raw.events`

---

## Data Modeling Principles

The analytical layer is separated from the raw layer so that
transformations can be documented and reproduced without changing
the original source data.

Each analytical table has a defined grain.

`dim_users`
→ one row per user

`fact_events`
→ one row per event

---

## Validation

The following checks were performed:

- User count matches the raw users table.
- `user_id` is unique in `dim_users`.
- Event count matches the raw events table.
- `event_id` is unique in `fact_events`.
- No orphan events were found when joining events to users.

All checks passed for the synthetic dataset.

## Synthetic Data Disclosure

This project uses synthetic data created for portfolio and
educational purposes. The analytical model does not represent
NiyyahLy's production database architecture.
