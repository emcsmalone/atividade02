Este documento descreve o passo a passo para replicar a infraestrutura e a configuração de um ambiente na AWS que sobe a aplicação do tutorial oficial do Docker (`getting-started-app`). Toda a arquitetura foi desenhada no modelo de Infraestrutura como Código (IaC).

## 1. Pré-requisitos

Antes de iniciar, certifique-se de ter os seguintes componentes instalados e configurados na sua máquina local (Control Node):

*   **Terraform:** Para o provisionamento da infraestrutura AWS.
*   **Ansible:** Para a gerência de configuração (versão `ansible-core` atualizada).
*   **Coleção Ansible para Docker:** Instalada através do comando: `ansible-galaxy collection install community.docker`
*   **Credenciais da AWS:** Chaves de acesso AWS (AWS CLI configurado) para que o Terraform crie os recursos.
*   **Chave SSH:** O arquivo `.pem` (ex: `labsuser.pem`) que será utilizado para se conectar à instância EC2 provisionada.

## 2. Estrutura de Diretórios

Para o correto funcionamento do script integrado entre Terraform e Ansible, a sua estrutura de pastas e arquivos deve ser a seguinte:

```text

├── ansible
│   ├── ansible.cfg
│   ├── inventory_aws_ec2.yml
│   ├── playbook.yml
│   ├── roles
│   │   └── web_app
│   │       └── tasks
│   │           └── main.yml
│   └── vault.yml
├── evidencias
├── main.tf
├── modules
│   └── servidor-web
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── README.md
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
