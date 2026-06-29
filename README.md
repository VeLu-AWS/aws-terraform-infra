# AWS Terraform Infrastructure
### Infrastructure as Code (IaC) for Indian Railways Cloud Deployments on AWS

---

## Overview

This repository contains Terraform code to provision and manage AWS cloud
infrastructure for Indian Railways technology projects at Patil Rail
Infrastructure Pvt Ltd.

Automates provisioning of EC2, S3, Security Groups, Elastic IP, and S3
lifecycle policies — replacing manual AWS Console operations with repeatable,
version-controlled infrastructure.

---

## Architecture
---

## Resources Provisioned

| Resource | Details |
|---|---|
| EC2 Instance | Ubuntu 22.04, t3.medium, gp3 30GB encrypted EBS |
| Elastic IP | Static public IP attached to EC2 |
| Security Group | SSH, HTTP, HTTPS, OpenVPN (UDP 1194) |
| S3 Bucket | Versioning enabled, lifecycle to Glacier |
| Nginx | Auto-installed via user_data script on boot |

---

## S3 Lifecycle Policy

| Stage | Days | Storage Class |
|---|---|---|
| Hot data | 0–30 days | Standard |
| Warm data | 30–90 days | Standard-IA |
| Archive | 90+ days | Glacier |

Projected cost reduction: **60–70%** vs keeping all data in Standard storage.

---

## Usage

### Prerequisites
- Terraform >= 1.3.0 installed
- AWS CLI configured (`aws configure`)
- AWS IAM user with EC2, S3, VPC permissions

### Deploy

```bash
# Clone the repository
git clone https://github.com/VeLu-AWS/aws-terraform-infra.git
cd aws-terraform-infra

# Copy and fill in your values
cp terraform.tfvars.example terraform.tfvars

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply

# Destroy when done
terraform destroy
```

---

## File Structure
---

## Project Context

| Detail | Info |
|---|---|
| **Deployed at** | Production deployment for an Indian railway infrastructure organization |
| **Use case** | Cloud infrastructure automation for railway operations |
| **Region** | AWS Mumbai (ap-south-1) |
| **OS** | Ubuntu Server 22.04 LTS |
| **Storage** | S3 with Glacier lifecycle archival |

---

## Author

**C Sengottuvelu**
AWS Cloud & DevOps Engineer | SAA-C03 Certified
Bengaluru, India
