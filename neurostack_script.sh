#!/bin/bash

set -e

aws sts get-caller-identity --query Account --output text > accountID.txt
accountID=$(cat accountID.txt)
aSub=$(echo ${FileName}| cut -d. -f1)

# TO DO: Need to list out contents of nitrc_bashrc.sh in profile.d to make sure it's there
# Also make sure environment variables from bashrc are set

#export PATH="/nitrc/usr/local/freesurfer/bin:$PATH"
echo "Showing custom.sh"
cat /etc/profile.d/custom.sh
#source /nitrc/home/ubuntu/.profile
echo "$PATH"

echo "Processing subject ${aSub}"
echo "Args: $@"
echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"

# --------------- Start user-modified script ---------------

echo "Checking FREESURFER_HOME: $FREESURFER_HOME"
#export FREESURFER_HOME=/nitrc/usr/local/freesurfer
#echo "Checking FREESURFER_HOME: $FREESURFER_HOME"
#source $FREESURFER_HOME/SetUpFreeSurfer.sh

echo "Copying input data onto the instance"
aws s3 cp s3://neurostack-input-${accountID}/ $FREESURFER_HOME/ --recursive --exclude "*" --include "${aSub}.nii"

echo "Starting recon-all"
recon-all -subjid ${aSub} -i $FREESURFER_HOME/${aSub}.nii -all

echo "Listing output"
ls -l $FREESURFER_HOME >> output.txt

echo "Copying output files from the instance to S3 storage"
aws s3 cp $FREESURFER_HOME/output.txt s3://neurostack-output-${accountID}/
aws s3 cp $FREESURFER_HOME/ s3://neurostack-output-${accountID}/ --recursive --exclude "*" --include "*${aSub}*"

