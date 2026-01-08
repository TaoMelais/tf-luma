terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

# ============================================
# Module Static Network - Configuration réseau Proxmox
# ============================================
# Ce module gère la configuration réseau statique :
# - Bridges réseau
# - VLANs
# - Liaisons réseau

# Note : Le provider Proxmox (telmate/proxmox) a des limitations pour la gestion
# du réseau au niveau de l'API. La plupart des configurations réseau dans Proxmox
# doivent être effectuées manuellement ou via des scripts shell.

# Pour une configuration réseau avancée, considérez :
# 1. Configuration manuelle via l'interface Proxmox
# 2. Utilisation de null_resource avec provisioners pour exécuter des scripts
# 3. Utilisation d'Ansible en complément pour la configuration réseau

# Exemple de configuration réseau via null_resource (nécessite SSH configuré)
# resource "null_resource" "configure_network" {
#   for_each = { for bridge in var.network_config.bridges : bridge.name => bridge }
#   
#   provisioner "remote-exec" {
#     inline = [
#       "pvesh create /nodes/${each.value.node}/network --iface ${each.value.name} --type bridge --autostart 1"
#     ]
#     
#     connection {
#       type     = "ssh"
#       host     = var.proxmox_host
#       user     = "root"
#       password = var.proxmox_password
#     }
#   }
# }

# Pour l'instant, ce module sert de placeholder et de documentation
# Les configurations réseau doivent être effectuées manuellement dans Proxmox

output "network_info" {
  description = "Information sur la configuration réseau"
  value = {
    bridges_configured = var.network_config.bridges
    note               = "La configuration réseau doit être effectuée manuellement dans Proxmox"
  }
}
