variable "environment" {
  type        = string
  description = "Le nom de l'environnement (dev ou prod)"
}

variable "bucket_name" {
  type        = string
  description = "Le nom unique du bucket S3 pour cet environnement"
}