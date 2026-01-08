terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

# ============================================
# Module Dynamic Containers - Gestion des containers LXC
# ============================================

resource "proxmox_lxc" "containers" {
  for_each = { for ct in var.containers : ct.hostname => ct }

  # Configuration de base
  vmid        = each.value.vmid
  hostname    = each.value.hostname
  target_node = each.value.target_node
  ostemplate  = each.value.ostemplate
  
  # Ressources
  cores  = coalesce(each.value.cores, var.container_defaults.cores)
  memory = coalesce(each.value.memory, var.container_defaults.memory)
  swap   = coalesce(each.value.swap, var.container_defaults.swap)
  
  # Démarrage automatique
  onboot = coalesce(each.value.onboot, var.container_defaults.onboot)
  
  # Mode privilégié/non-privilégié
  unprivileged = coalesce(each.value.unprivileged, var.container_defaults.unprivileged)
  
  # Console
  console = coalesce(each.value.console, var.container_defaults.console)
  
  # Description
  description = coalesce(each.value.description, "Container LXC géré par Terraform")
  
  # Configuration réseau principale
  network {
    name   = each.value.network.name
    bridge = each.value.network.bridge
    ip     = each.value.network.ip != null ? each.value.network.ip : "dhcp"
    gw     = each.value.network.gw
    tag    = each.value.network.tag
    hwaddr = each.value.network.hwaddr != null ? each.value.network.hwaddr : null
  }
  
  # Configuration DNS
  nameserver = "172.16.1.254"
  searchdomain = "luma.securite"
  
  # Configuration du système de fichiers root
  rootfs {
    storage = coalesce(each.value.storage, var.container_defaults.storage)
    size    = coalesce(each.value.rootfs_size, var.container_defaults.rootfs_size)
  }
  
  # Authentification
  password = each.value.password
  ssh_public_keys = each.value.ssh_keys
  
  # Options
  start = true
}
