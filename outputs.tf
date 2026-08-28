output "ip_publico_instancia" {
  description = "IP Público da Instância EC2"
  value       = module.servidor_web.public_ip
}

output "dns_publico_instancia" {
  description = "DNS Público da Instância EC2"
  value       = module.servidor_web.public_dns
}