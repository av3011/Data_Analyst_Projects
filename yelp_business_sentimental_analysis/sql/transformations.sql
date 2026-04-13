-- data is in json format so we need to convert it to table so that we can analyse
-- creating transformed SCHEMA
CREATE SCHEMA transformed;

-- creating yelp_reviews_tbl
create or replace table transformed.yelp_reviews_tbl as
select 
    review_text:business_id::string as business_id,
    review_text:user_id::string as user_id,
    review_text:date::date as review_date,
    review_text:stars::number as review_stars,
    review_text:text::string as review_text
from yelp_reviews;

select * from transformed.yelp_reviews_tbl limit 100;

-- creating yelp_reviews_tbl
create or replace table transformed.yelp_businesses_tbl as 
select  
    business_text:business_id::string as business_id,
    business_text:name::string as business_name,
    business_text:city::string as city,
    business_text:state::string as state,
    business_text:stars::number as business_stars,
    business_text:review_count::number as review_count,
    business_text:categories::string as categories
from yelp_businesses;

select * from transformed.yelp_businesses_tbl limit 100;  
