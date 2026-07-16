import json
import os
import boto3

# Initialisation des clients AWS (S3 pour les docs, Bedrock pour l'IA)
s3_client = boto3.client('s3')
bedrock_client = boto3.client('bedrock-runtime', region_name='us-east-1')

# Configuration (Ces valeurs correspondront à notre infrastructure Terraform)
BUCKET_NAME = os.environ.get('KNOWLEDGE_BASE_BUCKET')
FILE_NAME = "connaissances.txt"

def lambda_handler(event, context):
    try:
        # 🌐 1. Intercepter et gérer les requêtes CORS Preflight (OPTIONS)
        http_method = event.get('requestContext', {}).get('http', {}).get('method', '')
        
        if http_method == 'OPTIONS':
            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
                    'Access-Control-Allow-Methods': 'POST, OPTIONS, GET',
                    'Access-Control-Max-Age': '300'
                },
                'body': ''
            }

        # 2. Récupérer la question envoyée par l'utilisateur (via l'API)
        body = json.loads(event.get('body', '{}'))
        user_question = body.get('question', 'Bonjour')

        # 3. Récupérer le fichier de connaissances privé sur Amazon S3
        response = s3_client.get_object(Bucket=BUCKET_NAME, Key=FILE_NAME)
        context_text = response['Body'].read().decode('utf-8')

        # 4. Construire le "Prompt" RAG (donner le contexte et la consigne à l'IA)
        prompt = f"""Tu es un agent IA d'entreprise. Utilise uniquement le contexte suivant pour répondre à la question. Si tu ne sais pas, dis-le gentiment et n'invente rien.

Contexte :
{context_text}

Question : {user_question}
Réponse :"""

        # 5. Préparer la requête standardisée pour Amazon Bedrock (Modèle Nova Micro)
        native_request = {
            "inferenceConfig": {
                "maxTokens": 500,
                "temperature": 0.3 # Une température basse pour éviter les inventions
            },
            "messages": [
                {
                    "role": "user",
                    "content": [{"text": prompt}]
                }
            ]
        }

        # 6. Invoquer le modèle d'IA
        response = bedrock_client.invoke_model(
            modelId="amazon.nova-micro-v1:0", # Le modèle ultra-rapide et gratuit/très économique
            contentType="application/json",
            accept="application/json",
            body=json.dumps(native_request)
        )

        # 7. Extraire la réponse générée par l'IA
        response_body = json.loads(response['body'].read())
        ai_response = response_body['output']['message']['content'][0]['text']

        # 8. Renvoyer la réponse formatée pour l'API Gateway avec les en-têtes CORS
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*' # Permet à votre front-end S3 de lire la réponse
            },
            'body': json.dumps({'response': ai_response}, ensure_ascii=False)
        }

    except Exception as e:
        # En cas d'erreur (ex: fichier S3 manquant), on renvoie le message d'erreur avec les en-têtes CORS
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'error': str(e)})
        }