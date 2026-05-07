# Test Plan

## Pre Deployment Tests

1. Format Terraform:

```bash
cd terraform
terraform fmt -check -recursive
```

2. Validate Terraform:

```bash
terraform validate
```

3. Review plan:

```bash
terraform plan
```

Expected result:

- Terraform shows resources to create.
- No validation errors.
- No unexpected public EC2 instances.

## Deployment Tests

1. Apply Terraform:

```bash
terraform apply
```

2. Get ALB DNS name:

```bash
terraform output alb_dns_name
```

3. Test application root endpoint:

```bash
curl http://app-alb-1196878497.us-east-1.elb.amazonaws.com/
```

Expected:

- HTTP 200
- HTML response
- instance ID present
- private IP present
- Availability Zone present
- database status present

4. Test health endpoint:

```bash
curl http://app-alb-1196878497.us-east-1.elb.amazonaws.com/health
```

Expected:

```text
ok
```

## AWS Console Checks

- ALB has healthy targets.
- App instances are in private subnets.
- Database placeholder is in a data private subnet.
- App and database instances do not have public IP addresses.
- Data route table has no default route to NAT Gateway or Internet Gateway.

## Cleanup Test

Run:

```bash
terraform destroy
```

Expected:

- Terraform destroys all managed resources.
- No NAT Gateway, ALB, EC2 instances, or unattached EBS volumes remain.
