USE TOY_STORE;

alter table sales
alter column date DATE;


alter table sales
alter column UNITS INT;

alter table sales
alter column STORE_ID INT;

alter table products
alter column product_id INT;

alter table SALES
alter column product_id INT;

alter table STORES
alter column STORE_ID INT;

alter table INVENTORY
alter column STOCK_ON_HAND INT;

SELECT * FROM STORES;
SELECT * FROM SALES;
SELECT * FROM PRODUCTS;


------------------summary------------------------------
CREATE VIEW Summary AS
SELECT 
    (SELECT COUNT(STORE_NAME) FROM STORES) AS TOTAL_STORES,
    (SELECT COUNT(DISTINCT(PRODUCT_NAME)) FROM PRODUCTS) AS TOTAL_PRODUCTS,
    (SELECT COUNT(DISTINCT(STORE_CITY)) FROM STORES) AS CITY_COUNT,
    (SELECT SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) 
     FROM PRODUCTS P 
     JOIN SALES S ON P.PRODUCT_ID = S.PRODUCT_ID) AS TOTAL_SALE;


SELECT * FROM SUMMARY;

-----monthly sale in each store-----
CREATE VIEW MONTHLYSALE AS
SELECT 
    YEAR(s.date) AS sales_year, 
    MONTH(s.date) AS sales_month, 
    st.store_name, 
    SUM(CAST(REPLACE(p.product_price,'$', '') AS DECIMAL(10,2))* S.UNITS) AS TOTAL_SALE
FROM 
    stores st
JOIN 
    sales s ON st.store_id = s.store_id
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    YEAR(s.date), 
    MONTH(s.date), 
    st.store_name;

SELECT * FROM MONTHLYSALE;

--------------monthly sale based on location---------------
CREATE VIEW LOCATIONSALE AS
SELECT 
    YEAR(s.date) AS sales_year, 
    MONTH(s.date) AS sales_month, 
    st.store_location,
    SUM(CAST(REPLACE(p.product_price,'$', '') AS DECIMAL(10,2))* S.UNITS) AS TOTAL_SALE
FROM 
    stores st
JOIN 
    sales s ON st.store_id = s.store_id
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    YEAR(s.date), 
    MONTH(s.date), 
    st.store_location;


SELECT * FROM LOCATIONSALE ORDER BY sales_month;

-------------year wise sale in each store------------
CREATE VIEW YEARLYSTORESALE AS
SELECT 
    YEAR(s.date) AS sales_year, 
    st.store_name, 
    SUM(CAST(REPLACE(p.product_price,'$', '') AS DECIMAL(10,2))* S.UNITS) AS TOTAL_SALE
FROM 
    stores st
JOIN 
    sales s ON st.store_id = s.store_id
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    YEAR(s.date), 
    st.store_name;

SELECT * FROM YEARLYSTORESALE;

--------------top 5 cities in overall sale---------------
CREATE VIEW TOPCITIES AS
SELECT   
    st.store_city,
    SUM(CAST(REPLACE(p.product_price,'$', '') AS DECIMAL(10,2))* S.UNITS) AS TOTAL_SALE
FROM 
    stores st
JOIN 
    sales s ON st.store_id = s.store_id
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    st.store_city;


SELECT top 5 * FROM topcities ORDER BY TOTAL_SALE desc;


-------------TOP 5 AND LEAST 5 STORES YEAR WISE------------
CREATE VIEW TOPLEASTSOTRES AS
WITH RankedSales AS (
    SELECT 
        YEAR(s.date) AS sales_year, 
        st.store_name, 
        SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2))* S.UNITS) AS total_sale,
        RANK() OVER (PARTITION BY YEAR(s.date) ORDER BY SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2))* S.UNITS) DESC) AS rank_desc,
        RANK() OVER (PARTITION BY YEAR(s.date) ORDER BY SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2))* S.UNITS) ASC) AS rank_asc
    FROM 
        stores st
    JOIN 
        sales s ON st.store_id = s.store_id
    JOIN 
        products p ON s.product_id = p.product_id
    GROUP BY 
        YEAR(s.date), 
        st.store_name
)
SELECT 
    sales_year, 
    store_name, 
    total_sale,
    CASE 
        WHEN rank_desc <= 5 THEN 'Top 5'
        WHEN rank_asc <= 5 THEN 'Least 5'
    END AS category
FROM 
    RankedSales
WHERE 
    rank_desc <= 5 OR rank_asc <= 5;

SELECT * FROM TOPLEASTSOTRES ORDER BY 
    sales_year, 
    category, 
    total_sale DESC;


