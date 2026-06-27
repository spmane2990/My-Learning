import json

def handler(event, context):
    fmt = event.get('format','json')
    # Generate a report in the requested format and store in S3 (stub)
    return { 'statusCode': 200, 'body': { 'format': fmt, 'location': f's3://report-bucket/report.{fmt}' } }
