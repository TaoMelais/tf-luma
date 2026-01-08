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
    console     = optional(bool)
  }))
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
}
