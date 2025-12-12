variable "region" {
  description = "AWS region for backend resources"
  type        = string
  default     = "eu-central-1"
}

variable "project" {
  description = "Prefix for all Terraform backend resources (S3 bucket, DynamoDB table)"
  type        = string
  default     = "foundation"
}

variable "enable_bucket_versioning" {
  description = "Enable versioning for the state bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm for the S3 bucket"
  type        = string
  default     = "AES256"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}
