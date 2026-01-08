# TF-Luma (Proxmox Terraform)

## Aperçu
Infra-as-Code pour Proxmox utilisant Terraform (provider telmate/proxmox) pour :
- Réseau statique (placeholder/documentation)
- VMs dynamiques (clones cloud-init)
- Containers LXC dynamiques

## Structure
- `main.tf` : orchestre les modules `static_network`, `dynamic_vms`, `dynamic_containers`
- `provider.tf` : configuration du provider Proxmox
- `variables.tf` / `outputs.tf` : variables globales et sorties agrégées
- `terraform.tfvars` : valeurs d'entrée (URL API, credentials, listes de VMs/containers)
- `modules/static-network` : placeholder réseau et outputs
- `modules/dynamic-vms` : ressources `proxmox_vm_qemu`
- `modules/dynamic-containers` : ressources `proxmox_lxc`

## Prérequis
- Terraform >= 1.0
- Accès API Proxmox avec droits suffisants
- Template cloud-init existant pour les VMs (ex: `ubuntu-cloud-template`)
- Modèles LXC disponibles (ex: `local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst`)

## Configuration
Définir les variables dans `terraform.tfvars` (ou via variables d'env/CLI).

Clés principales :
- API : `proxmox_api_url`, `proxmox_user`, `proxmox_password`, `proxmox_tls_insecure`
- Réseau (optionnel) : `network_config.bridges`
- VMs : `vms` (liste), `vm_defaults`
- Containers : `containers` (liste), `container_defaults`

Exemple minimal (à adapter, ne pas committer de secrets) :
```hcl
proxmox_api_url      = "https://<ip>:8006/api2/json"
proxmox_user         = "root@pam"
proxmox_password     = "changeme"
proxmox_tls_insecure = true

vms = [
  {
    name        = "vm-web-01"
    target_node = "pve1"
    clone       = "ubuntu-cloud-template"
    cores       = 2
    memory      = 4096
    disk_size   = "30G"
    network = {
      model  = "virtio"
      bridge = "vmbr0"
      tag    = null
    }
    ip_config = {
      ip      = "192.168.1.100/24"
      gateway = "192.168.1.1"
    }
    description = "Serveur Web"
    onboot      = true
    agent       = 1
  }
]

containers = [
  {
    vmid        = 236
    hostname    = "prometheus"
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
    ssh_keys    = "ssh-rsa AAAA..."
  }
]

vm_defaults = {
  cores     = 2
  memory    = 2048
  disk_size = "20G"
  onboot    = true
  agent     = 1
}

container_defaults = {
  cores        = 1
  memory       = 512
  swap         = 512
  storage      = "local-lvm"
  rootfs_size  = "8G"
  onboot       = true
  unprivileged = true
  console      = false
}
```

## Commandes usuelles
Dans le répertoire du projet :

```sh
# Initialiser le backend et les providers
terraform init

# Voir le plan
terraform plan

# Appliquer les changements
terraform apply

# Détruire l'infra
terraform destroy
```

## Notes sur les modules
- `modules/dynamic-vms` : crée des `proxmox_vm_qemu` à partir d'un template. Gère IP statique via cloud-init (`ip_config`) ou DHCP.
- `modules/dynamic-containers` : crée des `proxmox_lxc` avec réseau principal `network` et optionnel `network2`. Supporte `ssh_keys` ou `password`.
- `modules/static-network` : uniquement informatif; la création de bridges reste manuelle ou via scripts externes.

## Outputs principaux
- `network_summary` : récap réseau déclaré
- `vms_created`, `vm_count`, `vm_ips`
- `containers_created`, `container_count`, `container_ips`

## Bonnes pratiques
- Garder `terraform.tfstate` hors VCS ou utiliser un backend distant.
- Ne jamais committer `terraform.tfvars` avec des secrets; préférer `.tfvars` locaux ou variables d'environnement.
- Vérifier que les templates Proxmox référencés existent et sont accessibles sur les nodes ciblés.
