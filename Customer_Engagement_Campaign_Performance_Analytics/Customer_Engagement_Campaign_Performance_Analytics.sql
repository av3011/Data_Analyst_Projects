CREATE DATABASE MarketingAnalysis;

USE MarketingAnalysis;


-- create the schema of all the Entities (Tables)

-- Customers and Products

-- Fields - Productid, Pname, Category, Price

Create table Products
(Productid int primary key, Pname varchar(50), Category varchar(50), Price decimal(10,2))

-- Customers
-- fields- Cust_id, Cname, Email, Gender, Age, Locid

Create Table Customers
( Cust_id Int Primary key, Cname varchar(50), Email varchar(100), Gender varchar(40), Age int, locid int)

alter table customers
add constraint fk01 foreign key(locid) references countries(Countryid)

-- Countries
-- fields- Countryid, country, City

create table Countries
(Countryid int primary key, Country varchar(70), City varchar(70))


-- Customer_journey
-- fields- Journeyid, Cust_id, productid, Visit_date, stage, action, duration

create table Customer_journey
(journeyid int, cust_id int,productid int, visit_date date, stage varchar(60), Action varchar(50), duration int
, foreign key(cust_id)  references customers(cust_id),
 foreign key(productid) references products(productid))


-- Cust_rev
-- fields
create table Cust_review
(reviewid int, cust_id int,productid int, Review_date date, ratings int, review_text text
, foreign key(cust_id)  references customers(cust_id),
 foreign key(productid) references products(productid))

-- Engagementdata
--fields

create table Engag_data
(Engagementid int primary key,contentid int, contenttype varchar(100), likes int, 
engag_date date, campaignid int, productid int , View_s_clicks_Comb varchar(100),
foreign key(productid) references products(productid))


---------Bulk insert of data (csvs)-----------------------

bulk insert Products
from 'C:\Users\asifv\OneDrive\Desktop\DataScience\Data Analyst\Data Analyst Projects\Marketing_Analysis_Campaign\Products.csv'
with 
(fieldterminator=',', rowterminator='\n', firstrow=2) 

select * from Products;



----
bulk insert Customers
from 'C:\Users\asifv\OneDrive\Desktop\DataScience\Data Analyst\Data Analyst Projects\Marketing_Analysis_Campaign\Customers.csv'
with 
(fieldterminator=',', rowterminator='\n', firstrow=2) 

select * from Customers;


-----
bulk insert Countries
from 'C:\Users\asifv\OneDrive\Desktop\DataScience\Data Analyst\Data Analyst Projects\Marketing_Analysis_Campaign\Countries.csv'
with 
(fieldterminator=',', rowterminator='\n', firstrow=2) 

select * from Countries;

------------Error with date columns in below tables, need addtional steps for bulk insert-----
-----Engag_data (engag_date)
bulk insert Engag_data
from 'C:\Users\asifv\OneDrive\Desktop\DataScience\Data Analyst\Data Analyst Projects\Marketing_Analysis_Campaign\Engagement_data.csv'
with 
(fieldterminator=',', rowterminator='\n', firstrow=2) 

select * from Engag_data;

--------Cust_review (review_date)
bulk insert Cust_review
from 'C:\Users\asifv\OneDrive\Desktop\DataScience\Data Analyst\Data Analyst Projects\Marketing_Analysis_Campaign\Cust_review.csv'
with 
(fieldterminator=',', rowterminator='\n', firstrow=2) 

select * from Cust_review;

----customer_journey (duration,visit_date)
bulk insert customer_journey
from 'C:\Users\asifv\OneDrive\Desktop\DataScience\Data Analyst\Data Analyst Projects\Marketing_Analysis_Campaign\customer_journey.csv'
with 
(fieldterminator=',', rowterminator='\n', firstrow=2) 

select * from Customer_journey;


-----Got error for date columns in below three tables. So Changing date datatype as they might be in incorrect format-----

---Engagement_data
alter table Engag_data
alter column engag_date varchar(50);

---Cust_review
alter table Cust_review
alter column review_date varchar(50);

---Customer_journey
alter table Customer_journey
alter column duration varchar(50);

alter table Customer_journey
alter column visit_date varchar(50);


------applying some cleaning steps for date-----

select engag_date, TRY_CONVERT(date,engag_date,105) from Engag_data
where TRY_CONVERT(date,engag_date) is null; ----try to convert to date if it can otherwise set it to null. will try different date fromat to solve this issue


----convert it to other format
select engag_date, CONVERT(date,engag_date,105) from Engag_data;

----it is converting so will update engage_date column
update Engag_data set engag_date = CONVERT(date,engag_date,105) from Engag_data;

alter table engag_data
alter column engag_date date;

