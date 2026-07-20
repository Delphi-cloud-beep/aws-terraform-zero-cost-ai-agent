terraform {
  backend "s3" {
    # Les valeurs (bucket, key, dynamodb_table...) sont injectées via
    # `terraform init -backend-config=environments/<env>.hcl`
    # Ne rien coder en dur ici pour pouvoir réutiliser ce fichier sur dev et prod.
  }
}
