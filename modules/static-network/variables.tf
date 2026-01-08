variable "network_config" {
  description = "Configuration réseau statique"
  type = object({
    bridges = list(object({
      name    = string
      comment = optional(string)
      node    = string
    }))
  })
}