----will do the same with other date columns in different tables

select visit_date,convert(date,duration,105) from customer_journey;

update customer_journey set visit_date = CONVERT(date,visit_date,105) from customer_journey;

alter table customer_journey
alter column visit_date date;

-------------

select review_date,convert(date,review_date,105) from cust_review;

update cust_review set review_date = CONVERT(date, review_date,105) from cust_review;

alter table cust_review
alter column review_date date;


-------different approach for duration
select * from customer_journey where duration='null';


----there are some values as null not a data type
update customer_journey set duration=null
where duration='null';

alter table customer_journey
alter column duration int;



----------------------column distribution--------------------------


----dublicate values

-----distinct count
select distinct COUNT(*) from Products; --20
select distinct COUNT(*) from Countries; --10
select distinct COUNT(*) from Customers; --100
select distinct COUNT(*) from Customer_journey; --4011
select distinct COUNT(*) from Cust_review; --1363
select distinct COUNT(*) from Engag_data; --4623

-----Count
select COUNT(*) from Products; --20
select COUNT(*) from Countries; --10
select COUNT(*) from Customers; --100
select COUNT(*) from Customer_journey; --4011
select COUNT(*) from Cust_review; --1363
select COUNT(*) from Engag_data; --4623

--no dublicate values found



---Analysis---

---customer journey tracking
select * from Products;
select * from Countries; 
select * from Customers; 
select * from Customer_journey; 
select * from Cust_review; 
select * from Engag_data;


---How customers are distributed into stages

--stages
select distinct stage from Customer_journey;

/*Checkout
ProductPage
Homepage*/

--1. how many customers are divided in each stage

select stage, count(cust_id) no_of_cust from Customer_journey
group by stage order by no_of_cust desc;

/*
stage	no_of_cust
Homepage	1777
ProductPage	1444
Checkout	790 */

--2.based on action
select distinct action from Customer_journey;

/*
action
View
Drop-off
Click
Purchase */

select stage, action, count(cust_id) as 'no_of_cust' from Customer_journey
group by stage, action
order by no_of_cust desc;

select stage, action, count(cust_id) as 'no_of_cust' from Customer_journey
where action='purchase'
group by stage, action
order by no_of_cust desc;

select stage, action, count(cust_id) as 'no_of_cust' from Customer_journey
where action='drop-off'
group by stage, action
order by no_of_cust desc;

SELECT
    COUNT(CASE WHEN stage = 'checkout' AND action = 'purchase' THEN 1 END) * 100.0 / COUNT(cust_id) AS purchase_percentage
FROM Customer_journey;


-----checking with visit date
select distinct(year(visit_date)) as year_data from Customer_journey;

select distinct(month(visit_date)) from Customer_journey 
where YEAR(visit_date)= 2025; --there are all the months in the data but 2025 is still half way, so we need to change years

----changing year with preceding years-------
update Customer_journey set visit_date= DATEADD(year,-1,visit_date) where year(visit_date) in (2025,2024,2023);


---on which campaign customers purchase most-----
select top 3 e.campaignid,count(*) as no_of_purchase from Engag_data e join Customer_journey cj on e.productid=cj.productid
where cj.Action = 'purchase'
group by e.campaignid order by no_of_purchase desc;

---on which campaign customers drop-off most-----
select top 3 e.campaignid,count(*) as no_of_dropoff from Engag_data e join Customer_journey cj on e.productid=cj.productid
where cj.Action = 'drop-off'
group by e.campaignid order by no_of_dropoff desc;


---three campaign from all the years on the basis of purchase

select top 3 e.campaignid,count(*) as no_of_purchase, year(e.engag_date) as 'year' from Engag_data e join Customer_journey cj on e.productid=cj.productid
where cj.Action = 'purchase'
group by e.campaignid, YEAR(e.engag_date) order by no_of_purchase desc;

 ---top campaign on the basis of purchase in each year 
with top_campaign as (
select e.campaignid,count(*) as no_of_purchase, year(e.engag_date) as 'year', 
DENSE_RANK() over(partition by year(e.engag_date) order by count(*) desc) as rnk 
from Engag_data e join Customer_journey cj on e.productid=cj.productid
where cj.Action = 'purchase'
group by e.campaignid, YEAR(engag_date))
select * from top_campaign where rnk in (1,2,3);




----------------Engagement Analysis-------------------
select * from Engag_data;
select * from Customer_journey;

----CTR - Click Through Rate - Click/View * 100 but we won't get directly as there some anamoly(usnusual data - some values are non numeric------

-----changing clms from non numric to numeric----
-----Create Clicks and views separate clms-----
alter table engag_data
alter column view_s int;

