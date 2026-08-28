terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "s3-backend-malauala0001" # Altere para o seu bucket
    key          = "atividade1/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC e Rede
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name     = "vpc-atividade1-${terraform.workspace}"
    Curso    = "DevSecOps"
    Ambiente = terraform.workspace
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1)
  map_public_ip_on_launch = true

  # Adicione esta linha para fixar a Zona de Disponibilidade
  availability_zone       = "us-east-1a"

  tags = {
    Name     = "subnet-publica-${terraform.workspace}"
    Curso    = "DevSecOps"
    Ambiente = terraform.workspace
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name     = "igw-atividade1-${terraform.workspace}"
    Curso    = "DevSecOps"
    Ambiente = terraform.workspace
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name     = "rt-publica-${terraform.workspace}"
    Curso    = "DevSecOps"
    Ambiente = terraform.workspace
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Chamada do Módulo
module "servidor_web" {
  source = "./modules/servidor-web"

  vpc_id      = aws_vpc.main.id
  subnet_id   = aws_subnet.public.id
  meu_ip      = var.meu_ip
  ambiente    = terraform.workspace
  nome_aluno  = var.nome_aluno
  turma_aluno = var.turma_aluno
}

# Execução automática do Ansible via local-exec
resource "null_resource" "run_ansible" {
  # Dispara o Ansible sempre que o IP público da instância mudar
  triggers = {
    instance_ip = module.servidor_web.public_ip
  }

  provisioner "local-exec" {
    # Comando que roda na sua máquina para disparar o Ansible
    command = "sleep 60 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory_aws_ec2.yml ansible/playbook.yml -u ec2-user --private-key '/home/emcs/Downloads/Pos DevOps/atividade02/labsuser.pem' --extra-vars 'env=${terraform.workspace}' --vault-password-file ~/.vault_pass.txt"
  }
}