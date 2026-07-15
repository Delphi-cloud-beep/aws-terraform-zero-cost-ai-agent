terraform {
  backend "s3" {
    bucket         = "delphine-mycloudcorp-tfstates"
    key            = "mycloudcorp/env/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-prod"
  }
}