---Analysis
--1. Find number of businesses in each category;
with separate_category as (
select 
    business_id,
    trim(c.value) as category
from    
    transformed.yelp_businesses_tbl,
    lateral split_to_table(categories, ',') c)
select 
    category,
    count(business_id) no_of_businesses
from    
    separate_category
group by    
    category
order by    
    no_of_businesses desc;

--2. Find the top 10 users who have reviewed the most businesses in the 'restaurants' category 
SELECT 
    r.user_id,
    count(distinct r.business_id) user_review_count  
from  
    transformed.yelp_reviews_tbl r 
join
    transformed.yelp_businesses_tbl b
on 
    r.business_id=b.business_id
where
    b.categories ilike '%Restaurants%'
group by 
    r.user_id
order by 
    user_review_count  desc
limit 10;

--3. Find the most popular categories of businesses (based on number of reviews)
with seperate_category as (
select 
    business_id,
    trim(c.value) as category
from    
    transformed.yelp_businesses_tbl,
    lateral split_to_table(categories, ',') c)
select  
    sc.category,
    sum(b.review_count) no_of_reviews
from    
    seperate_category sc 
join 
    transformed.yelp_businesses_tbl b
on  
    sc.business_id=b.business_id
group by    
    sc.category
order by
    no_of_reviews desc;

--4. Find the top 3 most recent reviews for each business
with recent_reviews as (
select 
    b.business_name,
    row_number() over(partition by b.business_name order by r.review_date desc) rnk,
    r.review_date,
    r.review_text
from    
    transformed.yelp_reviews_tbl r
join 
    transformed.yelp_businesses_tbl b
on  
    r.business_id=b.business_id
)
select  
    business_name,
    review_date,
    review_text
from   
    recent_reviews 
where
    rnk <= 3;

--5. Find the month with the highest number of reviews
select  
    month(review_date) month,
    count(*) no_of_reviews
from    
    transformed.yelp_reviews_tbl
group by    
    month(review_date)
order by
    no_of_reviews desc;

--6. Find the percentage of 5 stars review in each business
with fivestar_review_precentage as(
select 
    b.business_id,
    b.business_name,
    count(*) total_reviews,
    sum(case when r.review_stars = 5 then 1 else 0 end) five_stars_review
from    
    transformed.yelp_businesses_tbl b
join 
    transformed.yelp_reviews_tbl r
on 
    b.business_id=r.business_id
group by 
    b.business_id,
    b.business_name
)
select 
    business_id,
    business_name,
    five_stars_review*100.0/total_reviews
from    
    fivestar_review_precentage;


--7. Find the top 5 most reviewed business in each city
with  review_in_city as (
select 
    b.business_id,
    b.business_name,
    b.city,
    count(*) total_reviews,
    dense_rank() over(partition by b.city order by count(*) desc) as rnk
from    
    transformed.yelp_businesses_tbl b
join 
    transformed.yelp_reviews_tbl r
on 
    b.business_id=r.business_id
group by 
    b.business_id,
    b.business_name,
    b.city)
select 
    business_id,
    business_name,
    city,
    total_reviews
from 
    review_in_city
where
    rnk<=5;

--8. Find the average rating of businesses the have at least 100 reviews
select 
    b.business_id,
    b.business_name,
    count(*) total_reviews,
    avg(r.review_stars) avg_rating
from    
    transformed.yelp_businesses_tbl b
join 
    transformed.yelp_reviews_tbl r
on 
    b.business_id=r.business_id
group by 
    b.business_id,
    b.business_name
having 
    count(*) >= 100;

--9. List the top 10 users who have written the most reviews along with the businesses they reviewed
select 
    r.user_id,
    b.business_id,
    count(*) total_reviews,
from    
    transformed.yelp_businesses_tbl b
join 
    transformed.yelp_reviews_tbl r
on 
    b.business_id=r.business_id
group by
    r.user_id,
    b.business_id
order by 
    total_reviews desc
limit 10;


--10. Find top 10 business with highest review counts
select  
    business_name,
    sum(review_count) total_review_count
from    
    transformed.yelp_businesses_tbl
group by
    business_name
order by
    total_review_count desc
limit 10;