import json
import boto3

# Create an S3 client that allows the validator to inspect the uploaded object directly.
s3 = boto3.client('s3')

# This Lambda validates the incoming file before the workflow continues to downstream processing.
def handler(event, context):
    # The Step Functions workflow passes an event that typically includes S3 metadata and processing context.
    # The function supports both a direct event object and a wrapped JSON body.
    try:
        inp = event if isinstance(event, dict) else json.loads(event['body'])
    except Exception:
        inp = event

    # Initialize a result object that collects validation success or detailed failure reasons.
    result = { 'valid': False, 'details': [] }

    # Extract the S3 information from the event payload.
    s3info = inp.get('s3')
    if not s3info:
        result['details'].append('Missing s3 information')
        return { 'statusCode': 400, 'body': result }

    bucket = s3info.get('bucket')
    key = s3info.get('object', {}).get('key')
    if not bucket or not key:
        result['details'].append('Missing bucket or key')
        return { 'statusCode': 400, 'body': result }

    # Check that the object exists in S3 before any further processing is attempted.
    try:
        head = s3.head_object(Bucket=bucket, Key=key)
    except Exception as e:
        result['details'].append(f'S3 object not found: {e}')
        return { 'statusCode': 404, 'body': result }

    # Apply simple file-format checks.
    if not key.lower().endswith('.csv'):
        result['details'].append('Invalid file extension, expected .csv')

    size = head.get('ContentLength', 0)
    if size == 0:
        result['details'].append('Empty file')

    # Try to extract business-relevant information from the object key using a simple naming convention.
    # The expected pattern is storeid_YYYYMMDD.csv.
    try:
        filename = key.split('/')[-1]
        storeid, datepart = filename.replace('.csv','').split('_')
        result['store_id'] = storeid
        result['transaction_date'] = datepart
    except Exception:
        result['details'].append('Filename doesn\'t match storeid_YYYYMMDD.csv')

    # If no validation issues were collected, mark the file as valid.
    if len(result['details']) == 0:
        result['valid'] = True

    return { 'statusCode': 200, 'body': result }
