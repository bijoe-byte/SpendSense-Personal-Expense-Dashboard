CREATE DATABASE SpendSenseDB;
USE SpendSenseDB;

CREATE TABLE SpendSense_Dashboard (
    User_ID INT,
    Customer_Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(20),
    Occupation VARCHAR(100),
    City VARCHAR(100),
    Transaction_ID VARCHAR(50),
    Transaction_Date DATE,
    Expense_Category VARCHAR(100),
    Merchant VARCHAR(100),
    Expense_Amount DECIMAL(12,2),
    Monthly_Income DECIMAL(12,2),
    Payment_Method VARCHAR(50),
    Budget_Allocated DECIMAL(12,2),
    Estimated_Savings DECIMAL(12,2),
    Credit_Score INT,
    User_Rating DECIMAL(3,1),
    Recurring_Expense VARCHAR(10),
    Budget_Risk_Level VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SpendSense_Dashboard.csv'
INTO TABLE SpendSense_Dashboard
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
User_ID,
Customer_Name,
Age,
Gender,
Occupation,
City,
Transaction_ID,
@Transaction_Date,
Expense_Category,
Merchant,
Expense_Amount,
Monthly_Income,
Payment_Method,
Budget_Allocated,
Estimated_Savings,
Credit_Score,
User_Rating,
Recurring_Expense,
Budget_Risk_Level
)
SET Transaction_Date = STR_TO_DATE(@Transaction_Date,'%m/%d/%Y');

SELECT ROUND(SUM(Expense_Amount),2) AS Total_Expense
FROM SpendSense_Dashboard;

SELECT ROUND(SUM(Monthly_Income),2) AS Total_Income
FROM SpendSense_Dashboard;

SELECT ROUND(SUM(Monthly_Income)-SUM(Expense_Amount),2) AS Net_Savings
FROM SpendSense_Dashboard;

SELECT ROUND(AVG(Expense_Amount),2) AS Avg_Monthly_Expense
FROM SpendSense_Dashboard;

SELECT COUNT(*) AS High_Risk_Users
FROM SpendSense_Dashboard
WHERE Budget_Risk_Level='High Risk';

SELECT
MONTH(Transaction_Date) AS Month_No,
MONTHNAME(Transaction_Date) AS Month_Name,
ROUND(SUM(Expense_Amount),2) AS Total_Expense
FROM SpendSense_Dashboard
GROUP BY MONTH(Transaction_Date), MONTHNAME(Transaction_Date)
ORDER BY Month_No;

SELECT
Expense_Category,
ROUND(SUM(Expense_Amount),2) AS Total_Expense
FROM SpendSense_Dashboard
GROUP BY Expense_Category
ORDER BY Total_Expense DESC;

SELECT
City,
ROUND(SUM(Expense_Amount),2) AS Total_Expense
FROM SpendSense_Dashboard
GROUP BY City
ORDER BY Total_Expense DESC;

SELECT
Payment_Method,
ROUND(SUM(Expense_Amount),2) AS Total_Expense
FROM SpendSense_Dashboard
GROUP BY Payment_Method
ORDER BY Total_Expense DESC;

SELECT
CASE
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
END AS Age_Group,
ROUND(SUM(Expense_Amount),2) AS Total_Expense
FROM SpendSense_Dashboard
GROUP BY Age_Group;

SELECT
MONTH(Transaction_Date) AS Month_No,
MONTHNAME(Transaction_Date) AS Month_Name,
ROUND(SUM(Expense_Amount),2) AS Actual_Expense,
ROUND(SUM(Budget_Allocated),2) AS Budget
FROM SpendSense_Dashboard
GROUP BY MONTH(Transaction_Date), MONTHNAME(Transaction_Date)
ORDER BY Month_No;

SELECT
Budget_Risk_Level,
COUNT(*) AS Total_Users
FROM SpendSense_Dashboard
GROUP BY Budget_Risk_Level;