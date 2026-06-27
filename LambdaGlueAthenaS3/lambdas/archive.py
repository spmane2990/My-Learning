import json
import boto3
import urllib.parse

s3 = boto3.client('s3')

def handler(event, context):
    inp = event if isinstance(event, dict) else json.loads(event.get('body','{}'))
    s3info = inp.get('s3')
    bucket = s3info.get('bucket')
    key = s3info.get('object',{}).get('key')
    archive_bucket = bucket
    archive_key = f"archive/{key}"
    try:
        s3.copy_object(Bucket=archive_bucket, CopySource={'Bucket': bucket, 'Key': key}, Key=archive_key)
        return { 'statusCode': 200, 'body': { 'archived': True, 'archiveLocation': f's3://{archive_bucket}/{archive_key}' } }
    except Exception as e:
        return { 'statusCode': 500, 'body': { 'archived': False, 'error': str(e) } }
