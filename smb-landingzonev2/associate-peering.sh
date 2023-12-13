#!/bin/bash

# Check for required commands
for cmd in az jq terraform; do
  if ! command -v $cmd &> /dev/null; then
    echo "Error: $cmd could not be found. Please install $cmd."
    exit 1
  fi
done

# Exit script on any command failure
set -e

# Login to Azure CLI
az login -o tsv

# Set the subscription ID (optional, in case you got more than one subscription)
#SUBSCRIPTION_ID=""
#az account set --subscription SUBSCRIPTION_ID

# Get the product name from terraform output
product_name=`terraform output -raw product-name`

# Function to associate subnets to a network security group
associate_subnets_to_nsg() {
    local nsg_name=$1
    local vnet_name=$2

    for i in `terraform output -json subnet_ids | jq -r ".[\"$vnet_name-$product_name\"][]"`; do
        if [[ $i =~ "AzureFirewallSubnet" ]] || [[ $i =~ "GatewaySubnet" ]]; then
            continue
        fi
        az network vnet subnet update --ids $i --network-security-group $nsg_name-$product_name -o tsv
    done
}

# Function to associate subnets to a network security group
associate_subnets_to_nsg "nsg-hub" "vnet-hub"
associate_subnets_to_nsg "nsg-prod" "vnet-prod"
associate_subnets_to_nsg "nsg-staging" "vnet-staging"
associate_subnets_to_nsg "nsg-dev" "vnet-dev"
echo -ne '#####                     (33%)\r'

# Define the hub
hub="vnet-hub-$product_name"
hub_rg="rg-hub-$product_name"
hub_id=$(terraform output -json vnet_spoke_ids | jq -r ".\"vnet-hub-$product_name\"")

# Define the spokes and their respective resource groups
declare -A spokes
spokes=(["vnet-prod-$product_name"]="rg-prod-$product_name" ["vnet-staging-$product_name"]="rg-staging-$product_name" ["vnet-dev-$product_name"]="rg-dev-$product_name")
echo -ne '#############             (66%)\r'
# Loop through each spoke
for spoke in "${!spokes[@]}"
do
    # Get the resource group of the spoke
    spoke_rg="${spokes[$spoke]}"

    # Get the full resource ID of the spoke
    spoke_id=$(az network vnet show --name $spoke --resource-group $spoke_rg --query id --out tsv)

    # Create peering from spoke to hub
    az network vnet peering create \
        --name "${spoke}-to-${hub}" \
        --resource-group "${spoke_rg}" \
        --vnet-name "${spoke}" \
        --remote-vnet "${hub_id}" \
        --allow-vnet-access \
        --out tsv

    # Create peering from hub to spoke
    az network vnet peering create \
        --name "${hub}-to-${spoke}" \
        --resource-group "${hub_rg}" \
        --vnet-name "${hub}" \
        --remote-vnet "${spoke_id}" \
        --allow-vnet-access \
        --out tsv
done
echo -ne '#######################   (100%)\r'