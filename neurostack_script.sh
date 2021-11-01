#!/bin/bash

set -e

aws sts get-caller-identity --query Account --output text > accountID.txt
accountID=$(cat accountID.txt)
aSub=$(echo ${FileName}| cut -d. -f1)

export PATH="/nitrc/usr/local/freesurfer/bin:$PATH"
echo "$PATH"

echo "Processing subject ${aSub}"
echo "Args: $@"
echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"

# --------------- Start user-modified script ---------------

echo "Checking FREESURFER_HOME"
cd $FREESURFER_HOME

echo "Copying input data onto the instance"
aws s3 cp s3://neurostack-input-${accountID}/ $FREESURFER_HOME/ --recursive --exclude "*" --include "${aSub}.nii"

echo "Starting recon-all"
recon-all -subjid ${aSub} -i $FREESURFER_HOME/${aSub}.nii -all

echo "Listing output"
ls -l $FREESURFER_HOME >> output.txt

echo "Copying output files from the instance to S3 storage"
aws s3 cp $FREESURFER_HOME/output.txt s3://neurostack-output-${accountID}/
aws s3 cp $FREESURFER_HOME/ s3://neurostack-output-${accountID}/ --recursive --exclude "*" --include "*${aSub}*"

