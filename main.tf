provider "aws" {
  region = "ap-south-1"
}

terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }
  }

  backend "s3" {
    bucket = "aws-smb-pavan-state-file"
    key    = "AWS-SMB-pavan-statefile-test.tfstate"
    #workspace_key_prefix = "workspaces"
    region = "ap-south-1"
  }
}
