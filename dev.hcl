bucket         = "delphine-mycloudcorp-tfstates"
key            = "agent-ia/dev/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-lock-dev"
encrypt        = true
