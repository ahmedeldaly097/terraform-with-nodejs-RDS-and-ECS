# Terraform deploy on AWS that contains a Dockerized Node.JS application that connects to a RDS Database

### 1. Create an Amazon Virtual Private Cloud (VPC) with two private subnets and two public subnets. The private subnets will host the RDS database and ECS service, and the public subnets will host the application load balancer and CloudFront distribution.
---
### 2. Create a security group for the RDS database that only allows traffic from the ECS service security group.
---
### 3. Create an ECS cluster in the private subnets.
---
### 4. Create an ECS task definition for the Node.JS application that specifies the Docker image and container port.
---
### 5. Create an ECS service for the Node.JS application that runs the task definition in the private subnets.
---
### 6. Create a target group for the application load balancer.
---
### 7. Create an application load balancer in the public subnets with a listener and target group for the ECS service.
---
### 8. Create a security group for the ECS service that allows incoming traffic from the application load balancer and outgoing traffic to the RDS database.
---
### 9. Create an RDS database instance in the private subnets of the VPC with a security group that only allows incoming traffic from the ECS service security group.
---
### 10. Create a security group for the RDS database that only allows incoming traffic from the ECS service security group.
---
### 11. Create a CloudFront distribution that caches the Node.JS application and uses the application load balancer as the origin.
---
### 12. Output the application URL.