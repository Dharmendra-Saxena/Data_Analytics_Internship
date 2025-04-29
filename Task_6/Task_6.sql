-- Database Creation

CREATE DATABASE IF NOT EXISTS Online_Store;
USE Online_Store;

--  Table creation

CREATE TABLE IF NOT EXISTS Online_Sales
	(
		InvoiceNo INT,
        StockCode VARCHAR(50) NOT NULL,
        Description VARCHAR(100),
        Quantity INT,
        InvoiceDate DATETIME,
        UnitPrice DECIMAL(10,2),
        CustomerID INT,
        Country VARCHAR(50),
        Discount DECIMAL(10,2),
        PaymentMethod VARCHAR(25),
        ShippingCost DECIMAL(10,2),
        Category VARCHAR(50),
        SalesChannel VARCHAR(50),
        ReturnStatus VARCHAR(50),
        ShipmentProvider VARCHAR(50),
        WarehouseLocation VARCHAR(50),
        OrderPriority VARCHAR(25)
	);

--  Loading the data from the dataset

SET sql_mode = '';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Online_Store/online_sales_dataset.csv'
INTO TABLE Online_Sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET CustomerID = NULLIF(CustomerID, '');

--  Using EXTRACT(MONTH FROM order_date) for month

--  Extracting all the orders processed in the month of February from Italy

SELECT InvoiceNo, CustomerID, StockCode, Description, Country
FROM Online_Sales
WHERE MONTH(InvoiceDate) = 2 AND Country = "Italy";

--  Using GROUP BY year/month.

--  Extracting year-wise total sales

SELECT YEAR(InvoiceDate) AS Year, ROUND(SUM(Quantity * (UnitPrice - ((UnitPrice * Discount)/100))), 2) AS Total_Yearly_Sales
FROM Online_Sales
WHERE UnitPrice > 0
GROUP BY Year;

--  Using SUM() for revenue.

--  Extracting Country-wise total sales

SELECT Country, ROUND(SUM(Quantity * (UnitPrice - ((UnitPrice * Discount)/100))), 2) AS Total_Sales
FROM Online_Sales
WHERE UnitPrice > 0
GROUP BY Country;

--  Using COUNT(DISTINCT order_id) for volume.

--  Extracting number of orders supplied to each country

SELECT Country, COUNT(DISTINCT InvoiceNo) AS Total_Orders_Processed
FROM Online_Sales
GROUP BY Country;

--  Using ORDER BY for sorting.

--  Listing the Item-wise sales in descending order.

SELECT StockCode, Description, ROUND(SUM(Quantity * (UnitPrice - ((UnitPrice * Discount)/100))), 2) AS Total_Sales
FROM Online_Sales
GROUP BY StockCode
ORDER BY Total_Sales DESC;

--  Limiting results for specific time periods.

--  Extracting total number of items shipped between 11-April-2020 to 20-April-2020.

SELECT DATE(InvoiceDate) AS Date, SUM(Quantity) AS Number_of_Items_Shipped
FROM Online_Sales
WHERE DATE(InvoiceDate) BETWEEN '2020-04-11' AND '2020-04-20'
GROUP BY Date
ORDER BY Date;
