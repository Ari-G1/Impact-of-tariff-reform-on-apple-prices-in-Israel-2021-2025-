Query 2: Monthly Apple Import & Retail Price Aggregation with Tariff
         Israel, 2021-2025

PURPOSE:
  Extends Query 1 by adding the Import_Price_With_Tax field,
  which adds the applicable customs tariff to the CIF import
  price for each month based on the tariff reform history.
  Query 1 is reused as a CTE to avoid repeating logic.

TARIFF HISTORY:
  Until Feb-2022:   1.81 NIS/kg
  From Mar-2022:    1.53 NIS/kg  (first reduction - agriculture reform)
  From Jan-2023:    1.34 NIS/kg  (second reduction)

OUTPUT FIELDS:
  Year                    - Calendar year
  Month                   - Calendar month (1-12)
  TON_Total               - Total import volume in metric tons
  NIS_Total               - Total import value in NIS (CIF basis)
  Price_Retail            - Average consumer retail price (NIS/kg)
  Import_Price            - Average CIF import price (NIS/kg)
                            Returns NULL if TON_Total = 0 (division guard)
  Import_Price_With_Tax   - CIF import price + applicable tariff (NIS/kg)
                            Returns NULL if Import_Price is NULL

NOTES:
  - The CTE (WITH q1 AS ...) encapsulates Query 1 so its logic
    is not repeated; the outer SELECT adds the new column on top
  - ORDER BY is placed only in the final SELECT, not inside the
    CTE (ORDER BY inside CTEs is non-standard and ignored in most
    databases outside SQLite)
  - The CASE statement maps each Year/Month to its correct tariff


WITH q1 AS (
    SELECT
        i.Year,
        i.Month,
        SUM(i.Quantity_TON)                                             AS TON_Total,
        SUM(i.Value_NIS)                                                AS NIS_Total,
        r.Price                                                         AS Price_Retail,
        CASE
            WHEN SUM(i.Quantity_TON) > 0
            THEN ROUND(SUM(i.Value_NIS) / (SUM(i.Quantity_TON) * 1000.0), 4)
            ELSE NULL
        END                                                             AS Import_Price
    FROM Import i
    LEFT JOIN Retail r
        ON i.Year = r.Year
        AND i.Month = r.Month
    WHERE i.Year BETWEEN 2021 AND 2025
    GROUP BY
        i.Year,
        i.Month,
        r.Price
)
SELECT
    *,
    CASE
        WHEN Import_Price IS NOT NULL
        THEN ROUND(
            Import_Price
            + CASE
                WHEN Year < 2022                    THEN 1.81
                WHEN Year = 2022 AND Month <= 2     THEN 1.81
                WHEN Year = 2022 AND Month >= 3     THEN 1.53
                WHEN Year >= 2023                   THEN 1.34
              END
        , 4)
        ELSE NULL
    END                                                                 AS Import_Price_With_Tax
FROM q1
ORDER BY
    Year,
    Month;
