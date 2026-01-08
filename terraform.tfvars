# ============================================
# Configuration Proxmox
# ============================================
proxmox_api_url      = "https://<IP>:8006/api2/json"
proxmox_user         = "ID@SERVEUR"
proxmox_password     = "MOT_DE_PASSE"
proxmox_tls_insecure = true



# ============================================
# Configuration Containers LXC dynamiques
# ============================================
containers = [
  {
    vmid        = 235
    hostname    = "Monitoring"
    target_node = "pve1"
    ostemplate  = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
    cores       = 2
    memory      = 4096
    swap        = 512
    rootfs_size = "10G"
    
    network = {
      name   = "eth0"
      bridge = "vmbr1"
      ip     = "172.16.1.55/24"
      gw     = "172.16.1.1"
      tag    = 11
      hwaddr = null
    }
    description = "Container de monitoring Grafana"
    onboot      = true
    ssh_keys    = null

  }
  ,
  {
    vmid        = 236
    hostname    = "Prometheus"
    target_node = "pve1"
    ostemplate  = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
    cores       = 2
    memory      = 4096
    swap        = 512
    rootfs_size = "10G"
    
    network = {
      name   = "eth0"
      bridge = "vmbr1"
      ip     = "172.16.1.56/24"
      gw     = "172.16.1.1"
      tag    = 11
      hwaddr = null
    }
    description = "Container Prometheus"
    onboot      = true
    ssh_keys    = null

  }
]

# Valeurs par défaut pour les containers
container_defaults = {
  cores       = 1
  memory      = 512
  swap        = 512
  storage     = "local-lvm"
  rootfs_size = "8G"
  onboot      = true
  unprivileged = true
  console     = false
}


# ============================================
# Configuration réseau statique
# ============================================
# Décommentez et configurez selon vos besoins
# network_config = {
#   bridges = [
#     {
#       name    = "vmbr1"
#       comment = "Bridge pour VMs"
#       node    = "pve"
#     }
#   ]
# }

# ============================================
# Configuration VMs dynamiques
# ============================================
vms = [
  # Exemple de VM
  # {
  #   name        = "vm-web-01"
  #   target_node = "pve"
  #   clone       = "ubuntu-cloud-template"
  #   cores       = 2
  #   memory      = 4096
  #   disk_size   = "30G"
  #   network = {
  #     model  = "virtio"
  #     bridge = "vmbr0"
  #     tag    = null
  #   }
  #   ip_config = {
  #     ip      = "192.168.1.100/24"
  #     gateway = "192.168.1.1"
  #   }
  #   description = "Serveur Web"
  #   onboot      = true
  #   agent       = 1
  # }
]

# Valeurs par défaut pour les VMs
vm_defaults = {
  cores     = 2
  memory    = 2048
  disk_size = "20G"
  onboot    = true
  agent     = 1
}

