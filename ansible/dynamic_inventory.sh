#!/bin/sh
# used to pull the current state from S3 and
# use this information for provisioning
playbook=${1}
state_file_name="terraform.tfstate"

# fetch current state form s3
(cd ../terraform && terraform state pull) > ${state_file_name}
./terraform.py ${1}

rm ${state_file_name}
