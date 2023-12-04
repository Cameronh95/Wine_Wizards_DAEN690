CREATE DATABASE SAI;
USE SAI;
CREATE TABLE VWDC_Combined (
    Winery VARCHAR(255),
    Licensee_Name VARCHAR(255),
    Licensee_Number BIGINT,
    Licensee_City VARCHAR(255),
    Product_Name VARCHAR(255),
    Vintage YEAR,
    Container_Size FLOAT,
    PO_Date DATE,
    PO_Number VARCHAR(255),
    Total_Cases FLOAT,
    Wine_Liters FLOAT,
    Cider_Liters FLOAT,
    PO_Total FLOAT,
    Discount_Amount FLOAT,
    Invoice_Total FLOAT
);

LOAD DATA LOCAL INFILE '/Users/songanisaikiran/Desktop/cleaned datasets/VWDC_Combined.csv'
INTO TABLE VWDC_Combined
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Winery, Licensee_Name, Licensee_Number, Licensee_City, Product_Name, @var_vintage, Container_Size, @var_po_date, PO_Number, Total_Cases, Wine_Liters, Cider_Liters, PO_Total, Discount_Amount, Invoice_Total)
SET
    Vintage = STR_TO_DATE(NULLIF(@var_vintage, ''), '%Y'),
    PO_Date = STR_TO_DATE(NULLIF(@var_po_date, ''), '%m/%d/%y');
    


-- Which counties purchase the most wine (in terms of cases)?
SELECT 
    CASE 
        WHEN Licensee_City IN ('NOKESVILLE', 'Haymarket', 'Gainesville') THEN 'Prince William County'
        WHEN Licensee_City IN ('Bealeton', 'BROAD RUN', 'WARRENTON', 'Warrenton') THEN 'Fauquier County'
        WHEN Licensee_City = 'Louisa' THEN 'Louisa County'
        WHEN Licensee_City = 'Manassas' THEN 'Manassas City'
        WHEN Licensee_City = 'Virginia Beach' THEN 'Virginia Beach City'
        WHEN Licensee_City = 'Clear Brook' THEN 'Frederick County'
        WHEN Licensee_City = 'Chesapeake' THEN 'Chesapeake City'
        WHEN Licensee_City = 'Middleburg' THEN 'Loudoun County'
        WHEN Licensee_City = 'Elkwood' THEN 'Culpeper County'
        WHEN Licensee_City = 'Newport News' THEN 'Newport News City'
        WHEN Licensee_City = 'Vienna' THEN 'Fairfax County'
        ELSE Licensee_City
    END AS County,
    ROUND(SUM(Total_Cases), 2) AS Total_Wine_Cases_Purchased
FROM 
    VWDC_Combined
GROUP BY 
    CASE 
        WHEN Licensee_City IN ('NOKESVILLE', 'Haymarket', 'Gainesville') THEN 'Prince William County'
        WHEN Licensee_City IN ('Bealeton', 'BROAD RUN', 'WARRENTON', 'Warrenton') THEN 'Fauquier County'
        WHEN Licensee_City = 'Louisa' THEN 'Louisa County'
        WHEN Licensee_City = 'Manassas' THEN 'Manassas City'
        WHEN Licensee_City = 'Virginia Beach' THEN 'Virginia Beach City'
        WHEN Licensee_City = 'Clear Brook' THEN 'Frederick County'
        WHEN Licensee_City = 'Chesapeake' THEN 'Chesapeake City'
        WHEN Licensee_City = 'Middleburg' THEN 'Loudoun County'
        WHEN Licensee_City = 'Elkwood' THEN 'Culpeper County'
        WHEN Licensee_City = 'Newport News' THEN 'Newport News City'
        WHEN Licensee_City = 'Vienna' THEN 'Fairfax County'
        ELSE Licensee_City
    END
ORDER BY 
    Total_Wine_Cases_Purchased DESC;


        
