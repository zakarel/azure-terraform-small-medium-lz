# Small/Medium Business landing zone projects

<img src="https://img.shields.io/badge/Azure%20CLI%20-v2.19.1-blue?style=flat-square">   <img src="https://img.shields.io/badge/VSCode%20-v1.53.2-purple?style=flat-square">
<img src="https://img.shields.io/badge/AzureRM%20-v3.84-navy?style=flat-square">
<img src="https://img.shields.io/badge/jq%20-v3.84-darkgreen?style=flat-square">

## Introduction

This repository projects is to provide startups, small, medium businesses with a simple hub and spoke landing zone to get them quicky up and running on Azure. It is relevant where the [enterprise landing zone](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) feels too much.
It built out of project, each with a specific purpose.

## Projects

- smb-landingzonev2 - Small/medium business terraform Azure simple landing zone.
deployment of a main hub with 3 vnet spokes each represent an environment with corresponding network security groups.

- smb-hub-secure - WIP
- smb-ubuntu-vm-deployment - WIP
- smb-aks-deployment - WIP

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See section "Plan" for notes on how to deploy the project on a live system.

### Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Azure Subscription](https://azure.microsoft.com/en-us/pricing/purchase-options/pay-as-you-go/)
- [Terraform package installed](https://developer.hashicorp.com/terraform/install)
- [Azure subscription owner role](https://learn.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles#azure-roles)
- [jq](https://jqlang.github.io/jq/download/)

### Installing

  Cloning the project to you local workstation:

`git clone git@github.com:zakarel/azure-terraform-bp-lz.git`

## Configuration

### Initializing

```bash
cd <PROJECT>
terraform init
```

### Log in to azure

```bash
az login
az account list -o table #Make sure your on the right sub
az account set -s '<SUB>' #Change to different sub
```

### You can add a .tfsvars file with the predefined vars and place it in the current folder

```bash
echo "location = "westus" >> pre.tfsvars
# Make sure it's where the main.tf file is.
```

### Validation

```bash
cd <PROJECT>
terraform fmt #Formatting the indentation/spaces/conf in the tf files
terraform validate #Validating there are no errors in the tf files
```

## Plan

```bash
cd <PROJECT>
terraform plan -out=test1.tfplan
```

### After the interactive var configuration a plan will be saved on the same folder which you can execute with

```bash
terraform apply test1.tfplan
```

## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

- **Tzahi Ariel** - *Initial work* - [zakarel](https://github.com/zakarel)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
