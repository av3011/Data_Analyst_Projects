'''
This file is a huge file(4 gb) in size. so I will divide it in 10 multiple files 
so it will be easier and faster to upload it from s3 to snowflake instead of 
uploading whole huge file.
'''
import logging
import config
from logger_config import logger
from upload_to_s3 import upload_to_s3

#count lines
input_file = "yelp_academic_dataset_review.json"
files_count = 10
with open(input_file,"r", encoding="utf-8") as f:
    total_lines = sum(1 for line in f)

lines_per_file = total_lines // files_count
logger.info(f"Total lines in {input_file} are {total_lines} and after splitting each file will have {lines_per_file} lines.")

#split files
with open(input_file,"r", encoding="utf-8") as f:    
    for i in range(files_count):
        file_name = f"part_{i+1}.json"
        line_count = 0
        with open(file_name, "w", encoding="utf-8") as output:
            for j in range(lines_per_file):
                line = f.readline()
                if not line:
                    break
                output.write(line)
                line_count+=1
        logger.info(f"part_{i+1}.json has successfully written with {line_count} lines.")

#uploading data to s3
try :
    upload_to_s3(config.folder_path, config.bucket_name)

except Exception as e:
    logging.error(f"S3 upload failed: {str(e)}")