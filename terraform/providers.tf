provider "aws" {
  region                   = var.REGION[local.AWS_ENV]
  shared_credentials_files = ["/Users/sobriain/.aws/credentials"]
  profile                  = "default"
}
