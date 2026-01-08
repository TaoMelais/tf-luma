# ============================================
# Outputs de l'infrastructure
# ============================================

output "network_summary" {
  description = "Résumé de la configuration réseau"
  value       = module.static_network.network_summary
}

output "vms_created" {
  description = "Détails des VMs créées"
  value       = module.dynamic_vms.vms
}

output "vm_count" {
  description = "Nombre total de VMs"
  value       = module.dynamic_vms.vm_count
}

output "vm_ips" {
  description = "Adresses IP des VMs"
  value       = module.dynamic_vms.vm_ips
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
