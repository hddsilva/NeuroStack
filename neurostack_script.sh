#!/bin/bash

set -e

aws sts get-caller-identity --query Account --output text > accountID.txt
accountID=$(cat accountID.txt)
aSub=$(echo ${FileName}| cut -d. -f1)

export PATH="/nitrc/usr/local/freesurfer/bin:$PATH"
echo "$PATH"
#source /nitrc/home/ubuntu/.bashrc

echo "Processing subject ${aSub}"
echo "Args: $@"
echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"

# --------------- Start user-modified script ---------------

echo "********************** Original bashrc **********************"
cat /nitrc/home/ubuntu/.bashrc

echo "********************** New bashrc **********************"
cat /nitrc/home/bashrc

echo "********************** Moving bashrc **********************"
rm /nitrc/home/ubuntu/.bashrc
mv /nitrc/home/bashrc /nitrc/home/ubuntu/.bashrc

echo "********************** Final bashrc **********************"
cat /nitrc/home/ubuntu/.bashrc

# echo "Checking FREESURFER_HOME: $FREESURFER_HOME"
# export FREESURFER_HOME=/nitrc/usr/local/freesurfer
# echo "Checking FREESURFER_HOME: $FREESURFER_HOME"
# source $FREESURFER_HOME/SetUpFreeSurfer.sh
# 
# echo "Copying input data onto the instance"
# aws s3 cp s3://neurostack-input-${accountID}/ $FREESURFER_HOME/ --recursive --exclude "*" --include "${aSub}.nii"
# 
# echo "Starting recon-all"
# recon-all -subjid ${aSub} -i $FREESURFER_HOME/${aSub}.nii -all
# 
# echo "Listing output"
# ls -l $FREESURFER_HOME >> output.txt
# 
# echo "Copying output files from the instance to S3 storage"
# aws s3 cp $FREESURFER_HOME/output.txt s3://neurostack-output-${accountID}/
# aws s3 cp $FREESURFER_HOME/ s3://neurostack-output-${accountID}/ --recursive --exclude "*" --include "*${aSub}*"

