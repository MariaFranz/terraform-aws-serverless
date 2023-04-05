import json
import boto3
from datetime import datetime
import os


def lambda_handler(event, context):
    if event:
        for record in event["Records"]:
            print("Event received: " + record["body"])

    return {}


def lambda_trigger(event, context):  # required
   now = datetime.now()
   current_time = now.strftime("%H:%M:%S %p")

   sqs = boto3.client('sqs')  # client is required to interact with
   sqs.send_message(
       QueueUrl= os.environ["sqs_url"],
       MessageBody=current_time
   )

   return {
       'statusCode': 200,
       'body': json.dumps(current_time)
   }
