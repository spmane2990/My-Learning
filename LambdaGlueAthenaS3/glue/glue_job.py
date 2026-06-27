from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import sys

# This Glue script is invoked by the Step Functions workflow as the ETL stage.
# It receives runtime arguments from the orchestration layer and runs the transformation
# using Spark inside the AWS Glue runtime environment.
args = getResolvedOptions(sys.argv, ['JOB_NAME','--input_s3','--output_s3','--partition_key'])

# Create the Spark and Glue runtime objects required for reading and writing data.
# SparkContext provides the distributed execution engine, while GlueContext gives access
# to Glue-specific capabilities and the Spark session used for DataFrame operations.
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Read the values passed from Step Functions.
# input_path points to the source S3 location, output_path is where the transformed data
# should be written, and partition_key defines how the data should be organized for analytics.
input_path = args.get('--input_s3')
output_path = args.get('--output_s3')
partition_key = args.get('--partition_key','transaction_date')

# Read the incoming CSV files from the input S3 path.
# The header option tells Spark that the first row contains column names.
df = spark.read.option('header', 'true').csv(input_path)

# Remove duplicate rows as a basic cleaning step.
# This prevents repeated records from flowing into the downstream analytics layer.
df = df.dropDuplicates()

# Import the column function for any future column-level transformations.
# In this sample it is included to show that additional standardization logic can be added here.
from pyspark.sql.functions import col

# Write the cleaned data to Parquet format.
# The output is partitioned by the chosen column so downstream Athena queries can be more efficient.
(df
 .write
 .mode('overwrite')
 .partitionBy(partition_key)
 .parquet(output_path)
)

# Mark the Glue job execution as successful once the transformation completes.
job.commit()
