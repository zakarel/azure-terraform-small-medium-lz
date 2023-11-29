# Azure Terraform Best Practices Landing Zone

<img src="https://img.shields.io/badge/Azure%20CLI%20-v2.19.1-blue?style=flat-square">   <img src="https://img.shields.io/badge/VSCode%20-v1.53.2-purple?style=flat-square">

## Projects
- 4snetHub-3vnetSpoke - terraform files to deploy a: 4 subnet hub virtual network & 1 subnet 3 virtual network spokes.
- Securing Hub - WIP

## Architectures
- 4snetHub-3vnetSpoke

![4snetHub-3vnetSpoke-Arch.png](/architectures/4snetHub-3vnetSpoke-Arch.png)

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

```
git clone git@github.com:zakarel/Azure-terraform-templates.git
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
