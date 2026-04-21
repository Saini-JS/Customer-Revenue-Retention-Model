/* 
 QUERY: RevenueLeakage 
-----------------------------------------------------------------------
 Revenue Leakage = Revenue for Orders with Tickets in Category /
                   Total Business Revenue

-- REVENUE AT RISK: Only include revenue from customers who ARE NOT CHURNED
-- REVENUE LOST: Include revenue from customers who HAVE already churned

*/

CREATE OR ALTER VIEW dbo.vw_RevenueLeakage AS 
WITH Total_Business AS (
    SELECT SUM(TotalRevenue) AS Global_Revenue 
    FROM dbo.Fact_Sales
),
Category_Analysis AS (
    SELECT 
        ft.IssueCategory,
        COUNT(ft.TicketID) AS Total_Tickets,
        AVG(CAST(ft.CSAT_Score AS FLOAT)) AS Avg_CSAT_Score,
        -- REVENUE AT RISK: Only include revenue from customers who ARE NOT CHURNED
        SUM(CASE WHEN ci.Customer_Status != 'Churned' THEN s.TotalRevenue ELSE 0 END) AS Revenue_At_Risk,
        -- REVENUE LOST: Include revenue from customers who HAVE already churned
        SUM(CASE WHEN ci.Customer_Status = 'Churned' THEN s.TotalRevenue ELSE 0 END) AS Revenue_Lost
    FROM dbo.Fact_Support_Tickets ft
    INNER JOIN dbo.Fact_Sales s ON ft.SalesID = s.SalesID
    INNER JOIN dbo.vw_CustomerInsights ci ON s.CustomerKey = ci.CustomerKey 
    GROUP BY ft.IssueCategory
)
SELECT 
    ca.*,
    ((ca.Revenue_At_Risk / NULLIF(tb.Global_Revenue, 0)) * 100) AS [Risk_Percent]
FROM Category_Analysis ca
CROSS JOIN Total_Business tb;
GO