alter table engag_data
alter column clicks varchar(40); ----bcz some values are non-numeric----


---adding data to clicks clm-----here we can use substring/right-----charindex/patindex----------
----example: patindex[%A-%] when we have multiple patterns in our clm and charindex when we have only one pattern--------

--select SUBSTRING(view_s_clicks_comb,0,CHARINDEX('-', view_s_clicks_comb)) from Engag_data--------
update Engag_data set clicks = right(view_s_clicks_comb, len(view_s_clicks_comb) - (CHARINDEX('-', view_s_clicks_comb)));


---adding data to view_s clm-----
-----select SUBSTRING(view_s_clicks_comb,CHARINDEX('-', view_s_clicks_comb)+1,LEN(view_s_clicks_comb)) from Engag_data-------
---left(view_s_clicks_comb,(patindex[%[-]%, view_s_clicks_comb)-1)
update Engag_data set view_s = left(view_s_clicks_comb, (CHARINDEX('-', view_s_clicks_comb))-1);



-----checking how many non numeric values are there----------
---to see non numeric values:: select view_s_clicks_comb from Engag_data where clicks like '%[a-z]%';----

select * from Engag_data where ISNUMERIC(view_s)=0; --all values are numeric
select * from Engag_data where ISNUMERIC(clicks)=0; --some values are non-numeric

-----cosidering jan and feb as 01 and 02
update Engag_data set clicks = case when clicks='jan' then '01' 
									when clicks='feb' then '02'
									else clicks end

alter table engag_data
alter column clicks int;


-----Engagement Analysis: now all values are numeric. so we can perform CTR and other calculations---------
select e.campaignid,SUM(clicks) as 'total_clicks', SUM(view_s) as 'total_views',
count(case when c.action='purchase' then 1 end) as 'total_purchases',
SUM(clicks)*100.0/sum(view_s) as 'Click_through_rate',
count(case when c.action='purchase' then 1 end)*100.0/count(view_s) as 'Conversion_rate'
from Engag_data e
join Customer_journey c
on e.productid=c.productid
group by e.campaignid
order by Click_through_rate desc;

---------most liked content
select contenttype, count(likes) 'likes_cnt', count(view_s) 'views_cnt', count(clicks) 'clicks_cnt' from Engag_data
group by contenttype
order by likes_cnt desc

select * from Cust_review;
select * from Engag_data;

------total interaction: likes+cliks/views 
------CAST((total_likes + total_clicks)*1.0/ total_views*100 as decimal(10,2)) - here multiply by 1.0 as it was giving reuslt in integer and division was 
------perfomed before multiplication and that's why it was giving 0.00 intead of 0.24
with totalinteraction as (
select productid, SUM(likes) as 'total_likes', SUM(clicks) as 'total_clicks', SUM(view_s) as 'total_views'
from Engag_data
group by productid)
select *, CAST((total_likes + total_clicks)*1.0/ total_views*100 as decimal(10,2)) as interaction_rate from totalinteraction
order by interaction_rate desc;



------------cust review analysis---------------
select * from Cust_review;
select * from Products;
select ratings,count(ratings) as 'num_of_ratings' from Cust_review group by ratings order by ratings desc;


-----creating sentiments: below 3 - negative, 3 - neutral, above 3 - positive
alter table cust_review
add Sentiments varchar(50);


update Cust_review set Sentiments = case when ratings < 3 then 'Negative'
					 when ratings = 3 then 'Neutral'
					 else 'Positive' 
					 end 

------based on products how many positive, negative, neutral we got
select p.pname, count(case when cr.sentiments='Positive' then 1 end) as 'Pos_counts',
			   count(case when cr.sentiments='Negative' then 1 end) as 'Neg_counts',
			   count(case when cr.sentiments='Neutral' then 1 end) as 'Neutral_counts'
from Cust_review cr join Products p on cr.productid=p.Productid
group by p.pname
order by Pos_counts desc;


-----demographic analysis

select p.productid, p.pname, ct.country, count(case when cj.action='purchase' then 1 end) as 'purchase_cnt',
avg(cr.ratings) as 'avg_ratings'
from Products p join Cust_review cr on p.Productid=cr.productid
join Customer_journey cj on
p.Productid=cj.productid
join Customers c on
cr.cust_id = c.Cust_id
join Countries ct
on c.locid = ct.Countryid
group by p.Productid, p.Pname, ct.Country
order by purchase_cnt desc;



-----------customer lifetime value
select c.Cname, sum(p.price) as CLV from Customers c join Customer_journey cj on c.Cust_id=cj.cust_id 
join Products p on cj.productid=p.Productid
group by c.Cname, cj.Action
having cj.Action='Purchase';







