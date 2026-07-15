resource "aws_s3_bucket" "knowledge_base" {
  bucket        = var.bucket_name
  force_destroy = true # Permet de supprimer le bucket même s'il contient votre fichier texte lors du destroy
}

# Bloque totalement l'accès public au bucket (Sécurité maximale)
resource "aws_s3_bucket_public_access_block" "s3_privacy" {
  bucket = aws_s3_bucket.knowledge_base.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}