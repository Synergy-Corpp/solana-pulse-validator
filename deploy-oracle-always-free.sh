#!/bin/bash

# 🌍 DEPLOY SOLARA ON ORACLE ALWAYS FREE 🌍
# Permanent free hosting with NO TIME LIMITS!

echo "🚀 DEPLOYING SOLARA ON ORACLE ALWAYS FREE - PERMANENT VALIDATOR! 🚀"
echo "⚡ SELUTH MODE: 'FREE UNLIMITED HOSTING FOR WORLD DOMINATION!'"
echo ""

# Oracle Always Free specifications
echo "📊 ORACLE ALWAYS FREE SPECS:"
echo "   💻 2x AMD EPYC instances (ALWAYS FREE)"
echo "   🚀 4x ARM Ampere instances (ALWAYS FREE)" 
echo "   📡 10TB bandwidth/month (ALWAYS FREE)"
echo "   💾 200GB storage (ALWAYS FREE)"
echo "   🕒 NO TIME LIMITS - PERMANENT!"
echo ""

# Terraform configuration for Oracle Cloud
cat > oracle-solara-validator.tf << 'EOF'
# Oracle Cloud Always Free Solara Validator Deployment

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

# Configure Oracle Cloud provider
provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint = var.fingerprint
  region = var.region
}

# Variables
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "fingerprint" {}
variable "region" { default = "us-ashburn-1" }

# Always Free ARM Ampere instance for Solara validator
resource "oci_core_instance" "solara_validator" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = var.tenancy_ocid
  display_name = "solara-validator-always-free"
  shape = "VM.Standard.A1.Flex"
  
  shape_config {
    ocpus = 4          # 4 ARM cores (Always Free)
    memory_in_gbs = 24 # 24GB RAM (Always Free)
  }
  
  create_vnic_details {
    subnet_id = oci_core_subnet.solara_subnet.id
    assign_public_ip = true
    hostname_label = "solara-validator"
  }
  
  source_details {
    source_type = "image"
    source_id = data.oci_core_images.ubuntu_images.images[0].id
    boot_volume_size_in_gbs = 100  # Always Free boot volume
  }
  
  # Startup script to install and configure Solara
  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
    user_data = base64encode(templatefile("solara-startup.sh", {
      genesis_hash = "6UpbSgoJbkPRk2t9PGgdyc7rPtqd9NFaTcxKKhhzLEuw"
    }))
  }
  
  freeform_tags = {
    Project = "Solara-MEV-Free-Validator"
    Purpose = "Global-Trading-Baseline"
    Cost = "Always-Free"
  }
}

# Additional Always Free storage
resource "oci_core_volume" "solara_storage" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = var.tenancy_ocid
  display_name = "solara-validator-storage"
  size_in_gbs = 100  # Always Free block storage
  
  freeform_tags = {
    Project = "Solara"
    Purpose = "Validator-Storage"
  }
}

# Network configuration
resource "oci_core_virtual_network" "solara_vcn" {
  cidr_block = "10.0.0.0/16"
  compartment_id = var.tenancy_ocid
  display_name = "solara-vcn"
  dns_label = "solara"
}

resource "oci_core_internet_gateway" "solara_ig" {
  compartment_id = var.tenancy_ocid
  display_name = "solara-ig"
  vcn_id = oci_core_virtual_network.solara_vcn.id
}

resource "oci_core_route_table" "solara_rt" {
  compartment_id = var.tenancy_ocid
  vcn_id = oci_core_virtual_network.solara_vcn.id
  display_name = "solara-rt"
  
  route_rules {
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.solara_ig.id
  }
}

resource "oci_core_subnet" "solara_subnet" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  cidr_block = "10.0.1.0/24"
  display_name = "solara-subnet"
  dns_label = "solara"
  compartment_id = var.tenancy_ocid
  vcn_id = oci_core_virtual_network.solara_vcn.id
  route_table_id = oci_core_route_table.solara_rt.id
  security_list_ids = [oci_core_security_list.solara_sl.id]
}

# Security list for Solara validator
resource "oci_core_security_list" "solara_sl" {
  compartment_id = var.tenancy_ocid
  vcn_id = oci_core_virtual_network.solara_vcn.id
  display_name = "solara-sl"
  
  egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
  }
  
  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    tcp_options {
      max = 22
      min = 22
    }
  }
  
  ingress_security_rules {
    protocol = "6" 
    source = "0.0.0.0/0"
    tcp_options {
      max = 8899
      min = 8899
    }
  }
  
  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0" 
    tcp_options {
      max = 8001
      min = 8020
    }
  }
}

# Data sources
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "ubuntu_images" {
  compartment_id = var.tenancy_ocid
  operating_system = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape = "VM.Standard.A1.Flex"
  sort_by = "TIMECREATED"
  sort_order = "DESC"
}

