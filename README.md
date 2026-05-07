# Three-Tier Architecture on AWS

Terraform project for a simple three-tier AWS architecture.

## Project Structure

```text
.
├── terraform/
│   ├── alb.tf
│   ├── compute.tf
│   ├── networking.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── security-groups.tf
│   ├── variables.tf
│   └── scripts/
│       ├── app-user-data.sh
│       └── database-user-data.sh
└── README.md
```

Terraform files live in `terraform/`. Run Terraform commands from that directory.

## Current Scope

The first milestone provisions the network foundation:

- One VPC with a `/16` CIDR block
- Two public subnets for the presentation tier in `us-east-1a` and `us-east-1b`
- Two private subnets for the application tier in `us-east-1a` and `us-east-1b`
- Two private subnets for the data tier in `us-east-1a` and `us-east-1b`
- Internet Gateway for public internet access
- One NAT Gateway for outbound access from the application tier
- Route tables for public, application-private, and data-private subnets
- Security groups for the presentation, application, and data tiers
- Internet-facing Application Load Balancer in the public subnets
- HTTP listener on port `80`
- Target group with `/health` health check
- Three private EC2 instances running a simple web application
- Application target group attachments for the private EC2 instances
- One private EC2 instance as a database placeholder in the data tier

## Usage

```bash
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
```

## Design Notes

This project starts with a single NAT Gateway to keep cost and complexity low. The data tier route table intentionally has no default internet route, keeping the database subnet isolated.

The security group rules follow least privilege:

- ALB allows public HTTP and HTTPS.
- Application instances allow HTTP and HTTPS only from the ALB security group.
- Data tier allows database traffic only from the application security group.

The application instances expose:

- `/health` for the ALB health check
- `/` with instance ID, Availability Zone, database status, and health check path

The data tier uses an EC2-based TCP listener as a database placeholder. It is deployed in a data private subnet and only accepts database-port traffic from the application security group.
