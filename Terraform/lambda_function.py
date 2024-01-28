import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('cloudresumechallenge-viewcounter')

def lambda_handler(event, context):
    # Retrieve and update the views count
    response = table.get_item(Key={'ID': '1'})
    views = response['Item']['views'] + 1
    
    table.update_item(
        Key={'ID': '1'},
        UpdateExpression='SET #v = :val',
        ExpressionAttributeNames={'#v': 'views'},
        ExpressionAttributeValues={':val': views}
    )

    # Set up CORS headers
    headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': 'https://kevscloud.com',
        'Access-Control-Allow-Origin': 'https://www.kevscloud.com'
    }

    # Return HTTP response
    return {
        'statusCode': 200,
        'headers': headers,
        'body': json.dumps({'views': views})
    }
