# Compresse automatiquement le dossier src/ en fichier ZIP
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src" # Pointe vers votre dossier de code source racine
  output_path = "${path.module}/../../lambda_function.zip"
}

resource "aws_lambda_function" "ia_agent" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "agent-ia-${var.environment}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"


  environment {
    variables = {
      KNOWLEDGE_BASE_BUCKET = var.bucket_name
    }
  }
}

# Crée l'API Gateway au format HTTP (léger et gratuit)
resource "aws_apigatewayv2_api" "http_api" {
  name          = "ia-agent-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "OPTIONS", "GET"]
    allow_headers = ["content-type", "authorization"]
    max_age       = 300
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.ia_agent.arn
}

resource "aws_apigatewayv2_route" "api_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /ask"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# Autorise explicitement l'API Gateway à réveiller la Lambda
resource "aws_lambda_permission" "api_gw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ia_agent.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# Affiche l'URL finale de votre IA dans votre terminal à la fin du déploiement
output "api_url" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}/ask"
}