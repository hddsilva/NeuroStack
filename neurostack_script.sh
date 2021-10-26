#!/bin/bash

set -e

export PATH="/nitrc/freesurfer/bin/:$PATH"
export HOME="/nitrc/freesurfer"
echo "$PATH"
echo "$HOME"
aws sts get-caller-identity --query Account --output text > accountID.txt
accountID=$(cat accountID.txt)
aSub=$(echo ${FileName}| cut -d. -f1)

echo "Processing subject ${aSub}"
echo "Args: $@"
echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"

# --------------- Start user-modified script ---------------
mkdir ~/fs_input
export FREESURFER_HOME=~/fs_input

echo "Copying input data onto the instance"
aws s3 cp s3://neurostack-input-${accountID}/ ~/fs_input/ --recursive --exclude "*" --include "${aSub}.nii"

echo "Starting recon-all"
recon-all -subjid ${aSub} -i ~/fs_input/${aSub}.nii -all

echo "Copying output files from the instance to S3 storage"
aws s3 cp ~/fs_input/ s3://neurostack-output-${accountID}/ --recursive

# --------------- End user-modified script ----------------

echo "Hard drive utilization"
df -h

date

