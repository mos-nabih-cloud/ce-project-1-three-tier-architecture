# Failover Test

Validate that the Application Load Balancer routes traffic only to healthy app
instances.

## Current HA Capabilities

- ALB spans two public subnets across two AZs.
- App instances are distributed across two private subnets.
- Target group health check uses `/health`.

## Test Procedure

After deployment:

1. Confirm all targets are healthy in the ALB target group.
2. Stop one app EC2 instance.
3. Wait for the target group health check to mark it unhealthy.
4. Send repeated requests to the ALB DNS name.
5. Confirm responses continue from remaining healthy instances.
6. Start the stopped instance.
7. Confirm it returns to healthy status.

## Expected Result

- ALB removes the unhealthy target from rotation.
- Application remains reachable through the ALB.
- Stopped instance returns to service after it becomes healthy again.