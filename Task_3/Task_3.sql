-- Database Creation

CREATE DATABASE IF NOT EXISTS BikestoreDB;
USE BikestoreDB;

CREATE TABLE IF NOT EXISTS Customers
	(
		Customer_ID INT PRIMARY KEY,
        First_Name VARCHAR(100) NOT NULL,
        Last_Name VARCHAR(100),
        Phone VARCHAR(50),
        Email VARCHAR(100),
        Street VARCHAR(500),
        City VARCHAR(100),
        State VARCHAR(50),
        Zip_Code INT
	);

CREATE TABLE IF NOT EXISTS Stores
	(
		Store_ID INT PRIMARY KEY,
        Store_Name VARCHAR(100) NOT NULL,
        Phone VARCHAR(50),
        Email VARCHAR(100),
        Street VARCHAR(500),
        City VARCHAR(100),
        State VARCHAR(50),
        Zip_Code INT
	);

CREATE TABLE IF NOT EXISTS Staffs
	(
		Staff_ID INT PRIMARY KEY,
        First_Name VARCHAR(100) NOT NULL,
        Last_Name VARCHAR(100),
        Email VARCHAR(100),
        Phone VARCHAR(50),
        Is_Active TINYINT,
        Store_ID INT,
        Manager_ID INT NULL,
        FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
        FOREIGN KEY (Manager_ID) REFERENCES Staffs(Staff_ID)
	);

CREATE TABLE IF NOT EXISTS Categories
	(
		Category_ID INT PRIMARY KEY,
        Category_Name VARCHAR(100)
	);
    
CREATE TABLE IF NOT EXISTS Brands
	(
		Brand_ID INT PRIMARY KEY,
        Brand_Name VARCHAR(100)
	);
    
CREATE TABLE IF NOT EXISTS Products
	(
		Product_ID INT PRIMARY KEY,
        Product_Name VARCHAR(100),
        Brand_ID INT,
        Category_ID INT,
        Model_Year INT,
        List_Price DECIMAL(10, 2),
        FOREIGN KEY (Brand_ID) REFERENCES Brands(Brand_ID),
        FOREIGN KEY (Category_ID) REFERENCES Categories(Category_ID)        
	);

CREATE TABLE IF NOT EXISTS Stocks
	(
		Store_ID INT,
        Product_ID INT,
        Quantity INT,
		FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
        FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
	);
    
CREATE TABLE IF NOT EXISTS Orders
	(
		Order_ID INT PRIMARY KEY,
        Customer_ID INT,
        Order_Status INT,
        Order_Date DATE,
        Required_Date DATE,
        Shipped_Date DATE,
        Store_ID INT,
        Staff_ID INT,
        FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
        FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
        FOREIGN KEY (Staff_ID) REFERENCES Staffs(Staff_ID)
	);
    
CREATE TABLE IF NOT EXISTS Order_Items
	(
		Order_ID INT,
        Item_ID INT,
        Product_ID INT,
        Quantity INT,
        List_Price DECIMAL(10,2),
        Discount DECIMAL(10,2),
        FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
        FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
	);
    
-- Loading the Data from CSV files into respective tables
UPDATE Customers SET Phone = REPLACE(Phone, '(', '');
UPDATE Customers SET Phone = REPLACE(Phone, ')', '');
UPDATE Customers SET Phone = REPLACE(Phone, '-', '');

SHOW VARIABLES LIKE 'secure_file_priv';

SET sql_mode = '';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bike_Store_Dataset/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bike_Store_Dataset/Categories.csv'
INTO TABLE Categories
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bike_Store_Dataset/Brands.csv'
INTO TABLE Brands
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bike_Store_Dataset/Products.csv'
INTO TABLE Products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bike_Store_Dataset/Stores.csv'
INTO TABLE Stores
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bike_Store_Dataset/Staffs.csv'
INTO TABLE Staffs
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bike_Store_Dataset/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bike_Store_Dataset/Order_Items.csv'
INTO TABLE Order_Items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bike_Store_Dataset/Stocks.csv'
INTO TABLE Stocks
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

