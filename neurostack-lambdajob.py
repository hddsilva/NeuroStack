import boto3

def lambda_handler(event, context):
    client = boto3.client('batch', 'us-east-1')

    basic_job = client.submit_job(
		jobName='neurostack-job',
		jobQueue='neurostack-jobqueue',
		jobDefinition='neurostack-jobdefinition'
		)