----------------STORES PERFORMED BETTER THAN LAST YEAR--------------------------
CREATE VIEW StoresImprovedSales AS
WITH YearlySales AS (
    SELECT 
        YEAR(s.date) AS sales_year, 
        st.store_name, 
        SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10,2))* S.UNITS) AS total_sale
    FROM 
        stores st
    JOIN 
        sales s ON st.store_id = s.store_id
    JOIN 
        products p ON s.product_id = p.product_id
    GROUP BY 
        YEAR(s.date), 
        st.store_name
),
SalesComparison AS (
    SELECT 
        a.store_name,
        a.total_sale AS sale_2023,
        b.total_sale AS sale_2022
    FROM 
        YearlySales a
    LEFT JOIN 
        YearlySales b 
        ON a.store_name = b.store_name AND a.sales_year = 2023 AND b.sales_year = 2022
)
SELECT 
    store_name, 
    sale_2023, 
    sale_2022
FROM 
    SalesComparison
WHERE 
    sale_2023 > sale_2022;

SELECT * FROM StoresImprovedSales;

-----------QUATERLY SALE FOR EACH STORE-------------
CREATE VIEW QUATERLYSALE AS
SELECT 
    st.store_name, 
    YEAR(s.date) AS sales_year, 
    DATEPART(QUARTER, s.date) AS sales_quarter, 
    SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) AS total_sales
FROM 
    stores st
JOIN 
    sales s ON st.store_id = s.store_id
JOIN 
    products p ON s.product_id = p.product_id
WHERE 
    YEAR(s.date) IN (2022, 2023)
GROUP BY 
    st.store_name, 
    YEAR(s.date), 
    DATEPART(QUARTER, s.date);

SELECT * FROM QUATERLYSALE ORDER BY 
    store_name, 
    sales_year, 
    sales_quarter;

------------------STORE PERFORM WELL IN EACH QUATER---------------------
CREATE VIEW QuarterlyTopStores AS
WITH QuarterlySales AS (
    SELECT 
        YEAR(s.date) AS sales_year,
        DATEPART(QUARTER, s.date) AS sales_quarter,
        st.store_name,
        SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) AS total_sales,
        RANK() OVER (PARTITION BY YEAR(s.date), DATEPART(QUARTER, s.date) ORDER BY SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) DESC) AS sales_rank
    FROM 
        stores st
    JOIN 
        sales s ON st.store_id = s.store_id
    JOIN 
        products p ON s.product_id = p.product_id
    GROUP BY 
        YEAR(s.date),
        DATEPART(QUARTER, s.date),
        st.store_name
)
SELECT 
    sales_year,
    sales_quarter,
    store_name,
    total_sales
FROM 
    QuarterlySales
WHERE 
    sales_rank = 1;

SELECT * FROM QuarterlyTopStores ORDER BY 
    sales_year, 
    sales_quarter;


-------------------top 5 PRODUCTS PERFORM WELL IN OVERALL SALE----------------------------------
CREATE VIEW TOPFIVEPRODUCT AS
SELECT P.PRODUCT_NAME, SUM(CAST(REPLACE(P.PRODUCT_PRICE, '$','') AS DECIMAL(10,2))* S.UNITS) AS TOTAL_SALE
FROM PRODUCTS P JOIN SALES S ON P.PRODUCT_ID = S.PRODUCT_ID
GROUP BY P.PRODUCT_NAME;

SELECT TOP 5 * FROM TOPFIVEPRODUCT ORDER BY TOTAL_SALE DESC;


-------------MOST PROFITABLE PRODUCT IN EACH YEAR----------------
CREATE VIEW PROFITABLEPRODUCT AS 
WITH PRODUCT_PROFIT AS (
    SELECT 
        PRODUCT_ID, 
        PRODUCT_NAME, 
        CAST(REPLACE(PRODUCT_PRICE, '$', '') AS DECIMAL(10, 2)) - CAST(REPLACE(PRODUCT_COST, '$', '') AS DECIMAL(10, 2)) AS PROFIT
    FROM PRODUCTS
),
YEARLY_PROFIT AS (
    SELECT 
        PP.PRODUCT_NAME, 
        YEAR(S.DATE) AS YEAR, 
        SUM(PP.PROFIT * S.UNITS) AS TOTAL_PROFIT
    FROM 
        PRODUCT_PROFIT PP
    JOIN 
        SALES S ON PP.PRODUCT_ID = S.PRODUCT_ID
    GROUP BY 
        PP.PRODUCT_NAME, 
        YEAR(S.DATE)
),
RANKED_PROFIT AS (
    SELECT 
        YEAR, 
        PRODUCT_NAME, 
        TOTAL_PROFIT, 
        RANK() OVER (PARTITION BY YEAR ORDER BY TOTAL_PROFIT DESC) AS RANKING
    FROM 
        YEARLY_PROFIT
)
SELECT 
    YEAR, 
    PRODUCT_NAME, 
    TOTAL_PROFIT
FROM 
    RANKED_PROFIT
WHERE 
    RANKING = 1;

SELECT * FROM PROFITABLEPRODUCT ORDER BY YEAR;

