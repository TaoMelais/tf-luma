# ============================================
# Outputs de l'infrastructure
# ============================================

output "network_summary" {
  description = "Résumé de la configuration réseau"
  value       = module.static_network.network_summary
}

output "containers_created" {
  description = "Détails des containers créés"
  value       = module.dynamic_containers.containers
}

output "container_count" {
  description = "Nombre total de containers"
  value       = module.dynamic_containers.container_count
}

output "container_ips" {
  description = "Adresses IP des containers"
  value       = module.dynamic_containers.container_ips
}
