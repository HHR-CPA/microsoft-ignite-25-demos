# Azure Network Hosting Infrastructure

This directory contains the Infrastructure as Code (IaC) for setting up Azure network hosting for the Microsoft Ignite 2025 demos.

## Overview

The infrastructure includes:

- **Virtual Network (VNet)**: A dedicated virtual network with three subnets
  - AI Services Subnet: For Azure AI and Cognitive Services
  - App Services Subnet: For Azure App Services and web applications
  - Private Endpoints Subnet: For secure private connectivity

- **Network Security Groups (NSGs)**: Security rules for each subnet to control inbound and outbound traffic

- **Service Endpoints**: Configured for Azure Cognitive Services and Storage

- **Private Endpoint Support**: Enabled for secure, private connectivity to Azure services

## Prerequisites

Before deploying the infrastructure, ensure you have:

1. **Azure CLI** installed ([Installation Guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
2. **Azure subscription** with appropriate permissions to create resources
3. **Logged in to Azure** via `az login`

Optional:
- **Azure Developer CLI (azd)** for streamlined deployments ([Installation Guide](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd))

## Deployment Options

### Option 1: Using Deployment Scripts (Recommended)

#### For Linux/macOS:

```bash
# Navigate to the infra directory
cd infra

# Run the deployment script
./deploy.sh -g <resource-group-name> -l <location> -e <environment>

# Example:
./deploy.sh -g rg-ignite-demos -l eastus2 -e dev
```

#### For Windows (PowerShell):

```powershell
# Navigate to the infra directory
cd infra

# Run the deployment script
.\deploy.ps1 -ResourceGroupName <resource-group-name> -Location <location> -Environment <environment>

# Example:
.\deploy.ps1 -ResourceGroupName rg-ignite-demos -Location eastus2 -Environment dev
```

### Option 2: Using Azure CLI Directly

```bash
# Create resource group
az group create --name <resource-group-name> --location <location>

# Deploy the Bicep template
az deployment group create \
  --name ignite-network-deployment \
  --resource-group <resource-group-name> \
  --template-file main.bicep \
  --parameters main.parameters.json
```

### Option 3: Using Azure Developer CLI (azd)

```bash
# From the repository root
azd init

# Provision the infrastructure
azd provision
```

## Configuration

### Parameters

You can customize the deployment by modifying `main.parameters.json` or passing parameters directly:

| Parameter | Description | Default Value |
|-----------|-------------|---------------|
| `location` | Azure region for deployment | `eastus2` |
| `environmentName` | Environment name (dev, test, prod) | `dev` |
| `vnetAddressPrefix` | Virtual Network address space | `10.0.0.0/16` |
| `aiServicesSubnetPrefix` | AI Services subnet CIDR | `10.0.1.0/24` |
| `appServicesSubnetPrefix` | App Services subnet CIDR | `10.0.2.0/24` |
| `privateEndpointsSubnetPrefix` | Private Endpoints subnet CIDR | `10.0.3.0/24` |

### Environment Variables

The deployment integrates with the `.env` file in the repository root. Ensure your `.env` file is configured with:

```env
AZURE_SUBSCRIPTION_ID=<your-subscription-id>
AZURE_LOCATION=<your-location>
```

## Network Architecture

```
Virtual Network (10.0.0.0/16)
├── AI Services Subnet (10.0.1.0/24)
│   ├── Network Security Group
│   ├── Service Endpoints: CognitiveServices, Storage
│   └── Private Endpoint support enabled
├── App Services Subnet (10.0.2.0/24)
│   ├── Network Security Group
│   ├── Delegation: Microsoft.Web/serverFarms
│   └── HTTPS/HTTP access allowed
└── Private Endpoints Subnet (10.0.3.0/24)
    ├── Network Security Group
    └── Private connectivity for Azure services
```

## Security

The infrastructure implements security best practices:

- **Network Segmentation**: Separate subnets for different service types
- **Network Security Groups**: Configured with least-privilege access rules
- **Service Endpoints**: Secure connectivity to Azure PaaS services
- **Private Endpoints**: Support for private connectivity without internet exposure
- **Deny All Default**: Explicit deny rules for unauthorized traffic

## Outputs

After successful deployment, the following outputs are available:

- `vnetId`: Resource ID of the Virtual Network
- `vnetName`: Name of the Virtual Network
- `aiServicesSubnetId`: Resource ID of the AI Services subnet
- `appServicesSubnetId`: Resource ID of the App Services subnet
- `privateEndpointsSubnetId`: Resource ID of the Private Endpoints subnet

## Cleanup

To delete the infrastructure:

```bash
# Delete the resource group and all resources
az group delete --name <resource-group-name> --yes --no-wait
```

## Troubleshooting

### Common Issues

1. **Insufficient permissions**: Ensure your account has Contributor or Owner role on the subscription
2. **Quota limits**: Check that your subscription has available quota for the region
3. **Address space conflicts**: Ensure the VNet address space doesn't conflict with existing networks

### Validation

Validate the Bicep template before deployment:

```bash
az deployment group validate \
  --resource-group <resource-group-name> \
  --template-file main.bicep \
  --parameters main.parameters.json
```

## Next Steps

After deploying the network infrastructure:

1. Configure Azure AI services to use the AI Services subnet
2. Deploy web applications to the App Services subnet
3. Set up private endpoints for secure connectivity
4. Update the `.env` file with the network resource IDs

## Resources

- [Azure Virtual Networks Documentation](https://docs.microsoft.com/en-us/azure/virtual-network/)
- [Azure Network Security Groups](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
- [Azure Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/)