------------------HIGH DEMANDED PRODUCT IN EACH QUATER------------------------
CREATE VIEW QUATERLYTOPPRODUCT AS
WITH QUATERLYPRODUCT AS (
    SELECT 
        YEAR(s.date) AS sales_year,
        DATEPART(QUARTER, s.date) AS sales_quarter,
        P.PRODUCT_NAME,
        SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) AS total_sales,
        RANK() OVER (PARTITION BY YEAR(s.date), DATEPART(QUARTER, s.date) ORDER BY SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) DESC) AS sales_rank
    FROM 
        PRODUCTS P
    JOIN 
        SALES S ON s.product_id = p.product_id
    GROUP BY 
        YEAR(s.date),
        DATEPART(QUARTER, s.date),
        P.PRODUCT_NAME
)
SELECT 
    sales_year,
    sales_quarter,
    product_name,
    total_sales
FROM 
    QUATERLYPRODUCT 
WHERE 
    sales_rank = 1;

SELECT * FROM QUATERLYTOPPRODUCT ORDER BY 
    sales_year, 
    sales_quarter;

------------------HIGH DEMANDED PRODUCT IN EACH year------------------------
CREATE VIEW YEARLYTOPPRODUCT AS
WITH YEARLYPRODUCT AS (
    SELECT 
        YEAR(s.date) AS sales_year,
        P.PRODUCT_NAME,
        SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) AS total_sales,
        RANK() OVER (PARTITION BY YEAR(s.date) ORDER BY SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) DESC) AS sales_rank
    FROM 
        PRODUCTS P
    JOIN 
        SALES S ON s.product_id = p.product_id
    GROUP BY 
        YEAR(s.date),
        P.PRODUCT_NAME
)
SELECT 
    sales_year,
    product_name,
    total_sales
FROM 
    YEARLYPRODUCT
WHERE 
    sales_rank = 1;

SELECT * FROM YEARLYTOPPRODUCT ORDER BY sales_year;

----------------HIGH DEMANDED PRODUCT IN EACH LOCATION----------------------------
CREATE VIEW TOPLOCATIONPRODUCT AS
WITH RankedProducts AS (
    SELECT
        p.product_name,
        st.store_city,
        SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) AS total_sale,
        ROW_NUMBER() OVER (
            PARTITION BY st.store_city 
            ORDER BY SUM(CAST(REPLACE(p.product_price, '$', '') AS DECIMAL(10, 2)) * s.units) DESC
        ) AS rnk
    FROM 
        stores st
    JOIN 
        sales s ON st.store_id = s.store_id
    JOIN 
        products p ON s.product_id = p.product_id
    GROUP BY 
        p.product_name,
        st.store_city
)
SELECT
    product_name,
    store_city,
    total_sale
FROM 
    RankedProducts
WHERE 
    rnk = 1;

SELECT * FROM TOPLOCATIONPRODUCT ORDER BY store_city;

--------------AVG PRODUCTS IN STOCK PER STORE--------

CREATE VIEW PRODUCTINSTOCK AS
SELECT 
    ST.STORE_NAME, 
    P.PRODUCT_NAME, 
    SUM(I.STOCK_ON_HAND) AS AVG_INVENTORY
FROM 
    STORES ST
JOIN 
    INVENTORY I ON ST.STORE_ID = I.STORE_ID
JOIN 
    PRODUCTS P ON I.PRODUCT_ID = P.PRODUCT_ID
GROUP BY 
    ST.STORE_NAME, 
    P.PRODUCT_NAME;

SELECT * FROM PRODUCTINSTOCK ORDER BY STORE_NAME, PRODUCT_NAME;



--------------INVENTORY TURNOVER RATIO-------------
CREATE VIEW TURNOVERRATIO AS
WITH AVG_INVENTORY AS (
	SELECT ST. STORE_ID, ST.STORE_NAME, AVG(I.STOCK_ON_HAND) AS AVG_STOCK FROM STORES ST JOIN INVENTORY I ON ST.STORE_ID=I.STORE_ID
	GROUP BY ST. STORE_ID,ST.STORE_NAME),
COSTPERSTORE AS (
	SELECT S.STORE_ID, SUM(CAST(REPLACE(P.PRODUCT_COST, '$', '') AS DECIMAL(10,2))* S.UNITS) AS COGS FROM SALES S JOIN
	PRODUCTS P ON S.PRODUCT_ID=P.PRODUCT_ID GROUP BY STORE_ID)
SELECT A.STORE_NAME, A.AVG_STOCK, C.COGS, CAST(C.COGS/A.AVG_STOCK AS DECIMAL(10,2)) AS INVENTORY_TURNOVER_RATIO FROM AVG_INVENTORY A
LEFT JOIN COSTPERSTORE C ON A.STORE_ID=C.STORE_ID; 

SELECT * FROM TURNOVERRATIO ORDER BY INVENTORY_TURNOVER_RATIO;







































