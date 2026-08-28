data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg-${var.ambiente}"
  description = "Permitir App na porta 3000 e SSH restrito"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH do meu IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.meu_ip]
  }

  ingress {
    description = "App aberto na porta 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "sg-web-${var.ambiente}"
    Curso    = "DevSecOps"
    Ambiente = var.ambiente
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux_2023.id

  # O requisito técnico da atividade exige especificamente t3.micro para todos os ambientes
  instance_type = "t3.micro"
  # Força a vinculação da chave existente na AWS
  key_name = "labsuser"

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  # O bloco user_data foi removido. A configuração interna da máquina 
  # (instalação do Docker e execução do container) agora é 100% responsabilidade do Ansible.

  tags = {
    Name     = "web-server-${var.ambiente}"
    Curso    = "DevSecOps"
    Ambiente = var.ambiente
    Ansible  = "true" # Tag adicionada para facilitar o filtro no inventário dinâmico do Ansible
  }
}