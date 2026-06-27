import json
import boto3

# Create an Athena client that can query the execution state of a previously submitted query.
athena = boto3.client('athena')

# This Lambda checks the current status of an Athena query execution.
def handler(event, context):
    # The Step Functions workflow passes the query execution ID to this Lambda.
    # The function supports both a direct dictionary payload and a wrapped body payload.
    qid = event.get('queryExecutionId') or (event.get('body') or {}).get('queryExecutionId')

    # If no query execution ID is available, return a validation error to the workflow.
    if not qid:
        return { 'statusCode': 400, 'body': { 'status': 'FAILED', 'reason': 'missing query id' } }

    # Ask Athena for the status of the specified query execution.
    resp = athena.get_query_execution(QueryExecutionId=qid)

    # Extract the latest execution state and any result location from the Athena response.
    status = resp['QueryExecution']['Status']['State']
    results_location = resp['QueryExecution']['ResultConfiguration'].get('OutputLocation')

    # Return the status and result location so the workflow can decide whether to proceed,
    # wait again, or fail.
    return { 'statusCode': 200, 'body': { 'status': status, 'resultLocation': results_location, 'queryExecutionId': qid } }
