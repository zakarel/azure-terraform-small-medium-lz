# Small/Medium Business landing zone v2

<img src="https://img.shields.io/badge/Azure%20CLI%20-v2.19.1-blue?style=flat-square">   <img src="https://img.shields.io/badge/VSCode%20-v1.53.2-purple?style=flat-square">
<img src="https://img.shields.io/badge/AzureRM%20-v3.84-navy?style=flat-square">

## Introduction
This repository projects is to provide startups/small/medium businesses with a simple hub and spoke landing zone where the enterprise landing zone doesn't fit

## Projects
- smb-landingzonev2 - Small/medium business terraform Azure simple landing zone.
deployment of a main hub with 3 vnet spokes each represent an environment with corresponding network security groups.
- smb-hub-secure - WIP

## Architectures
- SMB-architecture-v2.png

![SMB-architecture-v2.png](/architectures/SMB-architecture-v2.png)

- Securing Hub - WIP

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

- Azure CLI
- Azure Subscription
- Terraform package installed
- Sufficient Cloud permissions

### Installing

1. Cloning the project to you local workstation:

```bash
git clone git@github.com:zakarel/azure-terraform-bp-lz.git
```

## Configuration
1. Initializing
```
cd <PROJECT>
terraform init
```
2. Log in to azure
```
az login
az account list -o table #Make sure your on the right sub
az account set -s '<SUB>' #Change to different sub
```
3. You can add a .tfsvars file with the predefined vars and place it in the current folder.
```
echo "location = "westus" >> pre.tfsvars
# Make sure it's where the main.tf file is.
```

## Validation
```
cd <PROJECT>
terraform fmt #Formatting the indentation/spaces/conf in the tf files
terraform validate #Validating there are no errors in the tf files
```
## Plan
```
cd <PROJECT>
terraform plan -out=test1.tfplan
```
After the interactive var configuration a plan will be saved on the same folder which you can execute with
```
terraform apply test1.tfplan
```

## Authors

* **Tzahi Ariel** - *Initial work* - [zakarel](https://github.com/zakarel)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
