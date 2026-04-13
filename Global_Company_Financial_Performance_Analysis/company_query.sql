CREATE DATABASE company;

use company; 

-- Create a table
CREATE TABLE company_details (
    Company NVARCHAR(255),
    Ticker NVARCHAR(50),
    Country NVARCHAR(100),
    Sector NVARCHAR(100),
    Revenue_billion FLOAT,
    MarketCap_billion FLOAT,
    ProfitMargin FLOAT,
    ROE FLOAT
);


select * from company_details;

/*TOP 10 companies with different metrics*/

/*Top 10 in revenue*/
select top 10 company, revenue_billion from company_details order by Revenue_billion desc;


/*Top 10 in market_value*/
select top 10 company, marketcap_billion from company_details order by marketcap_billion desc;


/*Top 10 in profitmargin*/
select top 10 company, round(ProfitMargin*100,2) as profitmargin from company_details order by profitmargin desc;


/*Top 10 in roe*/
select top 10 company, round(roe*100,2) as roe from company_details order by roe desc;

/* top compnies with highest marketcap in each sector:
Reliance in energy sector has the highest market cap. most of the compnies are from India*/

with top_markcap as (
select company, sector, country, marketcap_billion, DENSE_RANK() over(partition by sector order by MarketCap_billion desc) rnk from company_details)
select company, sector, country, marketcap_billion from top_markcap where rnk=1
order by MarketCap_billion desc; 

/* top compnies with highest roe sector wise: Apple has the highest roe*/

with top_roe as (
select company, sector, country, roe, DENSE_RANK() over(partition by sector order by roe desc) rnk from company_details)
select company, sector, country, round(roe,2) roe from top_roe where rnk=1
order by roe desc; 

/* Avg ROE based on sector: technology has the highest avg roe(47%) and engerge being the lowest(7%)*/
select sector, round(avg(roe),2) as avg_roe from company_details
group by sector
order by avg_roe desc;

/* top compnies with highest profit_margin sector wise: visa has the highest profit_margin*/

with top_profit as (
select company, sector, country, ProfitMargin, DENSE_RANK() over(partition by sector order by profitmargin desc) rnk from company_details)
select company, sector, country, round(ProfitMargin,2) ProfitMargin from top_profit where rnk=1
order by ProfitMargin desc; 

/* highest revenue sector wise*/
with top_revenue as (
select company, sector, country, revenue_billion, DENSE_RANK() over(partition by sector order by revenue_billion desc) rnk from company_details)
select company, sector, country, revenue_billion from top_revenue where rnk=1
order by revenue_billion desc; 

/*highest profitmargin sector is finance services*/
SELECT Sector,
       round(AVG(ProfitMargin)*100.0,2) AS AvgProfitMargin,
       COUNT(*) AS CompanyCount
FROM company_details
GROUP BY Sector
ORDER BY AvgProfitMargin DESC;









