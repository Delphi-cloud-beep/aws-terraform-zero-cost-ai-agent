bucket         = "delphine-mycloudcorp-tfstates"
key            = "agent-ia/prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-lock-prod"
encrypt        = true
