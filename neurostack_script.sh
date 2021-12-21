#!/bin/bash

set -e

aws sts get-caller-identity --query Account --output text > accountID.txt
accountID=$(cat accountID.txt)
aSub=$(echo ${FileName}| cut -d. -f1)

export PATH="/nitrc/usr/lib/afni/bin:$PATH"
export LD_LIBRARY_PATH="/nitrc/lib:/nitrc/usr/lib:/nitrc/usr/lib/afni/lib:/nitrc/usr/lib/x86_64-linux-gnu:/nitrc/lib/x86_64-linux-gnu/"

echo "Processing subject ${aSub}"
echo "Args: $@"
echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"

# --------------- Start user-modified script ---------------
cd ~

echo "Copying input data onto the instance"
aws s3 cp s3://neurostack-input-${accountID}/ ~ --recursive --exclude "*" --include "${aSub}.nii"

echo "Converting from nifti to afni"
3dcalc -a ${aSub}.nii -prefix ${aSub} -expr 'a'

echo "Copying output files from the instance to S3 storage"
aws s3 cp ~ s3://neurostack-output-${accountID}/ --recursive --exclude "*" --include "${aSub}*.BRIK"
aws s3 cp ~ s3://neurostack-output-${accountID}/ --recursive --exclude "*" --include "${aSub}*.HEAD"

