import json
import boto3

athena = boto3.client('athena')


def handler(event, context):
    # event expected to include queryExecutionId
    qid = event.get('queryExecutionId') or (event.get('body') or {}).get('queryExecutionId')
    if not qid:
        return { 'statusCode': 400, 'body': { 'status': 'FAILED', 'reason': 'missing query id' } }
    resp = athena.get_query_execution(QueryExecutionId=qid)
    status = resp['QueryExecution']['Status']['State']
    results_location = resp['QueryExecution']['ResultConfiguration'].get('OutputLocation')
    return { 'statusCode': 200, 'body': { 'status': status, 'resultLocation': results_location, 'queryExecutionId': qid } }
