import json
import boto3

s3 = boto3.client('s3')

def handler(event, context):
    # Expected event: { "s3": { "bucket": "...", "object": { "key": "...", "size": 123 }, ... }, "processingType": "full" }
    try:
        inp = event if isinstance(event, dict) else json.loads(event['body'])
    except Exception:
        inp = event

    result = { 'valid': False, 'details': [] }

    s3info = inp.get('s3')
    if not s3info:
        result['details'].append('Missing s3 information')
        return { 'statusCode': 400, 'body': result }

    bucket = s3info.get('bucket')
    key = s3info.get('object', {}).get('key')
    if not bucket or not key:
        result['details'].append('Missing bucket or key')
        return { 'statusCode': 400, 'body': result }

    # Simple existence check
    try:
        head = s3.head_object(Bucket=bucket, Key=key)
    except Exception as e:
        result['details'].append(f'S3 object not found: {e}')
        return { 'statusCode': 404, 'body': result }

    # Basic validations
    if not key.lower().endswith('.csv'):
        result['details'].append('Invalid file extension, expected .csv')

    size = head.get('ContentLength', 0)
    if size == 0:
        result['details'].append('Empty file')

    # Extract business info from key naming convention assuming storeid_date.csv
    try:
        filename = key.split('/')[-1]
        storeid, datepart = filename.replace('.csv','').split('_')
        result['store_id'] = storeid
        result['transaction_date'] = datepart
    except Exception:
        result['details'].append('Filename doesn't match storeid_YYYYMMDD.csv')

    if len(result['details']) == 0:
        result['valid'] = True

    return { 'statusCode': 200, 'body': result }
