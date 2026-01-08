variable "vms" {
  description = "Liste des VMs à créer"
  type = list(object({
    name        = string
    target_node = string
    clone       = string
    cores       = number
    memory      = number
    disk_size   = string
    network = object({
      model  = string
      bridge = string
      tag    = optional(number)
    })
    ip_config = optional(object({
      ip      = string
      gateway = string
    }))
    description = optional(string)
    onboot      = optional(bool)
    agent       = optional(number)
  }))
}

variable "vm_defaults" {
  description = "Valeurs par défaut pour les VMs"
  type = object({
    cores     = number
    memory    = number
    disk_size = string
    onboot    = bool
    agent     = number
  })
}
