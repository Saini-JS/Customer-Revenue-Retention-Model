/* 
   Retention Action Base View
   ---------------------------
   Combines customer insights, churn probability, basket size,
   profit banding, and ticket burden to create a unified dataset
   for prioritising customer retention actions.
*/
CREATE OR ALTER VIEW dbo.vw_RetentionActionBase AS
WITH BasketStats AS (
    SELECT
         fs.CustomerKey
        ,AVG(CAST(order_stats.BasketLines AS FLOAT)) AS Avg_Basket_Size
    FROM (
        SELECT
             CustomerKey
            ,OrderID
            ,COUNT(*) AS BasketLines
        FROM dbo.Fact_Sales
        GROUP BY
             CustomerKey
            ,OrderID
    ) order_stats
    JOIN dbo.Fact_Sales fs
        ON order_stats.CustomerKey = fs.CustomerKey
       AND order_stats.OrderID = fs.OrderID
    GROUP BY
         fs.CustomerKey
),
Base AS (
    SELECT
         ci.CustomerKey
        ,ci.Customer_Tier
        ,ci.Region
        ,ci.Customer_Status
        ,ci.Total_Revenue
        ,ci.Total_Net_Profit
        ,ci.Avg_CSAT_Score
        ,ci.Total_Tickets_Count
        ,ci.Frequency_Count
        ,cp.ChurnProbability
        ,bs.Avg_Basket_Size
    FROM dbo.vw_CustomerInsights ci
    LEFT JOIN dbo.Fact_Churn_Predictions cp
        ON ci.CustomerKey = cp.CustomerKey
    LEFT JOIN BasketStats bs
        ON ci.CustomerKey = bs.CustomerKey
),
Banding AS (
    SELECT
         b.*
        ,CASE
            WHEN NTILE(3) OVER (ORDER BY b.Total_Net_Profit DESC) = 1 THEN 'High Value'
            WHEN NTILE(3) OVER (ORDER BY b.Total_Net_Profit DESC) = 2 THEN 'Mid Value'
            ELSE 'Low Value'
         END AS Profit_Band
        ,CASE
            WHEN b.Total_Tickets_Count = 0 THEN '0'
            WHEN b.Total_Tickets_Count = 1 THEN '1'
            WHEN b.Total_Tickets_Count <= 3 THEN '2-3'
            ELSE '4+'
         END AS Ticket_Burden_Band
    FROM Base b
)
SELECT *
FROM Banding;
GO
