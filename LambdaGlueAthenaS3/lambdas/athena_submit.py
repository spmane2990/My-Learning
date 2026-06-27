import json
import boto3

# Create an Athena client used to submit analytical SQL queries against the processed data.
athena = boto3.client('athena')

# This Lambda starts an Athena query execution and returns the execution ID to the workflow.
def handler(event, context):
    # Use the provided query if present; otherwise fall back to a simple example query.
    # In a real implementation, this can be built dynamically from the workflow input or business context.
    query = event.get('query','SELECT * FROM retail_processed LIMIT 10')

    # Submit the query to Athena and request that results be written to a designated S3 location.
    resp = athena.start_query_execution(
        QueryString=query,
        ResultConfiguration={ 'OutputLocation': 's3://athena-query-results-bucket/' }
    )

    # Return the query execution ID so the workflow can poll for completion later.
    return { 'statusCode': 200, 'body': { 'queryExecutionId': resp['QueryExecutionId'] } }
