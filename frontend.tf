# 1. Création du bucket S3 pour le site statique
resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = "mon-agent-ia-frontend-portfolio-zero-cost" 
  force_destroy = true
}

# 2. Configuration pour l'hébergement statique (Static Website Hosting)
resource "aws_s3_bucket_website_configuration" "frontend_hosting" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# 3. Désactiver le blocage d'accès public (nécessaire pour un site web public)
resource "aws_s3_bucket_public_access_block" "frontend_public_block" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Politique d'accès (Bucket Policy) pour rendre les objets lisibles publiquement
resource "aws_s3_bucket_policy" "frontend_policy" {
  # On attend que le blocage public soit désactivé pour appliquer la policy
  depends_on = [aws_s3_bucket_public_access_block.frontend_public_block]
  bucket     = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}

# 5. Téléversement automatique de l'index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.frontend_bucket.id
  key          = "index.html"
  source       = "${path.module}/index.html" # Placez votre fichier index.html à la racine du projet
  content_type = "text/html"
}

# 6. Afficher l'URL du site web à la fin du déploiement
output "frontend_url" {
  value       = "http://${aws_s3_bucket_website_configuration.frontend_hosting.website_endpoint}"
  description = "URL publique pour accéder à l'interface de l'agent IA"
}