#!/bin/bash

set -e

PATH="/usr/lib/afni/bin/:$PATH"
echo "$PATH"
aws sts get-caller-identity --query Account --output text > accountID.txt
accountID=$(cat accountID.txt)
aSub=$(echo ${FileName}| cut -d. -f1)

echo "Processing subject ${aSub}"
echo "Args: $@"
echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"

# --------------- Start user-modified script ---------------

echo "Copying input data onto the instance"
aws s3 cp s3://neurostack-input-${accountID}/ /usr/lib/afni/bin/ --recursive --exclude "*" --include "${aSub}.nii"

cd /usr/lib/afni/bin/
3dcalc -a ${aSub}.nii -prefix ${aSub} -expr 'a'

echo "Copying output files from the instance to S3 storage"
aws s3 cp /usr/lib/afni/bin/${aSub}.HEAD s3://neurostack-output-${accountID}/
aws s3 cp /usr/lib/afni/bin/${aSub}.BRIK s3://neurostack-output-${accountID}/

# --------------- End user-modified script ----------------

echo "Hard drive utilization"
df -h

date

