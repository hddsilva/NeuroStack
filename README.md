<p align="center">
  <img src="https://github.com/hddsilva/NeuroStack/blob/main/logo_NeuroStack.png" width="200" height="170" />
</p>

NeuroStack allows you to easily run neuroimaging workflows using AWS cloud computing. It is designed to set up the AWS infrastructure needed to perform neuroimaging analysis at scale. NeuroStack is built with the NITRC Compute Environment (NITRC-CE), which allows users to access all of the neuroimaging software pre-installed in NITRC-CE (see https://www.nitrc.org/projects/nitrc es/ for a complete list).

To use NeuroStack, first install NeuroStack in your AWS account. Modify the template script according to your needs and upload it to the neurostack-script S3 bucket. Add your input data to the neurostack-input S3 bucket. When your job has finished, your processed data will be automatically uploaded to the neurostack-output S3 bucket.

Although NeuroStack itself is free to install and use, the AWS resources (ie, storage and compute) that NeuroStack calls upon is charged by AWS. Users are responsible for the AWS charges they incur.

## To Install NeuroStack in your AWS account

1. Log into your AWS account
2. Click the "Launch_NeuroStack" url under your preferred release from the NeuroStack webpage on the NITRC website https://www.nitrc.org/frs/?group_id=1548. This will bring you to the stack creation page on AWS.
3. All specifications for NeuroStack are preset, so you do not need to modify them. Simply continue choosing "Next".
4. On the last page, check the box to accept that IAM permissions will be created before creating the stack. NeuroStack may take several minutes to install.

## Your first time using NeuroStack

These instructions will guide you through your first job in NeuroStack. The goal of this example is to introduce you to NeuroStack by running a simple job converting a T1 anatomical MRI file from a nifti file type (.nii) to an AFNI file type(.BRIK and .HEAD). The job should only take a few minutes to run.

1. Download the template script(neurostack_script.sh) and the test structural imaging file (test.nii) from the NeuroStack GitHub repo (https://github.com/hddsilva/NeuroStack)
2. Upload the template script (neurostack_script.sh) to the neurostack-script S3 bucket in your AWS account.
3. Upload your input data (test.nii) to the neurostack-input S3 bucket. Uploading to the neurostack-input S3 bucket will trigger the uploaded file to process according to the template script.
4. (Optional) You can watch your job process through AWS Batch by going to the Batch console in your AWS account. Your job will move from "Submitted" to "Running". When it has moved to either "Succeeded" or "Failed", your job has finished running.
5. After several minutes, your processed data will be automatically uploaded to the neurostack-output S3 bucket. You should see a test.BRIK and a test.HEAD file.

## NeuroStack Usage

### Modifying the script

To run your own job using NeuroStack, you will need to modify the template script to fit your needs. The template script contains a section called "Start user-modified script". You will want to modify the section below that header. The three basic steps you will likely want to do in your job will be to copy your input data to your EC2 instance, perform some operation on that data, and copy your finished data to your output S3 bucket.

NeuroStack has the AWS Command Line Interface (CLI) installed, which can be used to copy data to and from your instance using the AWS CLI S3 syntax (https://docs.aws.amazon.com/cli/latest/reference/s3/). The environment variable, "${aSub}", is defined at the beginning of the template script as the input filename before the first ".". In the example for new users above, ${aSub} becomes "test" because the file name is "test.nii".

NeuroStack contains the NITRC-CE, which allows users access to all of the software pre-installed in the NITRC-CE. In the example for new users, the command 3dcalc from the AFNI software is used to convert file types. However, commands from other software packages included in the NITRC-CE will work as well.

### Uploading to the input S3 bucket

Uploading any file to the neurostack-input S3 bucket will trigger that file to begin processing according to the script in the neurostack-script S3 bucket. There is no limit to the number of files you can upload and have simultaneously processing at a time. Files can be uploaded manually from your local computer or another S3 bucket. If you have the AWS CLI installed on your local computer, you can use the CLI S3 commands referenced above to upload files more efficiently.

### Spot vs On-demand EC2 instances

By default, NeuroStack will run Spot EC2 instances. Spot leverages AWS's excess compute capacity to substantially reduce compute costs. When you use Spot instances, you may need to wait for compute capacity to become available and your job may be terminated early if your compute resource is at capacity. In return, the cost of your EC2 usage is reduced by up to 90%. Otherwise, you can configure NeuroStack to run On-demand EC2 instances by navigating to the AWS Batch console under the "Job queues" tab and editing the "neurostack-jobqueue" to connect to the "neurostack-ondemand" compute environment, instead of "neurostack-spot". After your change has finished updating, your jobs will run using On-demand instances. Your jobs will begin immediately upon request and will not be terminated due to capacity, but AWS will charge full price.

### Modifying the storage volume of your instance

When you run jobs in NeuroStack, your EC2 instance will be attached to a certain amount of storage for storing and writing files for your job. This is separate from your S3 storage buckets. NeuroStack provisions 100 GiB of storage on your instance by default. If your job requires more storage, you may find that your job fails because it cannot write any more files to the instance. You can test this by adding the command "df -kh" at the end of your neurostack_script.sh to view your instance's storage capacity. If you do need additional storage on your instances, this is easy to adjust in NeuroStack. First, download the NeuroStack.yaml file from the NeuroStack GitHub repo (https://github.com/hddsilva/NeuroStack) and open it in a text editor. Find the "VolumeSize: 100" line in the "/dev/sda1" Launch Template specifications (line 135 as of the writing of these instructions). Adjust to your desired GiB of storage. Next, navigate to the AWS CloudFormation console. Select NeuroStack from your Stacks and choose "Update". Choose "Replace current template", "Upload a template file", and upload your modified version of the NeuroStack.yaml file. The instances you initiate after this will have your given GiB of storage.

## Tips for Using NeuroStack

If you have many files to process, we strongly recommend ensuring that your job runs successfully with a handful of files first before uploading all of your files. AWS charges for computation time regardless of whether or not your job is successful. You would not want to pay for lots of computation time to find out that your jobs fail near the end.

If you are using the default Spot EC2 instances, we recommend segmenting your workflow into separate jobs to the extent possible. Spot instances may be terminated early if many other users are using the same compute resource. A termination of a short job is better than a termination on a long job. We also recommend uploading your files to the input S3 bucket in batches if you are using Spot EC2. If you have too many files processing simultaneously, you will be using up the excess capacity Spot utilizes and will have more delayed and terminated jobs. To see how many EC2 instances you currently have running, navigate to the AWS EC2 console.

## Troubleshooting a job on NeuroStack

If your finished data has not been uploaded to the neurostack-output S3 bucket within the expected time, you can troubleshoot by following these steps:

1. **Check that your job has finished running.** Navigate to the AWS Batch console, and find the job in the Batch dashboard. If your job has finished running, it will be under "Succeeded" or "Failed".
2. **If your job has failed,** click on the job name to see the details. You may find an error message under "Status Reason". If your status message states that the essential container in the task exited, click under "Log stream name" to view the log stream. This will show the log events from your job and should show an error message near the end of the log.
3. **If your job succeeded, but your finished data is not in your output S3 bucket,** check your script to ensure the command copying your finished data to your output S3 bucket is correct.

## Deleting NeuroStack

It is not necessary to delete NeuroStack off your AWS account between uses. However, should you want to delete NeuroStack, move or delete any files residing in your neurostack input, output, and script S3 buckets. Then navigate to the AWS CloudFormation console. You should see NeuroStack under your Stacks. Select NeuroStack and delete it. Please note that by deleting NeuroStack, you will delete all of the AWS resources that NeuroStack creates, such as S3 buckets, Batch, and Lambda configurations.


