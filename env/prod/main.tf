module "ia_agent_infra" {
  source       = "../../modules/infrastructure_base"
  environment  = var.environment
  bucket_name  = var.bucket_name
}