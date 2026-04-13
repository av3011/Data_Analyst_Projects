CREATE OR REPLACE STORAGE INTEGRATION S3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::379220350785:role/snowflake_s3_role'
STORAGE_ALLOWED_LOCATIONS = ('s3://yelp-analysis-bucket/split_data/',
 's3://yelp-analysis-bucket/business_data/');

DESC INTEGRATION s3_int;

-- update storage integration with actual aws role arn
ALTER STORAGE INTEGRATION s3_int
SET STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::379220350785:role/yelp_snowflake_s3_role';