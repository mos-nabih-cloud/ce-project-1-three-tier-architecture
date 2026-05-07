# Test Results

## Deployment Validation

```
Apply complete! Resources: 41 added, 0 changed, 0 destroyed.

Outputs:

alb_dns_name = "app-alb-1196878497.us-east-1.elb.amazonaws.com"
alb_security_group_id = "sg-024b7c1b9e7ab2499"
app_instance_ids = [
  "i-065f5b952e4ae9585",
  "i-0b91cd11314e56bd0",
  "i-00768a64b632f2e77",
]
app_private_subnet_ids = [
  "subnet-0e1782e063c0d7698",
  "subnet-0011cfc9b610ec004",
]
app_security_group_id = "sg-0daf0cfae792de6df"
app_target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:120822896302:targetgroup/app-target-group/c3599852c8099804"
availability_zones = [
  "us-east-1a",
  "us-east-1b",
]
data_private_subnet_ids = [
  "subnet-0f328fcf64f1d4817",
  "subnet-05137c1c6b5cb4fb1",
]
data_security_group_id = "sg-01eb38dd4a6d4cf0f"
database_instance_id = "i-084b9baccecb7bba3"
database_private_ip = "10.0.21.251"
public_subnet_ids = [
  "subnet-0411a5f647ec7baea",
  "subnet-0c319902abbe843c7",
]
vpc_id = "vpc-026241204c120a53d"
```

## Expected Runtime Results

Root endpoint:

```bash
curl http://app-alb-1196878497.us-east-1.elb.amazonaws.com/
```

Expected fields:

Instance ID: i-065f5b952e4ae9585
Private IP: 10.0.11.220
Availability Zone: us-east-1a
Database: connected
Database Host: 10.0.21.251
Database Port: 5432

Health endpoint:

```bash
curl http://app-alb-1196878497.us-east-1.elb.amazonaws.com/health
```

Expected response:

```text
ok
```
