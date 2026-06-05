Query 1: Monthly Apple Import & Retail Price Aggregation
         Israel, 2021-2025

PURPOSE:
  Produce a monthly row-level table combining import data
  and retail prices for apples in Israel, aggregated across
  all countries of origin.

OUTPUT FIELDS:
  Year            - Calendar year
  Month           - Calendar month (1-12)
  TON_Total       - Total import volume in metric tons
  NIS_Total       - Total import value in NIS (CIF basis)
  Price_Retail    - Average consumer retail price (NIS/kg)
  Import_Price    - Average CIF import price (NIS/kg)
                    Calculated as: NIS_Total / (TON_Total * 1000)
                    (* 1000 converts tons to kg)
                    Returns NULL if TON_Total = 0 (division guard)

SOURCE TABLES:
  Import  - One row per country per month; must be summed
  Retail  - One row per month; joined on Year + Month

NOTES:
  - Value_NIS is on a CIF basis (Cost + Insurance + Freight),
    i.e. before customs tariff is applied
  - LEFT JOIN ensures months with import data but missing
    retail data still appear in the output
  - Import_Price reflects the blended average across all
    countries of origin for that month


SELECT
    i.Year,
    i.Month,
    SUM(i.Quantity_TON)                                                AS TON_Total,
    SUM(i.Value_NIS)                                                   AS NIS_Total,
    r.Price                                                            AS Price_Retail,
    CASE
        WHEN SUM(i.Quantity_TON) > 0
        THEN ROUND(SUM(i.Value_NIS) / (SUM(i.Quantity_TON) * 1000.0), 4)
        ELSE NULL
    END                                                                AS Import_Price
FROM Import i
LEFT JOIN Retail r
    ON i.Year = r.Year
    AND i.Month = r.Month
WHERE i.Year BETWEEN 2021 AND 2025
GROUP BY
    i.Year,
    i.Month,
    r.Price
ORDER BY
    i.Year,
    i.Month;
