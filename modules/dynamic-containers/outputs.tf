output "containers" {
  description = "Détails des containers créés"
  value = {
    for name, ct in proxmox_lxc.containers : name => {
      vmid        = ct.vmid
      hostname    = ct.hostname
      target_node = ct.target_node
      cores       = ct.cores
      memory      = ct.memory
      network     = ct.network
    }
  }
}

output "container_count" {
  description = "Nombre de containers créés"
  value       = length(proxmox_lxc.containers)
}

output "container_names" {
  description = "Liste des noms de containers"
  value       = [for ct in proxmox_lxc.containers : ct.hostname]
}

output "container_ips" {
  description = "Mapping nom de container -> IP"
  value = {
    for name, ct in proxmox_lxc.containers : name => try(ct.network[0].ip, "dhcp")
  }
}
