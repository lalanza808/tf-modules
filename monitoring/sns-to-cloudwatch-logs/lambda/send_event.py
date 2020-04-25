from os import environ
from datetime import datetime
import boto3
import time
import json


now = datetime.utcnow()
ts_now = round(now.timestamp())
log_stream = f'{now.year}-{now.month}-{now.day}'
log_group = environ['log_group']
cloudwatch_logs = boto3.client('logs')
current_milli_time = lambda: int(round(time.time() * 1000))


def put_log_event(client, group, stream, message, seq_token='', create_stream=False) -> bool:
    if create_stream:
        print(f'[+] Creating new log stream "{stream}"')
        client.create_log_stream(
            logGroupName=group,
            logStreamName=stream
        )

    print(f'[+] Putting log event to Cloudwatch Logs')
    response = client.put_log_events(
        logGroupName=group,
        logStreamName=stream,
        logEvents=[{
            'timestamp': current_milli_time(),
            'message': message
        }],
        sequenceToken=seq_token
    )

    return response


def get_log_streams(client, group) -> list:
    log_streams = client.describe_log_streams(
        logGroupName=group,
        orderBy='LastEventTime',
        descending=True
    )

    return log_streams


def handler(event, context) -> bool:
    try:
        message_source = event['Records'][0]['EventSource']
    except KeyError:
        return

    if message_source == 'aws:sns':
        log_streams = get_log_streams(cloudwatch_logs, log_group)
        log_content = json.dumps({
            "subject": event['Records'][0]['Sns']['Subject'],
            "message": event['Records'][0]['Sns']['Message']
        })

        if len(log_streams['logStreams']) > 0:
            ls_exists = False
            # If there are log streams, check to see if the current date's log stream exists
            for stream in log_streams['logStreams']:
                # If LS does exist, retrieve the seq token and put event to it
                if stream['logStreamName'] == log_stream:
                    ls_exists = True
                    if stream.get('uploadSequenceToken'):
                        seq_token = stream['uploadSequenceToken']
                        put_log_event(
                            cloudwatch_logs, log_group, log_stream,
                            log_content, seq_token, False
                        )
            # If log stream doesn't exist after looping through, create it and put event to it
            if ls_exists is False:
                put_log_event(
                    cloudwatch_logs, log_group, log_stream,
                    log_content, '', True
                )
        # If there are no log streams, create a new one and publish an event to it
        else:
            put_log_event(
                cloudwatch_logs, log_group, log_stream,
                log_content, '', True
            )
