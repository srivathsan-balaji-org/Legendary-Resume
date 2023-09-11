terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region #region for the S3 bucket
  }
