variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "meu_ip" {
  description = "Meu IP publico para acesso SSH (ex: 203.0.113.50/32)"
  type        = string
  # NÃO defina default aqui, passe via arquivo .tfvars (não commitado) ou linha de comando.
}

variable "nome_aluno" {
  description = "Nome do aluno para o HTML"
  type        = string
  default     = "Eric Malone" #"SEU NOME AQUI"
}

variable "turma_aluno" {
  description = "Identificacao da turma"
  type        = string
  default     = "2025.2" #"SUA TURMA AQUI"
}