# AWS Terraform Backend Bootstrap

**One-time · Production-safe · Account-wide**

This repository bootstraps the **Terraform remote backend** for an AWS account by creating:

- **S3 bucket** (remote state, globally unique)
- **DynamoDB table** (state locking)

Applied once. After that, all other Terraform repositories **only consume** this backend.

---

## Why this repository exists

Terraform cannot use an S3 backend until the backend resources already exist.  
This repository solves Terraform’s bootstrap problem using a **local backend** for the initial apply.

---

## Created infrastructure (only)

### S3 bucket (Terraform state)

- Globally unique name
- Versioning enabled
- Server-side encryption (AES256)
- Public access fully blocked

### DynamoDB table (state locks)

- Used exclusively for Terraform state locking
- Account-scoped naming

Nothing else.

---

## Global uniqueness (S3)

S3 bucket names must be **globally unique across all AWS accounts**.

Example:
```text
foundation-terraform-state-ltn
```

DynamoDB table names only need to be unique **within the AWS account**:
```text
foundation-terraform-locks
```

---

## Usage (one-time)

```bash
terraform init
terraform apply
```

Optional cleanup after successful apply (recommended to avoid confusion):

```bash
rm -rf .terraform
rm -f .terraform.lock.hcl
rm -f terraform.tfstate
rm -f terraform.tfstate.backup
```

---

## How other Terraform repositories use this backend

Example `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "foundation-terraform-state-ltn"
    key            = "global/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "foundation-terraform-locks"
    encrypt        = true
  }
}
```

Environment isolation is achieved **only via the key**:

```hcl
# dev
key = "dev/terraform.tfstate"

# prod
key = "prod/terraform.tfstate"
```

---

## Consumed by

**AWS EKS Terraform Platform — Infrastructure Foundation**  
https://github.com/LaurisNeimanis/aws-eks-platform

This backend must be created **before** any EKS infrastructure is provisioned.

---

## Summary

- One Terraform backend per AWS account
- Applied exactly once
- No ongoing lifecycle
- Minimal, predictable, and safe by design