-- Which wine is most purchased in each county?
WITH MostPurchased AS (
    SELECT 
        CASE 
            WHEN Licensee_City IN ('NOKESVILLE', 'Haymarket', 'Gainesville') THEN 'Prince William County'
            WHEN Licensee_City IN ('Bealeton', 'BROAD RUN', 'WARRENTON', 'Warrenton') THEN 'Fauquier County'
            WHEN Licensee_City = 'Louisa' THEN 'Louisa County'
            WHEN Licensee_City = 'Manassas' THEN 'Manassas City'
            WHEN Licensee_City = 'Virginia Beach' THEN 'Virginia Beach City'
            WHEN Licensee_City = 'Clear Brook' THEN 'Frederick County'
            WHEN Licensee_City = 'Chesapeake' THEN 'Chesapeake City'
            WHEN Licensee_City = 'Middleburg' THEN 'Loudoun County'
            WHEN Licensee_City = 'Elkwood' THEN 'Culpeper County'
            WHEN Licensee_City = 'Newport News' THEN 'Newport News City'
            WHEN Licensee_City = 'Vienna' THEN 'Fairfax County'
            ELSE Licensee_City
        END AS County,
        Product_Name,
        ROUND(SUM(Total_Cases), 2) as Total_Cases,
        ROW_NUMBER() OVER(PARTITION BY 
            CASE 
                WHEN Licensee_City IN ('NOKESVILLE', 'Haymarket', 'Gainesville') THEN 'Prince William County'
                WHEN Licensee_City IN ('Bealeton', 'BROAD RUN', 'WARRENTON', 'Warrenton') THEN 'Fauquier County'
                WHEN Licensee_City = 'Louisa' THEN 'Louisa County'
                WHEN Licensee_City = 'Manassas' THEN 'Manassas City'
                WHEN Licensee_City = 'Virginia Beach' THEN 'Virginia Beach City'
                WHEN Licensee_City = 'Clear Brook' THEN 'Frederick County'
                WHEN Licensee_City = 'Chesapeake' THEN 'Chesapeake City'
                WHEN Licensee_City = 'Middleburg' THEN 'Loudoun County'
                WHEN Licensee_City = 'Elkwood' THEN 'Culpeper County'
                WHEN Licensee_City = 'Newport News' THEN 'Newport News City'
                WHEN Licensee_City = 'Vienna' THEN 'Fairfax County'
                ELSE Licensee_City
            END 
        ORDER BY SUM(Total_Cases) DESC) as rn
    FROM 
        VWDC_Combined
    GROUP BY 
        CASE 
            WHEN Licensee_City IN ('NOKESVILLE', 'Haymarket', 'Gainesville') THEN 'Prince William County'
            WHEN Licensee_City IN ('Bealeton', 'BROAD RUN', 'WARRENTON', 'Warrenton') THEN 'Fauquier County'
            WHEN Licensee_City = 'Louisa' THEN 'Louisa County'
            WHEN Licensee_City = 'Manassas' THEN 'Manassas City'
            WHEN Licensee_City = 'Virginia Beach' THEN 'Virginia Beach City'
            WHEN Licensee_City = 'Clear Brook' THEN 'Frederick County'
            WHEN Licensee_City = 'Chesapeake' THEN 'Chesapeake City'
            WHEN Licensee_City = 'Middleburg' THEN 'Loudoun County'
            WHEN Licensee_City = 'Elkwood' THEN 'Culpeper County'
            WHEN Licensee_City = 'Newport News' THEN 'Newport News City'
            WHEN Licensee_City = 'Vienna' THEN 'Fairfax County'
            ELSE Licensee_City
        END, 
        Product_Name
)
SELECT County, Product_Name, Total_Cases
FROM MostPurchased
WHERE rn = 1
ORDER BY Total_Cases DESC;



--  What months do licensees purchase the most wine?

 -- Query to find the months when licensees purchase the most wine from pearmund:
 SELECT 
    MONTHNAME(PO_Date) AS Month,
    ROUND(SUM(Total_Cases), 2) AS TotalCasesPurchased
FROM 
    VWDC_Combined
WHERE
    Winery = 'Pearmund'
GROUP BY 
    MONTH(PO_Date), MONTHNAME(PO_Date)
ORDER BY 
    TotalCasesPurchased DESC;
       

-- Query to find the months when licensees purchase the most wine from Effingham:

SELECT 
    MONTHNAME(PO_Date) AS Month,
    ROUND(SUM(Total_Cases), 2) AS TotalCasesPurchased
FROM 
    VWDC_Combined
WHERE
    Winery = 'Effingham'
GROUP BY 
    MONTH(PO_Date), MONTHNAME(PO_Date)
ORDER BY 
    TotalCasesPurchased DESC;
    
   