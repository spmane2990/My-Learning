import json
import boto3
import urllib.parse

# Create an S3 client for archive operations.
# This Lambda is run as part of the workflow after validation, and its responsibility is
# to preserve the original input object in an archive location for audit and replay purposes.
s3 = boto3.client('s3')

# The Lambda entry point receives the workflow event and performs the archival step.
def handler(event, context):
    # If the event is already a dictionary, use it directly.
    # Otherwise, treat the input as a wrapped event body and parse it as JSON.
    inp = event if isinstance(event, dict) else json.loads(event.get('body','{}'))

    # Extract the S3 details from the workflow payload.
    s3info = inp.get('s3')
    bucket = s3info.get('bucket')
    key = s3info.get('object',{}).get('key')

    # The archive path is built under the same bucket using a standard archive prefix.
    archive_bucket = bucket
    archive_key = f"archive/{key}"

    try:
        # Copy the source object to the archive key.
        # This preserves the original input without removing it from the original location.
        s3.copy_object(Bucket=archive_bucket, CopySource={'Bucket': bucket, 'Key': key}, Key=archive_key)

        # Return a success payload with the archive location so that the workflow can continue.
        return { 'statusCode': 200, 'body': { 'archived': True, 'archiveLocation': f's3://{archive_bucket}/{archive_key}' } }
    except Exception as e:
        # If the copy operation fails, return an error response so the workflow can handle it.
        return { 'statusCode': 500, 'body': { 'archived': False, 'error': str(e) } }
