# NeuroStack

NeuroStack allows you to easily run neuroimaging workflows using AWS cloud computing. It is designed to set up the AWS infrastructure needed to perform neuroimaging analysis at scale. NeuroStack is built with the NITRC Compute Environment (NITRC-CE), which allows users to access all of the neuroimaging software pre-installed in NITRC-CE (see https://www.nitrc.org/projects/nitrc es/ for a complete list).


To use NeuroStack, first install NeuroStack in your AWS account. Modify the template script according to your needs and upload it to the neurostack-script S3 bucket. Add your input data to the neurostack-input S3 bucket. When your job has finished, your processed data will be automatically uploaded to the neurostack-output S3 bucket.


Although NeuroStack itself is free to install and use, the AWS resources (ie, storage and compute) that NeuroStack calls upon is charged by AWS. Users are responsible for the AWS charges they incur.

## To Install NeuroStack in your AWS account

1. Log into your AWS account
2. Click the "Launch_NeuroStack" url under your preferred release. This will bring you to the stack creation page on AWS.
3. All specifications for NeuroStack are preset, so you do not need to modify them. Simply continue choosing "Next".
4. On the last page, check the box to accept that IAM permissions will be created before creating the stack. NeuroStack may take several minutes to install.
