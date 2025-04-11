#!/usr/bin/env bash

# ./deploy-ec2-instance-extra.sh 3

set -e

export AWS_DEFAULT_REGION="us-east-2"
export AWS_PROFILE=personal-mgmt-admin

# Default instance count is 1 if not use
INSTANCE_COUNT="${1:-1}"

echo "Creating $INSTANCE_COUNT instance(s)..."

user_data=$(cat user-data.sh)

security_group_id=$(aws ec2 create-security-group \
  --group-name "sample-app" \
  --description "Allow HTTP traffic into the sample app" \
  --output text \
  --query GroupId)

aws ec2 authorize-security-group-ingress \
  --group-id "$security_group_id" \
  --protocol tcp \
  --port 80 \
  --cidr "0.0.0.0/0" > /dev/null

image_id=$(aws ec2 describe-images \
  --owners amazon \
  --filters 'Name=name,Values=al2023-ami-2023.*-x86_64' \
  --query 'reverse(sort_by(Images, &CreationDate))[:1] | [0].ImageId' \
  --output text)

# Initialize arrays to store instance IDs and public IPs
instance_ids=()
public_ips=()

# Loop to create multiple instances

for i in $(seq 1 $INSTANCE_COUNT);
do 
  echo "Creating instance $i of $INSTANCE_COUNT..."
  instance_id=$(aws ec2 run-instances \
    --image-id "$image_id" \
    --instance-type "t2.micro" \
    --security-group-ids "$security_group_id" \
    --user-data "$user_data" \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=sample-app}]' \
    --output text \
    --query Instances[0].InstanceId)

  instance_ids+=("$instance_id")
  
  echo "Instance $i created with ID: $instance_id"
done 

# Wait a moment for public IPs to be assigned
echo "Waiting for public IPs to be assigned..."
sleep 10

# Get public IPs for all instances
for instance_id in "${instance_ids[@]}"; 
do
  public_ip=$(aws ec2 describe-instances \
    --instance-ids "$instance_id" \
    --output text \
    --query 'Reservations[*].Instances[*].PublicIpAddress')

  public_ips+=("$public_ip")
done

# Output all instance details
echo -e "\nInstance Details:"
echo "Security Group ID = $security_group_id"
echo -e "\nInstances:"

for i in "${!instance_ids[@]}"; do
  echo "Instance $(($i+1)):"
  echo "  ID: ${instance_ids[$i]}"
  echo "  Public IP: ${public_ips[$i]}"
  echo "  URL: http://${public_ips[$i]}"
  echo ""
done