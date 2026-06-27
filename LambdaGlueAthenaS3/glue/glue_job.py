from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import sys

args = getResolvedOptions(sys.argv, ['JOB_NAME','--input_s3','--output_s3','--partition_key'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

input_path = args.get('--input_s3')
output_path = args.get('--output_s3')
partition_key = args.get('--partition_key','transaction_date')

# Read CSVs
df = spark.read.option('header', 'true').csv(input_path)

# Basic cleaning and dedupe example
df = df.dropDuplicates()

# Standardize formats - example: cast amounts
from pyspark.sql.functions import col

# Convert to Parquet and partition
(df
 .write
 .mode('overwrite')
 .partitionBy(partition_key)
 .parquet(output_path)
)

job.commit()
