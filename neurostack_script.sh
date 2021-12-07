#!/bin/bash

set -e

aws sts get-caller-identity --query Account --output text > accountID.txt
accountID=$(cat accountID.txt)
aSub=$(echo ${FileName}| cut -d. -f1)

#export PATH="/nitrc/usr/local/freesurfer/bin:$PATH"
#echo "Showing custom.sh"
#cat /etc/profile.d/custom.sh
# echo "Showing nitrc_bashrc.sh"
# cat /etc/profile.d/nitrc_bashrc.sh
# echo "Showing nitrc_profile.sh"
# cat /etc/profile.d/nitrc_profile.sh
# echo "Path is: $PATH"
# echo "Sourcing bashrc and profile"
# source /etc/profile.d/nitrc_bashrc.sh
# source /etc/profile.d/nitrc_profile.sh
# echo "Path is: $PATH"

# echo "Processing subject ${aSub}"
# echo "Args: $@"
# echo "jobId: $AWS_BATCH_JOB_ID"
# echo "jobQueue: $AWS_BATCH_JQ_NAME"
# echo "computeEnvironment: $AWS_BATCH_CE_NAME"

# --------------- Start user-modified script ---------------
export PATH="/nitrc/usr/lib/afni/bin:$PATH"
export LD_LIBRARY_PATH="/nitrc/lib:/nitrc/usr/lib:/nitrc/usr/lib/afni/lib:/nitrc/usr/lib/x86_64-linux-gnu:/nitrc/lib/x86_64-linux-gnu/"

cd ~

echo "Copying input data onto the instance"
aws s3 cp s3://neurostack-input-${accountID}/ ~ --recursive --exclude "*" --include "${aSub}.nii"

echo "Starting afni proc py"
#Modified from example 11b
afni_proc.py                                                   \
	 -subj_id ${aSub}                                          \
	 -blocks despike tshift align tlrc volreg blur mask scale  \
		 regress                                               \
	 -copy_anat ${aSub}*anat*.nii.gz                           \
	 -dsets ${aSub}*rest*.nii.gz                               \
	 -tcat_remove_first_trs 2                                  \
	 -align_opts_aea -cost lpc+ZZ                              \
	 -tlrc_base /home/hm437/abin/TT_N27.nii                    \
	 -tlrc_NL_warp                                             \
	 -volreg_align_to MIN_OUTLIER                              \
	 -volreg_align_e2a                                         \
	 -volreg_tlrc_warp                                         \
	 -volreg_warp_dxyz 3                                       \
	 -blur_size 4                                              \
	 -mask_segment_anat yes                                    \
	 -mask_segment_erode yes                                   \
	 -mask_import Tvent template_ventricle_3mm+tlrc            \
	 -mask_intersect Svent CSFe Tvent                          \
	 -mask_epi_anat yes                                        \
	 -regress_motion_per_run                                   \
	 -regress_ROI_PC Svent 3                                   \
	 -regress_ROI_PC_per_run Svent                             \
	 -regress_make_corr_vols WMe Svent                         \
	 -regress_anaticor_fast                                    \
	 -regress_censor_motion 0.2                                \
	 -regress_censor_outliers 0.05                             \
	 -regress_apply_mot_types demean deriv                     \
	 -regress_est_blur_epits                                   \
	 -regress_est_blur_errts                                   \
	 -regress_run_clustsim yes                                 \
	 -bash -execute

echo "Copying output files from the instance to S3 storage"
aws s3 cp ~/${aSub}*.BRIK s3://neurostack-output-${accountID}/

