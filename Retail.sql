CREATE DATABASE MyDatabase;
USE MyDatabase;
CREATE TABLE items (
    `Line` INT,
    `Time` DATETIME,
    `Register Name/Number` VARCHAR(255),
    `Cashier Name` VARCHAR(255),
    `Operation Type` VARCHAR(255),
    `Store Code` VARCHAR(255),
    `UPC` VARCHAR(255),
    `Line Item` VARCHAR(255),
    `Department` VARCHAR(255),
    `Category` VARCHAR(255),
    `Supplier` VARCHAR(255),
    `Supplier Code` VARCHAR(255),
    `Cost` FLOAT,
    `Price` FLOAT,
    `Quantity` INT,
    `Modifiers` INT,
    `Subtotal` FLOAT,
    `Discounts` FLOAT,
    `Net Total` FLOAT,
    `Tax` FLOAT,
    `Total Due` FLOAT,
    `Transaction ID` VARCHAR(255),
    `Customer ID` INT,
    `Year` INT,
    `Month` INT
);

LOAD DATA LOCAL INFILE '/Users/songanisaikiran/Downloads/cleaned_ITEMS_combined.csv'
INTO TABLE items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 1. Average Order Value by Dollars for Each Winery:
SELECT
    `Year`,
    `Cashier Name`,
    ROUND(AVG(`OrderTotal`), 2) AS `AverageOrderValue`
FROM
    (SELECT
        `Transaction ID`,
        `Year`,
        `Cashier Name`,
        SUM(`Total Due`) AS `OrderTotal`
    FROM items
    WHERE `Cashier Name` IN ('effingham Manager', 'pearmundcellars Manager')
    GROUP BY `Transaction ID`, `Year`, `Cashier Name`) AS subquery
GROUP BY `Year`, `Cashier Name`
ORDER BY `Year`, `Cashier Name`;


-- average aorder value by monthwise for each winery
SELECT
    `Cashier Name`,
    `Year`,
    CASE 
        WHEN `Month` = 1 THEN 'January'
        WHEN `Month` = 2 THEN 'February'
        WHEN `Month` = 3 THEN 'March'
        WHEN `Month` = 4 THEN 'April'
        WHEN `Month` = 5 THEN 'May'
        WHEN `Month` = 6 THEN 'June'
        WHEN `Month` = 7 THEN 'July'
        WHEN `Month` = 8 THEN 'August'
        WHEN `Month` = 9 THEN 'September'
        WHEN `Month` = 10 THEN 'October'
        WHEN `Month` = 11 THEN 'November'
        WHEN `Month` = 12 THEN 'December'
    END AS `MonthName`,
    ROUND(AVG(`OrderTotal`), 2) AS `AverageOrderValue`
FROM
    (SELECT
        `Transaction ID`,
        `Cashier Name`,
        `Year`,
        `Month`,
        SUM(`Total Due`) AS `OrderTotal`
    FROM items
    GROUP BY `Transaction ID`, `Cashier Name`, `Year`, `Month`) AS subquery
WHERE
    `Cashier Name` IN ('effingham Manager', 'pearmundcellars Manager')
GROUP BY `Cashier Name`, `Year`, `Month`
ORDER BY `Cashier Name`, `Year`, `Month`;

-- Average order value by bottles of wine
SELECT
    `Year`,
    CASE 
        WHEN `Month` = 1 THEN 'January'
        WHEN `Month` = 2 THEN 'February'
        WHEN `Month` = 3 THEN 'March'
        WHEN `Month` = 4 THEN 'April'
        WHEN `Month` = 5 THEN 'May'
        WHEN `Month` = 6 THEN 'June'
        WHEN `Month` = 7 THEN 'July'
        WHEN `Month` = 8 THEN 'August'
        WHEN `Month` = 9 THEN 'September'
        WHEN `Month` = 10 THEN 'October'
        WHEN `Month` = 11 THEN 'November'
        WHEN `Month` = 12 THEN 'December'
    END AS `MonthName`,
    ROUND(SUM(`Total Due`) / SUM(`Quantity`), 2) AS `AverageOrderValuePerBottle`
FROM items
WHERE 
    `Category` = 'WINE' -- Assuming 'Category' column indicates whether the item is wine
    AND `Quantity` > 0  -- Considering only positive quantities (sales, not returns)
GROUP BY `Year`, `Month`
ORDER BY `Year`, `Month`;


-- Average order value by dollars and by bottles of wine for both wineries on a month-to-month basis:
WITH MonthlyRevenue AS (
    SELECT
        `Year`,
        `Month`,
        `Cashier Name`,
        ROUND(SUM(`Total Due`) / COUNT(DISTINCT `Transaction ID`), 2) AS `AverageOrderValueByDollars`
    FROM items
    WHERE 
        `Cashier Name` IN ('effingham Manager', 'pearmundcellars Manager')
        AND (
            (`Year` = 2022 AND `Month` >= 9) 
            OR 
            (`Year` = 2023 AND `Month` <= 9)
        )
    GROUP BY `Year`, `Month`, `Cashier Name`
),

MonthlyBottleSales AS (
    SELECT
        `Year`,
        `Month`,
        `Cashier Name`,
        ROUND(SUM(`Total Due`) / SUM(`Quantity`), 2) AS `AverageOrderValuePerBottle`
    FROM items
    WHERE 
        `Category` = 'WINE'
        AND `Quantity` > 0
        AND `Cashier Name` IN ('effingham Manager', 'pearmundcellars Manager')
        AND (
            (`Year` = 2022 AND `Month` >= 9) 
            OR 
            (`Year` = 2023 AND `Month` <= 9)
        )
    GROUP BY `Year`, `Month`, `Cashier Name`
)

SELECT
    r.`Year`,
    CASE 
        WHEN r.`Month` = 1 THEN 'January'
        WHEN r.`Month` = 2 THEN 'February'
        WHEN r.`Month` = 3 THEN 'March'
        WHEN r.`Month` = 4 THEN 'April'
        WHEN r.`Month` = 5 THEN 'May'
        WHEN r.`Month` = 6 THEN 'June'
        WHEN r.`Month` = 7 THEN 'July'
        WHEN r.`Month` = 8 THEN 'August'
        WHEN r.`Month` = 9 THEN 'September'
        WHEN r.`Month` = 10 THEN 'October'
        WHEN r.`Month` = 11 THEN 'November'
        WHEN r.`Month` = 12 THEN 'December'
    END AS `MonthName`,
    r.`Cashier Name` AS `Winery`,
    r.`AverageOrderValueByDollars`,
    b.`AverageOrderValuePerBottle`
FROM MonthlyRevenue r
JOIN MonthlyBottleSales b 
    ON r.`Year` = b.`Year` AND r.`Month` = b.`Month` AND r.`Cashier Name` = b.`Cashier Name`
ORDER BY r.`Cashier Name`, r.`Year`, r.`Month`;


















