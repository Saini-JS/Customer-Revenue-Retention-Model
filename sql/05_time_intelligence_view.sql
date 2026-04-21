/* 
   Time Intelligence View
   -----------------------
   Produces daily revenue and net profit metrics for KPI dashboards.
   Used for trendlines, period comparisons, and executive reporting.
*/
CREATE OR ALTER VIEW dbo.vw_TimeIntelligence AS 
WITH DailyAllocation AS (
    SELECT 
        s.OrderDate,
        s.OrderID,
        s.TotalRevenue,
        ((p.UnitPrice - p.CostPrice) * s.Quantity) - 
        (s.ShippingCost / COUNT(*) OVER(PARTITION BY s.OrderID)) AS NetProfit
    FROM dbo.Fact_Sales s
    JOIN dbo.Dim_Products p ON s.ProductKey = p.ProductKey
)
SELECT 
    CAST(OrderDate AS DATE) AS OrderDate, 
    SUM(TotalRevenue) as DailyRev, 
    SUM(NetProfit) as DailyProfit 
FROM DailyAllocation 
GROUP BY CAST(OrderDate AS DATE);
GO
