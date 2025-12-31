# Quick Start Guide: Azure Network Hosting Setup

This guide will help you quickly deploy the Azure network hosting infrastructure for Microsoft Ignite 2025 demos.

## Prerequisites

- Azure subscription with Contributor or Owner permissions
- Azure CLI installed ([Download here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))

## Quick Deployment Steps

### 1. Login to Azure

```bash
az login
```

### 2. Set your subscription (if you have multiple)

```bash
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### 3. Deploy the infrastructure

Choose your operating system:

#### Linux/macOS

```bash
cd infra
./deploy.sh -g rg-ignite-demos -l eastus2 -e dev
```

#### Windows (PowerShell)

```powershell
cd infra
.\deploy.ps1 -ResourceGroupName rg-ignite-demos -Location eastus2 -Environment dev
```

### 4. Verify the deployment

After deployment completes, you'll see output with the network resource IDs:

```
vnetId              : /subscriptions/.../virtualNetworks/vnet-ignite-dev-eastus2
vnetName            : vnet-ignite-dev-eastus2
aiServicesSubnetId  : /subscriptions/.../subnets/snet-ai-services
appServicesSubnetId : /subscriptions/.../subnets/snet-app-services
privateEndpointsSubnetId : /subscriptions/.../subnets/snet-private-endpoints
```

## What Gets Deployed?

- **Virtual Network**: A secure network (10.0.0.0/16) with three subnets
- **Network Security Groups**: Security rules for each subnet
- **Service Endpoints**: For Azure AI and Storage services
- **Private Endpoint Support**: For secure, private connectivity

## Estimated Costs

The network infrastructure has minimal costs:
- Virtual Network: Free
- Network Security Groups: Free
- Data transfer: Charges may apply based on usage

## Next Steps

1. Update your `.env` file with the deployed resource IDs
2. Configure your demo applications to use the network subnets
3. Deploy Azure AI services into the AI Services subnet
4. Deploy web applications into the App Services subnet

## Customization

To customize the deployment, edit `infra/main.parameters.json`:

```json
{
  "parameters": {
    "location": { "value": "westus" },           // Change region
    "environmentName": { "value": "prod" },      // Change environment
    "vnetAddressPrefix": { "value": "10.1.0.0/16" }  // Change IP range
  }
}
```

## Troubleshooting

### Common Issues

**Error: Insufficient permissions**
- Solution: Ensure you have Contributor or Owner role on the subscription

**Error: Address space conflicts**
- Solution: Change the `vnetAddressPrefix` in parameters to a different IP range

**Error: Resource provider not registered**
- Solution: Register the required providers:
  ```bash
  az provider register --namespace Microsoft.Network
  az provider register --namespace Microsoft.CognitiveServices
  ```

### Getting Help

- Check the detailed [Infrastructure README](infra/README.md)
- Review the [Azure Virtual Networks documentation](https://docs.microsoft.com/en-us/azure/virtual-network/)
- Open an issue in this repository

## Cleanup

To remove all deployed resources:

```bash
az group delete --name rg-ignite-demos --yes --no-wait
```

This will delete the resource group and all resources within it.