--  Extracting and Analyzing the data.

--  Using `SELECT`, `WHERE`, 'ORDER BY', 'GROUP BY' and `HAVING`.

SELECT * FROM Customers WHERE State = "NY";

--  Count number of customers from each state.

SELECT State, COUNT(State) AS Number_of_Customers FROM Customers GROUP BY Customers.State;

--  Selecting all the orders supplied from Store_ID 1.

SELECT * FROM Orders HAVING Store_ID = 1;

--  Identify Top 10 high-demand products using `GROUP BY`, `ORDER BY` to filter based on sales volume.

SELECT Product_ID, SUM(Quantity) AS Total_Units_Sold
FROM Order_Items
GROUP BY Product_ID
ORDER BY Total_Units_Sold DESC
LIMIT 10;

--  Using INNER JOIN to find staff assigned to a store.

SELECT S.Staff_ID, S.First_Name, S.Last_Name, S.Manager_ID, St.Store_Name
FROM Staffs S
JOIN Stores St ON S.Store_ID = St.Store_ID;

--  Using LEFT JOIN to identify discontinued or missing products that were still ordered.

SELECT OI.Product_ID, SUM(OI.Quantity) AS Quantity_Ordered, P.Product_Name
FROM Order_Items OI
LEFT JOIN Products P ON OI.Product_ID = P.Product_ID
GROUP BY OI.Product_ID
ORDER BY Quantity_Ordered DESC;


--  Using RIGHT JOIN to identify products that were never ordered.

SELECT P.Product_ID, P.Product_Name, SUM(OI.Quantity) AS Quantity_Ordered
FROM Products P
RIGHT JOIN Order_Items OI ON P.Product_ID = OI.Product_ID
GROUP BY OI.Product_ID
ORDER BY Quantity_Ordered ASC;

--  Using SUM() to calculate total revenue per product to understand revenue trends.

SELECT OI.Product_ID, P.Product_Name, SUM(ROUND(OI.Quantity*(OI.List_Price - ((OI.List_Price*OI.Discount)/100)), 2)) AS Total_Revenue
FROM Order_Items OI
JOIN Products P ON OI.Product_ID = P.Product_ID
GROUP BY OI.Product_ID
ORDER BY Total_Revenue DESC;

--  Using Subqueries and AVG() to find average purchase value for customers to identify high-value buyers.

WITH Revenue_Per_Customer AS (SELECT C.First_Name, C.Last_Name, C.City, C.State,
		     SUM(ROUND(OI.Quantity*(OI.List_Price - ((OI.List_Price*OI.Discount)/100)), 2)) AS Total_Purchase
             FROM Customers C
			 JOIN Orders O ON C.Customer_ID = O.Customer_ID
			 JOIN Order_Items OI ON OI.Order_ID = O.Order_ID
			 GROUP BY O.Customer_ID
		)
SELECT First_Name, Last_Name, City, State, Total_Purchase
FROM Revenue_Per_Customer
WHERE Total_Purchase > (SELECT AVG(Total_Purchase) FROM Revenue_Per_Customer)
ORDER BY Total_Purchase DESC;

--  Using View to summarize total revenue per store by aggregating sales data.

CREATE VIEW Total_Revenue_Per_Store AS
SELECT S.Store_Name, S.City, S.State,
SUM(ROUND(OI.Quantity*(OI.List_Price - ((OI.List_Price*OI.Discount)/100)), 2)) AS Total_Sales
FROM Stores S
JOIN Orders O ON S.Store_ID = O.Store_ID
JOIN Order_Items OI ON O.Order_ID = OI.Order_ID
GROUP BY S.Store_ID;

SELECT * FROM Total_Revenue_Per_Store;

--  Using Index to optimize search for a specific customer orders on the basis of Customer_ID.

CREATE INDEX IDX_CustID ON Orders(Customer_ID);

SELECT * FROM Orders WHERE Customer_ID = 5;