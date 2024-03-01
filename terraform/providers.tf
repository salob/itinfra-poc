provider "aws" {
  region                   = var.REGION[local.AWS_ENV]
  shared_credentials_files = ["/Users/sobriain/.aws/credentials"]
  profile                  = "default"
  # access_key = var.ACCESS_KEY
  # secret_key = var.SECRET_KEY
  # token      = var.TOKEN
}
