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
