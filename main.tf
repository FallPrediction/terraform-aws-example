# https://developer.hashicorp.com/terraform/language/settings
terraform {
  required_providers {
    # 尋找可用的provider: https://registry.terraform.io/browse/providers
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }

  backend "s3" {
    bucket = "terraform-backup-seoul"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
  }

  required_version = ">= 1.4"
}

provider "aws" {
  region = "ap-northeast-2"
}
