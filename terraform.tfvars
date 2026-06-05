# ============================================
# Configuration Proxmox
# ============================================
proxmox_api_url      = "https://192.168.0.17:8006/api2/json"
proxmox_tls_insecure = true
# proxmox_user et proxmox_password sont definis dans .env (variables TF_VAR_*)


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
      hwaddr = "BC:24:11:59:D2:55"
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
      hwaddr = "BC:24:11:59:D2:56"
    }
    description = "Container Prometheus"
    onboot      = true
    ssh_keys    = null

  }
  ,
  {
    vmid        = 237
    hostname    = "Loki"
    target_node = "pve1"
    ostemplate  = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
    cores       = 2
    memory      = 4096
    swap        = 512
    rootfs_size = "10G"
    
    network = {
      name   = "eth0"
      bridge = "vmbr1"
      ip     = "172.16.1.57/24"
      gw     = "172.16.1.1"
      tag    = 11
      hwaddr = "BC:24:11:59:D2:57"
    }
    description = "Container Loki"
    onboot      = true
    ssh_keys    = null

  }
  ,
   {
    vmid        = 238
    hostname    = "Promtail"
    target_node = "pve1"
    ostemplate  = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
    cores       = 2
    memory      = 4096
    swap        = 512
    rootfs_size = "10G"
    
    network = {
      name   = "eth0"
      bridge = "vmbr1"
      ip     = "172.16.1.58/24"
      gw     = "172.16.1.1"
      tag    = 11
      hwaddr = "BC:24:11:59:D2:58"
    }
    description = "Container Promtail"
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