import boto3
import os
from logger_config import logger

s3_client = boto3.client('s3')

allowed_files = {"yelp_academic_dataset_business.json"}

def upload_to_s3(folder_path, bucket_name):
    for file_name in os.listdir(folder_path):

        full_path = os.path.join(folder_path, file_name)

        # case 1: split files
        if file_name.startswith("part_") and file_name.endswith(".json"):
            s3_key = f"split_data/{file_name}"

        # case 2: business file
        elif file_name == "yelp_academic_dataset_business.json":
            s3_key = f"business_data/{file_name}"

        else:
            continue  # ignore other files

        s3_client.upload_file(
            Filename=full_path,
            Bucket=bucket_name,
            Key=s3_key
        )

        logger.info(f"{file_name} uploaded to {s3_key}")