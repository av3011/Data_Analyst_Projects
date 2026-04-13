--creating raw SCHEMA
CREATE SCHEMA raw;

-- creating yelp_review raw table
CREATE OR REPLACE TABLE raw.yelp_reviews (review_text VARIANT);

-- copy data for yelp_review files from s3 to snowflake table
COPY INTO raw.yelp_reviews
FROM 's3://yelp-analysis-bucket/split_data/'
STORAGE_INTEGRATION = s3_int
FILE_FORMAT = (TYPE = JSON)
ON_ERROR = 'CONTINUE';

select * from raw.yelp_reviews;


-- creating yelp_businesses raw table
CREATE OR REPLACE TABLE raw.yelp_businesses (business_text VARIANT);

-- copy data for yelp_businesses file from s3 to snowflake table
COPY INTO raw.yelp_businesses
FROM 's3://yelp-analysis-bucket/business_data/'
STORAGE_INTEGRATION = s3_int
FILE_FORMAT = (TYPE = JSON)
ON_ERROR = 'CONTINUE';

select * from raw.yelp_businesses;
