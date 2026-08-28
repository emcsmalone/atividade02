# Atividade 1 - Provisionamento de Infraestrutura Web na AWS com Terraform

Este repositório contém a infraestrutura como código (IaC) necessária para provisionar um servidor web na AWS, utilizando as melhores práticas de Terraform (State Remoto, Workspaces, Módulos e Variáveis).

##  Pré-requisitos

Para executar este projeto, você precisará ter instalado em sua máquina:
*   [Terraform](https://developer.hashicorp.com/terraform/downloads) (versão >= 1.0)
*   [AWS CLI](https://aws.amazon.com/cli/) devidamente configurado com credenciais válidas. **Nenhuma credencial está versionada neste repositório por questões de segurança.**
*   Saber seu IP público (acesse [meuip.com.br](https://meuip.com.br) para descobrir).

## Configurações Iniciais

### 1. Bucket de Backend
O controle de estado (State Remoto) está configurado para utilizar o Amazon S3 com bloqueio de estado habilitado.
*   **Bucket utilizado:** `[INSIRA_AQUI_O_NOME_DO_SEU_BUCKET]`
*   *Nota:* O bucket foi criado manualmente via AWS Console antes da inicialização.

### 2. Variáveis Obrigatórias
Durante a execução, você precisará informar seu IP público para a liberação da porta SSH (22). As portas HTTP (80) já estão abertas para o mundo.

## Estrutura do projeto

```
~/iac/
├── main.tf
├── modules
│   └── servidor-web
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
└── variables.tf
```

## Como Executar

### 1. Inicializar o Terraform
Criando um bucket s3

```
aws s3api create-bucket --bucket s3-backend-malauala0001

```
Inicializando o terraform
```
terraform init
```
### Validação e Formatação
```
terraform fmt -check
terraform validate

Success! The configuration is valid

```
### Utilizando Workspaces
DEV

```
terraform workspace select dev || terraform workspace new dev && terraform apply -var="meu_ip=SEU_IP/32"

```
PROD

```
terraform workspace select prod || terraform workspace new prod && terraform apply -var="meu_ip=SEU_IP/32"
```

### Limpeza da infraestrutura

DEV

´´´terraform workspace select dev 
terraform destroy -var="meu_ip=SEU_IP/32"

```
PROD 

```
terraform workspace select prod 
```
terraform destroy -var="meu_ip=SEU_IP/32"
```

### Deletando S3

```
aws s3 rb s3://s3-backend-malauala0001 --force

```
