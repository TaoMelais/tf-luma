terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

# ============================================
# Module Dynamic VMs - Gestion des machines virtuelles
# ============================================

resource "proxmox_vm_qemu" "vms" {
  for_each = { for vm in var.vms : vm.name => vm }

  # Configuration de base
  name        = each.value.name
  target_node = each.value.target_node
  clone       = each.value.clone
  
  # Ressources
  cores  = each.value.cores
  memory = each.value.memory
  
  # Agent QEMU
  agent = coalesce(each.value.agent, var.vm_defaults.agent)
  
  # Démarrage automatique
  onboot = coalesce(each.value.onboot, var.vm_defaults.onboot)
  
  # Description
  desc = coalesce(each.value.description, "VM gérée par Terraform")
  
  # Configuration réseau
  network {
    model  = each.value.network.model
    bridge = each.value.network.bridge
    tag    = each.value.network.tag
  }
  
  # Configuration disque
  disk {
    storage = "local-lvm"  # À adapter selon votre configuration
    size    = each.value.disk_size
    type    = "scsi"
  }
  
  # Options supplémentaires
  os_type   = "cloud-init"
  scsihw    = "virtio-scsi-pci"
  bootdisk  = "scsi0"
  
  # Cloud-init - Configuration IP et DNS
  cicustom  = ""
  ipconfig0 = each.value.ip_config != null ? "ip=${each.value.ip_config.ip},gw=${each.value.ip_config.gateway}" : "ip=dhcp"
  nameserver = each.value.ip_config != null && length(regexall("^172\\.16\\.", each.value.ip_config.ip)) > 0 ? "172.16.1.254" : "1.1.1.1"
  searchdomain = each.value.ip_config != null && length(regexall("^172\\.16\\.", each.value.ip_config.ip)) > 0 ? "luma.securite" : "mastere.lan"
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
