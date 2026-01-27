# ============================================
# Configuration Proxmox
# ============================================

variable "proxmox_api_url" {
  description = "URL de l'API Proxmox"
  type        = string
}

variable "proxmox_user" {
  description = "Utilisateur Proxmox (format: user@pam ou user@pve)"
  type        = string
}

variable "proxmox_password" {
  description = "Mot de passe Proxmox"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Ignorer la vérification du certificat TLS"
  type        = bool
  default     = true
}

# ============================================
# Configuration réseau statique
# ============================================

variable "network_config" {
  description = "Configuration réseau statique (bridges, VLANs, etc.)"
  type = object({
    bridges = list(object({
      name    = string
      comment = optional(string)
      node    = string
    }))
  })
  default = {
    bridges = []
  }
}

# ============================================
# Configuration Containers LXC dynamiques
# ============================================

variable "containers" {
  description = "Liste des containers LXC à créer"
  type = list(object({
    vmid        = number
    hostname    = string
    target_node = string
    ostemplate  = string
    cores       = optional(number)
    memory      = optional(number)
    swap        = optional(number)
    storage     = optional(string)
    rootfs_size = optional(string)
    network = object({
      name   = string
      bridge = string
      ip     = optional(string)
      gw     = optional(string)
      tag    = optional(number)
      hwaddr = optional(string)
    })
    network2 = optional(object({
      name   = string
      bridge = string
      ip     = optional(string)
      gw     = optional(string)
      tag    = optional(number)
    }))
    password    = optional(string)
    ssh_keys    = optional(string)
    description = optional(string)
    onboot      = optional(bool)
    unprivileged = optional(bool)
  }))
  default = []
}

variable "container_defaults" {
  description = "Valeurs par défaut pour les containers"
  type = object({
    cores       = number
    memory      = number
    swap        = number
    storage     = string
    rootfs_size = string
    onboot      = bool
    unprivileged = bool
    console     = bool
  })
  default = {
    cores       = 1
    memory      = 512
    swap        = 512
    storage     = "local-lvm"
    rootfs_size = "8G"
    onboot      = true
    unprivileged = true
    console     = false
  }
}
