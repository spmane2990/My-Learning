import json

def handler(event, context):
    # event is a single record from Athena results. Calculate metrics here.
    record = event
    # Example: sum values and return a metric
    return { 'statusCode': 200, 'body': { 'processed': True, 'metrics': { 'total_sales': 0 } } }
