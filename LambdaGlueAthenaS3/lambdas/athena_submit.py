import json
import boto3

athena = boto3.client('athena')

def handler(event, context):
    # Submit a query and return execution id and S3 location for results
    query = event.get('query','SELECT * FROM retail_processed LIMIT 10')
    resp = athena.start_query_execution(
        QueryString=query,
        ResultConfiguration={ 'OutputLocation': 's3://athena-query-results-bucket/' }
    )
    return { 'statusCode': 200, 'body': { 'queryExecutionId': resp['QueryExecutionId'] } }
