# TF-Luma — Infrastructure Proxmox / Stack de Monitoring

Infrastructure as Code (Terraform) qui provisionne automatiquement une stack
de **monitoring** sous forme de containers LXC sur un cluster **Proxmox VE**.

## À quoi ça sert

Ce projet déploie, de façon reproductible, 4 containers LXC Debian 13 dédiés à
l'observabilité :

| Container    | VMID | IP             | Rôle                                   |
|--------------|------|----------------|----------------------------------------|
| `Monitoring` | 235  | 172.16.1.55/24 | Tableaux de bord **Grafana**           |
| `Prometheus` | 236  | 172.16.1.56/24 | Collecte de métriques **Prometheus**   |
| `Loki`       | 237  | 172.16.1.57/24 | Agrégation de logs **Loki**            |
| `Promtail`   | 238  | 172.16.1.58/24 | Expéditeur de logs **Promtail**        |

> Terraform ne crée que les **containers** (CPU, RAM, réseau, stockage). Il
> n'installe pas les applicatifs à l'intérieur — c'est une base prête à recevoir
> la stack.

Réseau : tous les containers sont sur le bridge `vmbr1`, VLAN tag `11`,
passerelle `172.16.1.1`, DNS `172.16.1.254`, domaine `luma.securite`.

## Architecture du projet

```
TF-Luma/
├── provider.tf          # Provider telmate/proxmox + connexion API
├── main.tf              # Orchestration des modules
├── variables.tf         # Déclaration des variables d'entrée
├── outputs.tf           # Sorties (IPs, nombre de containers, etc.)
├── terraform.tfvars     # Valeurs concrètes (containers, réseau)  [non versionné]
├── .env                 # Identifiants Proxmox (TF_VAR_*)          [non versionné]
├── .env.example         # Modèle d'identifiants à copier
└── modules/
    ├── static-network/      # Configuration réseau statique (bridges/VLAN)
    └── dynamic-containers/  # Création des containers LXC (boucle for_each)
```

Le module `dynamic-containers` itère sur la liste `containers` (clé = `hostname`)
et crée une ressource `proxmox_lxc` par entrée. C'est cette indexation par
hostname qui permet de cibler un container précis (voir plus bas).

## Prérequis

- [Terraform](https://www.terraform.io/) >= 1.0
- Un accès API à un serveur/cluster **Proxmox VE**
- Le template LXC présent sur le nœud :
  `local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst`

## Configuration

### 1. Identifiants Proxmox (`.env`)

Les login/mot de passe ne sont **pas** dans `terraform.tfvars`. Ils sont fournis
via des variables d'environnement `TF_VAR_*` que Terraform lit automatiquement.

```bash
cp .env.example .env
# Éditer .env avec vos identifiants réels
```

Contenu de `.env` :

```bash
export TF_VAR_proxmox_user='root@pam'
export TF_VAR_proxmox_password='votre_mot_de_passe'
```

Charger ces variables **avant chaque commande** Terraform :

```bash
source .env
```

### 2. Variables non sensibles (`terraform.tfvars`)

L'URL de l'API, l'option TLS et la définition des containers s'y trouvent :

```hcl
proxmox_api_url      = "https://192.168.0.17:8006/api2/json"
proxmox_tls_insecure = true

containers = [ ... ]          # liste des containers à créer
container_defaults = { ... }  # valeurs par défaut (cores, memory, ...)
```

## Construire l'infrastructure

```bash
source .env            # charger les identifiants

terraform init         # initialiser (1re fois ou après ajout de module/provider)
terraform plan         # prévisualiser les changements
terraform apply        # créer toute l'infrastructure
```

`terraform apply` crée les 4 containers et les démarre (`start = true`).

### Construire un seul composant

Utiliser `-target` avec l'adresse de la ressource. Les containers sont indexés
par leur `hostname` :

```bash
# Créer / mettre à jour uniquement le container Grafana
terraform apply -target='module.dynamic_containers.proxmox_lxc.containers["Monitoring"]'

# Uniquement Prometheus
terraform apply -target='module.dynamic_containers.proxmox_lxc.containers["Prometheus"]'
```

## Détruire l'infrastructure

### Tout détruire

```bash
source .env
terraform destroy        # supprime les 4 containers (demande confirmation)
```

### Détruire un seul composant

```bash
# Détruire uniquement Loki
terraform destroy -target='module.dynamic_containers.proxmox_lxc.containers["Loki"]'

# Détruire uniquement Promtail
terraform destroy -target='module.dynamic_containers.proxmox_lxc.containers["Promtail"]'
```

> Alternative sans `-target` : retirer (ou commenter) l'entrée correspondante
> dans la liste `containers` de `terraform.tfvars`, puis lancer
> `terraform apply`. Terraform détruira le container qui n'est plus déclaré.

## Consulter l'état

```bash
terraform output                 # toutes les sorties
terraform output container_ips   # mapping hostname -> IP
terraform state list             # ressources gérées
```

Sorties disponibles : `network_summary`, `containers_created`,
`container_count`, `container_ips`.

## Ajouter un nouveau container

Ajouter un bloc dans la liste `containers` de `terraform.tfvars` (vmid, hostname,
réseau, etc.), puis :

```bash
source .env
terraform plan
terraform apply
```

## Sécurité

- `.env`, `terraform.tfvars` et les fichiers `*.tfstate` sont **exclus de git**
  (voir `.gitignore`) car ils contiennent des données sensibles.
- Ne jamais commiter d'identifiants. Utiliser `.env` pour les secrets.

⚠️ Les identifiants dans l'historique sont purements de test.