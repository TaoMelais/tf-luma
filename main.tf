# ============================================
# Infrastructure Proxmox - Main Configuration
# ============================================
# Ce fichier orchestre les modules statique et dynamique

# Module réseau statique
module "static_network" {
  source = "./modules/static-network"
  
  network_config = var.network_config
}

# Module Containers LXC dynamiques
module "dynamic_containers" {
  source = "./modules/dynamic-containers"
  
  containers         = var.containers
  container_defaults = var.container_defaults
  
  # Dépend du réseau statique
  depends_on = [module.static_network]
}
