#!/bin/bash

# List of AWS regions you want to capture resources from
regions=("us-east-1" "us-west-2" "eu-west-1" "ap-south-1")

# CSV file to store the results
output_file="aws_resources.csv"

# Create the CSV file and write the header row
echo "Region,ResourceType,ResourceId" > $output_file

# Loop through each region and capture EC2 instances
for region in "${regions[@]}"
do
  # Fetch EC2 instances and store the results in the file
  aws ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId]' --output text | sed "s/^/$region,EC2,/" >> $output_file

  # Fetch S3 bucket names and store the results in the file
  aws s3 ls --region $region --query "Buckets[].Name" | sed "s/^/$region,S3,/" >> $output_file

  # Add more commands for other resource types (e.g., EFS, RDS, EKS, Load Balancers, CloudFront, etc.) as per your requirements
  # aws efs describe-file-systems --region $region --query 'FileSystems[*].[FileSystemId]' --output text | sed "s/^/$region,EFS,/" >> $output_file
  # aws rds describe-db-instances --region $region --query 'DBInstances[*].[DBInstanceIdentifier]' --output text | sed "s/^/$region,RDS,/" >> $output_file
  # ... and so on
done
