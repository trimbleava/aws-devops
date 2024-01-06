
#!/bin/sh

# Use AWS CLI to get the most recent version of an AMI that 
# matches certain criteria. Has obvious uses. Made possible via
# --query, --output text, and the fact that RFC3339 datetime
# fields are easily sortable.

export AWS_DEFAULT_REGION=us-east-1
echo "ubuntu jammy .............."
aws ec2 describe-images \
 --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64* \
 --query 'Images[*].[ImageId,CreationDate]' --output text \
 | sort -k2 -r \
 | head -n1

# Might want to limit that to the Ubuntu Cloud account. Can also use sort_by in the query to get the most recent.
echo "ubuntu xenial .............."
aws ec2 describe-images \
    --owners 099720109477 \
    --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-* \
    --query 'sort_by(Images,&CreationDate)[-1].ImageId'

# Revised to capture all Ubuntu Images:
echo "all ubuntu .............."
aws ec2 describe-images --filters "Name=name,Values=ubuntu*" --query "sort_by(Images, &CreationDate)[].Name"
