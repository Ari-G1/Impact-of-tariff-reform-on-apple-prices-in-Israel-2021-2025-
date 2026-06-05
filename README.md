# Impact of Tariff Reform on Apple Prices and Import Structure in Israel (2021–2025)

A short report analysing the effects of reducing tariffs on apple imports on consumer prices in Israel (2021–2025).

## Overview

In 2022–2023, Israel's Ministry of Agriculture reduced customs tariffs on apple imports as part of the "Agriculture Reform". This project analyses the impact of these reductions on import volumes, consumer prices, and import structure using monthly data from 2021–2025.

**Tariff history:**
| Period | Tariff (₪/kg) |
|---|---|
| Until Feb-2022 | 1.81 |
| Mar-2022 – Dec-2022 | 1.53 |
| From Jan-2023 | 1.34 |

## Key Findings

- Consumer prices rose ~12% over the period — below Israel's general inflation rate (~17.6%)
- Import volumes grew ~60% and import value ~67% between 2021 and 2025
- Italy accounted for ~59% of all imports throughout the period, creating supply concentration risk
- Import volumes increased following each tariff reduction, with a sharp jump post Jan-2023

## Repository Structure

```
├── data/
│   ├── Retail.csv          # Monthly average consumer price (₪/kg), 2021–2025
│   └── IMPORT.csv          # Monthly import volume (tons) and value (NIS) by country
├── queries/
│   ├── q1.sql              # Monthly aggregation of import and retail price data
│   └── q2.sql              # Extends q1 with tariff-adjusted import price
├── analysis/
│   └── Apple_Import_Analysis.pdf
└── notebooks/
    └── analysis.ipynb
```

## Requirements

```
pandas
matplotlib
numpy
```

SQLite is part of Python's standard library — no additional installation needed.

## Usage

1. Clone the repo
2. Open `notebooks/analysis.ipynb` in Google Colab or JupyterLab
3. Upload `Retail.csv` and `IMPORT.csv` when prompted
4. Run all cells
