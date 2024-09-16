## AWS Three Tier Architecture using Terraform

### Project Overview:
Hello, thanks for passing by. I have created this AWS three tier architecutre using terraform which launches the AWS services and deploys the frontend web app, backend server and RDS Aurora database.

### Key AWS Services:
1. EC2
2. VPC
3. S3
4. CloudWatch
5. AWS Systems Manager Session Manager 
6. IAM

### Project Structure:
The terraform code consists of following important modules:
1. **Networking:** Contains the creation of VPC, Subnets, route tables, security groups and Internet Gateway (IGW)
2. **Storage:** Storage contains the S3 to upload the React code for web tier and NodeJs app for backend app tier.
3. **Compute:** Compute is devided in two sub modules. One for web layer and other for app layer.
4. **Database:** DB has the RDS Aurora DB cluster defined.
5. **IAM:** IAM module has the Systems Manager Session Manager role to securely connect to our instances without SSH keys through the AWS console.

### Inhancements:
1. The current terraform does not have the ability to run the infra all at once. We have to first run the modules till app layer instance and then later do the scaling. This is because the auto scaling group and AMI creation does not wait until the user data completes. 
To make it work, I am planning to use the `cfn-signal` and auto scaling lifecycle hooks.
2. The credentials, currently have been hardcoded however, planinig to implement the AWS Secrets Manager to store the secret.


The architecture diagram of the project is as follow:

![Alt architecture](architecture-diagram.png?raw=true "architecture-diagram")

