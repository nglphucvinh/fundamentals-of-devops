# Get your hands dirty
### Configuration Management Tools
1. What happens if you run the Ansible playbook a second time? How does this compare to the Bash script?
a. When running the playbook a second time
```
PLAY RECAP **********************************************************************************************************************************************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
b. Ansible ensure idempotency, it will check the current state before making change, making this safer than using bash script
2. How would you have to change the playbook to configure multiple EC2 instances?
--> Changing the num of instance to 2 or more

### Server Templating Tools
1. What happens if you run `packer build` on this template a second time? Why?
--> As packer does not save state, so a new image will be created the second time. However if we modify the script and not use "uuid4" then there will be error like this
```
Build 'amazon-ebs.amazon-linux' errored after 3 seconds 985 milliseconds: Error: AMI Name: 'sample-app-packer-5a68a42a-25f6-4c57-a313-d98a59782ef6' is used by an existing AMI: ami-05ec047b2651376d8
```
2. Figure out how to update the Packer template so it builds images not only for AWS, but also images you can run on other clouds (e.g., Azure or GCP) or on your own computer (e.g., VirtualBox or Docker).
--> Check sample-app-extra.pkr.hcl, the key is to define multiple source for all the cloud, virtualbox, and docker that you want to build the image for and modify the source accordingly, you will also need to authenticate to the other clouds some way in order to use the script, but packer will still run everything and output the final result.
```
==> Some builds didn't complete successfully and had errors:
--> virtualbox-iso.virtualbox-linux: Error reading version for guest additions download: exit status 126
--> googlecompute.gcp-linux: google: could not find default credentials. See https://cloud.google.com/docs/authentication/external/set-up-adc for more information
--> azure-arm.azure-linux: error fetching subscriptionID from VM metadata service for Managed Identity authentication: Get "http://169.254.169.254/metadata/instance/compute?api-version=2017-08-01&format=json": dial tcp 169.254.169.254:80: i/o timeout
--> docker.docker-linux: Script exited with non-zero exit status: 127. Allowed exit codes are: [0]

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.amazon-linux: AMIs were created:
us-east-2: ami-05ec047b2651376d8
```

### Provisioning Tools
1. How do you deploy multiple EC2 instances with OpenTofu?
--> Update main.tf
```
resource "aws_instance" "sample_app" {                         
  ami                    = data.aws_ami.sample_app.id
  count                  = 2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sample_app.id]
  user_data              = file("${path.module}/user-data.sh")

  tags = {
    Name = "${var.name}-${count.index}"   
  }
}
```
Update outputs.tf
```
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.sample_app[*].id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.sample_app[*].id
}

output "public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.sample_app[*].public_ip
}
```
2. What happens if you terminate an instance and re-run apply?
--> OpenTofu tracks the state and know which instance has been removed, the second time we rerun apply, OpenTofu will try to create the instance
```
Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  ~ instance_id       = [
      - "i-0ae4cfcd5dd29da5d",
      + (known after apply),
        "i-066c040036edb33a4",
    ]
  ~ public_ip         = [
      - "3.139.96.83",
      + (known after apply),
        "3.141.166.80",
    ]
```
3. Make your ec2-instance module more configurable: e.g., add input variables for the instance type, AMI name, and so on.
--> Check the varialbes.tf
4. Learn how to version your modules. 
--> Using git tag, updated in main.tf