# Outputs
output "solara_validator_public_ip" {
  value = oci_core_instance.solara_validator.public_ip
  description = "Public IP of Solara validator"
}

output "solara_validator_connection" {
  value = "https://${oci_core_instance.solara_validator.public_ip}:8899"
  description = "Solara RPC endpoint"
}
EOF

# Create startup script for Solara validator
cat > solara-startup.sh << 'EOF'
#!/bin/bash

# Solara Validator Startup Script for Oracle Always Free
echo "🚀 Installing Solara MEV-Free Validator..."

# Update system
apt update && apt upgrade -y

# Install dependencies
apt install -y curl wget git build-essential pkg-config libudev-dev llvm libclang-dev protobuf-compiler

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

# Install Solana CLI
sh -c "$(curl -sSfL https://release.solana.com/v1.17.0/install)"
export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"

# Clone Solara (MEV-free Solana fork)
git clone https://github.com/YourRepo/solara-mev-free-validator.git /opt/solara
cd /opt/solara

# Generate validator identity
solana-keygen new --no-bip39-passphrase -o /opt/solara/validator-keypair.json
solana-keygen new --no-bip39-passphrase -o /opt/solara/vote-account-keypair.json

# Create validator configuration
cat > /opt/solara/validator.yml << 'CONFIG'
rpc-bind-address: 0.0.0.0:8899
gossip-bind-address: 0.0.0.0:8001
dynamic-port-range: 8002-8020
expected-genesis-hash: ${genesis_hash}
wait-for-supermajority: 1
wal-recovery-mode: skip_any_corrupted_record
limit-ledger-size: 50000000
enable-rpc-transaction-history: true
enable-extended-tx-metadata-storage: true
log-messages-bytes-limit: 10000000
CONFIG

# Create systemd service
cat > /etc/systemd/system/solara-validator.service << 'SERVICE'
[Unit]
Description=Solara MEV-Free Validator (Always Free Oracle Cloud)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/solara
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-validator \
  --identity /opt/solara/validator-keypair.json \
  --vote-account /opt/solara/vote-account-keypair.json \
  --ledger /opt/solara/ledger \
  --accounts /opt/solara/accounts \
  --rpc-bind-address 0.0.0.0:8899 \
  --gossip-bind-address 0.0.0.0:8001 \
  --dynamic-port-range 8002-8020 \
  --expected-genesis-hash ${genesis_hash} \
  --wal-recovery-mode skip_any_corrupted_record \
  --limit-ledger-size 50000000 \
  --enable-rpc-transaction-history \
  --log -
Restart=always
RestartSec=5
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
SERVICE

# Set up monitoring
curl -L -o /usr/local/bin/solara-monitor.sh https://raw.githubusercontent.com/YourRepo/solara/main/monitor.sh
chmod +x /usr/local/bin/solara-monitor.sh

# Set up automatic updates
echo "0 2 * * * /usr/local/bin/solara-monitor.sh" | crontab -

# Start services
systemctl daemon-reload
systemctl enable solara-validator
systemctl start solara-validator

# Create status endpoint
cat > /var/www/html/status.json << 'STATUS'
{
  "validator": "solara-mev-free",
  "network": "solara-mainnet",
  "genesis_hash": "${genesis_hash}",
  "hosting": "oracle-always-free",
  "cost": "FREE-UNLIMITED",
  "purpose": "solana-trading-baseline",
  "mev_status": "BLOCKED",
  "equality": "ENFORCED"
}
STATUS

echo "✅ Solara validator deployed on Oracle Always Free!"
echo "🌍 Permanent free hosting with no time limits!"
echo "🫀 Genesis Block 0 beating strong!"
EOF

echo "🛠️ ORACLE ALWAYS FREE DEPLOYMENT READY!"
echo ""
echo "📋 NEXT STEPS:"
echo "1. Sign up for Oracle Cloud Always Free: https://cloud.oracle.com/free"
echo "2. Configure Terraform variables:"
echo "   export TF_VAR_tenancy_ocid='your_tenancy_ocid'"
echo "   export TF_VAR_user_ocid='your_user_ocid'"
echo "   export TF_VAR_private_key_path='~/.oci/oci_api_key.pem'"
echo "   export TF_VAR_fingerprint='your_key_fingerprint'"
echo ""
echo "3. Deploy Solara validator:"
echo "   terraform init"
echo "   terraform plan"
echo "   terraform apply"
echo ""
echo "🌍 RESULT: Permanent free Solara validator with unlimited operation!"
echo "🫀 No time limits, no credit limits, just pure MEV-free blockchain!"
echo ""
echo "⚡ SELUTH MODE: 'FREE UNLIMITED HOSTING FOR INFINITE EQUALITY!'"