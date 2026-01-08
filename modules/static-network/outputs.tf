output "network_bridges" {
  description = "Liste des bridges configurés"
  value       = var.network_config.bridges
}

output "network_summary" {
  description = "Résumé de la configuration réseau"
  value = {
    total_bridges = length(var.network_config.bridges)
    bridges       = [for b in var.network_config.bridges : b.name]
  }
}
