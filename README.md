# 🤖 Agent IA d'Entreprise Serverless (RAG) — Conception Zéro-Coût

Ce projet démontre la conception et le déploiement d'une architecture Cloud moderne intégrant un **Agent IA (Génération Augmentée par Récupération - RAG)** sur AWS, entièrement automatisée avec **Terraform** et optimisée pour respecter le cadre de l'offre gratuite (_Free-Tier_).

L'agent est capable de répondre intelligemment à des questions techniques ou métiers en se basant exclusivement sur une base de connaissances privée (fichiers textes) stockée de manière sécurisée, éliminant ainsi tout risque d'hallucination.

---

## 🛠️ Architecture & Technologies

L'infrastructure est entièrement Serverless, garantissant un coût de fonctionnement de **0 €** pour un usage de démonstration :

- **Infrastructure as Code (IaC) :** Terraform (Modularité, Automatisation, Gestion du Cycle de vie).
- **Moteur d'IA :** Amazon Bedrock avec le modèle de langage de dernière génération **Amazon Nova Micro** (`amazon.nova-micro-v1:0`).
- **Calcul & Logique :** AWS Lambda (Python 3.11) intégrant une ingestion de contexte S3 dynamique.
- **Stockage Cloud :** Amazon S3 (Base de connaissances isolée, privée et chiffrée).
- **Point d'accès API :** Amazon API Gateway (HTTP API légère et performante).
- **Sécurité & FinOps :** Gestion stricte des rôles IAM (Moindre privilège) et intégration d'un **AWS Budget** préventif limitant les coûts à 1$.

---

## 📐 Schéma des Flux

[Utilisateur / Client API]
│
▼ (Requête HTTP POST /ask)
[Amazon API Gateway]
│
▼ (Déclenchement Synchrone)
[AWS Lambda (Python)]
╱ ╲
▼ ▼
[Amazon S3] [Amazon Bedrock]
(Lit le fichier (Invoque le modèle
connaissances.txt) Nova Micro)

---

## 🚀 Fonctionnalités Clés Démontrées

1. **Zéro-Infrastructure Payante (FinOps) :** Utilisation stratégique de services Serverless à la demande pour éviter les coûts fixes des bases de données vectorielles traditionnelles managées (OpenSearch/Pinecone), idéal pour les PME ou les MVP.
2. **Automatisation Pipeline :** Déploiement complet, packaging à la volée du code Python en archive ZIP (`data.archive_file`) et exposition de l'API publique en une seule commande (`terraform apply`).
3. **Sécurité native (Least Privilege) :** La fonction Lambda dispose de droits IAM chirurgicaux : lecture restreinte au bucket S3 du projet et droit d'invocation unique sur les modèles Bedrock. Le bucket S3 bloque nativement tout accès public.

---

## 💻 Comment Tester le Projet

### Prérequis

- Un compte AWS actif.
- Terraform et l'AWS CLI configurés en local avec un profil IAM valide (`aws configure`).

### Déploiement

1. Clonez le dépôt :

   ```bash
   git clone [https://github.com/VOTRE_NOM_UTILISATEUR/aws-terraform-zero-cost-ai-agent.git](https://github.com/VOTRE_NOM_UTILISATEUR/aws-terraform-zero-cost-ai-agent.git)
   cd aws-terraform-zero-cost-ai-agent


   🧑‍💻 À Propos de Moi
   Professionnel certifié AWS Solutions Architect, AWS Cloud Practitioner et HashiCorp Terraform Associate. Ce projet illustre ma capacité à fusionner les architectures d'Intelligence Artificielle modernes (Generative AI / RAG) avec des pratiques DevOps rigoureuses, sécurisées et économiquement optimisées.
   ```
