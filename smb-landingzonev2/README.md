# SMB/Startups Landing Zone v2

<img src="https://img.shields.io/badge/Azure%20CLI%20-v2.19.1-blue?style=flat-square"> <img src="https://img.shields.io/badge/VSCode%20-v1.53.2-purple?style=flat-square">
<img src="https://img.shields.io/badge/AzureRM%20-v3.84-navy?style=flat-square">
<img src="https://img.shields.io/badge/jq%20-v3.84-darkgreen?style=flat-square">

This repository contains the SMB Landing Zone, a tailored solution for small businesses and startups in the industry. The SMB Landing Zone provides an Azure landing zone to get you quickly deploy and manage your cloud resources.

![SMB-architecture-v2.png](/architectures/SMB-architecture-v2.png)
created with Excalidraw.com
## Features

- **Scalable Architecture**: The SMB Landing Zone is designed to scale with your business needs, allowing you to easily add or remove resources as required.

- **Provides a good starting point**: The Landing zone architecture is built small to support bigger scales with minimum complexity.

- **Security and Compliance**: The landing zone follows industry best practices for security and compliance, ensuring that your infrastructure meets the necessary standards.

- **Automation**: The deployment process is automated using Terraform and shell scripts, enabling you to quickly provision and manage your resources.

- **Flexability**: By performing `terraform destroy` you can delete the entire landing zone and undeploy it quickly.

- **Cost Optimization**: The landing zone includes cost optimization strategies to help you optimize your cloud spend and maximize your return on investment. Also, resources created by this landing zone doesn't cost any money. (not included traffic from Azure and between spokes - hub)

## Getting Started

To get started with the SMB Landing Zone, follow these steps:

1. Clone this repository to your local machine.

2. Install Terraform and ensure it is added to your system's PATH.

3. Create an [app registraion in Azure](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/walkthrough-register-app-azure-active-directory) and copy the client ID, tenant ID and subscription ID to the [provider.tf](provider.tf) file. Don't forget to uncomment those lines and save.

4. [Grant](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal?tabs=delegate-condition) the app registration you just created an owner role on the subscription.

5. Run `terraform init` to initialize the Terraform environment.

6. Run `terraform plan` to review the planned changes.

7. Run `terraform apply` to deploy the SMB Landing Zone.
    - Create 4 resource groups. Each represent an environment.
    - Deploy 4 vnets: hub and 3 spokes each representing an environment.
    - Create and auto assign subnets for each of the vnets as shown in the diagram.
    - Create Network security groups for those subnets created with basic security rules.

8. Run `./associate-peering.sh` to associate the NSGs to  each of the subnets created and peer the spoke vnets to the hub. ** make sure the script has exec permissions on the client: `chmod +x associate-peering.sh`.
    - Associate each NSG created to the relevant subnet.
    - Peering each spokes vnet created to the hub vnet.

** Consider creating a Virtual Private Network and attach it to the GatewaySubnet in the Hub vnet and creating Azure firewall to associate with the AzureFirewallSubnet also for enhanced network security and secured access to private resources.

## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

* **Tzahi Ariel** - *Initial work* - [zakarel](https://github.com/zakarel)

## License

This project is licensed under the [MIT License](./LICENSE).
