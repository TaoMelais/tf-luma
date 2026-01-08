output "vms" {
  description = "Détails des VMs créées"
  value = {
    for name, vm in proxmox_vm_qemu.vms : name => {
      id          = vm.id
      name        = vm.name
      target_node = vm.target_node
      cores       = vm.cores
      memory      = vm.memory
      ipconfig    = vm.ipconfig0
    }
  }
}

output "vm_count" {
  description = "Nombre de VMs créées"
  value       = length(proxmox_vm_qemu.vms)
}

output "vm_names" {
  description = "Liste des noms de VMs"
  value       = [for vm in proxmox_vm_qemu.vms : vm.name]
}

output "vm_ips" {
  description = "Mapping nom de VM -> IP"
  value = {
    for name, vm in proxmox_vm_qemu.vms : name => vm.default_ipv4_address
  }
}
