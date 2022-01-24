provider "aws" {
   region = "ca-central-1"
   default_tags {
    tags = {
      Environment = "Terraform"
      Owner       = "Adrian"
    }
  }
 }