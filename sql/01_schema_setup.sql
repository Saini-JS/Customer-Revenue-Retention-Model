/* 
    Schema Setup Script
    Creates core dimensions and fact tables for the Customer Revenue Retention Model.
    Includes safe-drop logic, constraints, and basic indexing.
*/

USE Wine_Analytics_UK;
GO

-- 0. Safely drop existing tables (reverse dependency order)
IF OBJECT_ID('dbo.Fact_Support_Tickets', 'U') IS NOT NULL DROP TABLE dbo.Fact_Support_Tickets;
IF OBJECT_ID('dbo.Fact_Sales', 'U') IS NOT NULL DROP TABLE dbo.Fact_Sales;
IF OBJECT_ID('dbo.Dim_Customers', 'U') IS NOT NULL DROP TABLE dbo.Dim_Customers;
IF OBJECT_ID('dbo.Dim_Products', 'U') IS NOT NULL DROP TABLE dbo.Dim_Products;
GO

-- 1. Product Dimension
CREATE TABLE Dim_Products (
    ProductKey INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50), 
    UnitPrice DECIMAL(10,2) NOT NULL,
    CostPrice DECIMAL(10,2) NOT NULL,
    IsActive BIT DEFAULT 1,
    ValidFrom DATETIME DEFAULT GETDATE(),
    CONSTRAINT CHK_Price CHECK (UnitPrice >= 0 AND CostPrice >= 0)
);

-- 2. Customer Dimension (supports SCD logic)
CREATE TABLE Dim_Customers (
    CustomerKey INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    Region NVARCHAR(50), 
    Tier NVARCHAR(20), 
    IsActive BIT DEFAULT 1, 
    ValidFrom DATETIME NOT NULL DEFAULT GETDATE(),
    ValidTo DATETIME NULL,
    RowHash VARBINARY(64) NULL
);

-- 3. Sales Fact Table
CREATE TABLE Fact_Sales (
    SalesID INT PRIMARY KEY IDENTITY(1,1), 
    OrderID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    CustomerKey INT NOT NULL, 
    ProductKey INT NOT NULL,  
    Quantity INT NOT NULL CHECK (Quantity > 0),
    TotalRevenue DECIMAL(18,2) NOT NULL,
    ShippingCost DECIMAL(10,2) NOT NULL,   
    ETL_LoadDate DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Sales_Customer FOREIGN KEY (CustomerKey) REFERENCES Dim_Customers(CustomerKey),
    CONSTRAINT FK_Sales_Product FOREIGN KEY (ProductKey) REFERENCES Dim_Products(ProductKey)
);

-- 4. Support / CSAT Fact Table
CREATE TABLE Fact_Support_Tickets (
    TicketID INT PRIMARY KEY IDENTITY(1,1),
    SalesID INT NOT NULL, 
    IssueCategory NVARCHAR(100) NOT NULL, 
    CSAT_Score INT CHECK (CSAT_Score BETWEEN 1 AND 5),
    ResolutionTimeHours INT,
    IsEscalated BIT DEFAULT 0,
    
    CONSTRAINT FK_Support_Sales FOREIGN KEY (SalesID) REFERENCES Fact_Sales(SalesID)
);

-- 5. Basic Indexing
CREATE INDEX IX_FactSales_OrderDate ON Fact_Sales(OrderDate);
CREATE INDEX IX_FactSales_Customer ON Fact_Sales(CustomerKey);
CREATE INDEX IX_FactSupport_CSAT ON Fact_Support_Tickets(CSAT_Score);
GO
