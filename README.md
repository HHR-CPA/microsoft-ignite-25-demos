# Microsoft Ignite 2025 Demos

This repository contains all the demos from Microsoft Ignite 2025, organized by topic.

## Quick Start

New to the project? See the [Quick Start Guide](QUICKSTART.md) for fast deployment instructions.

## Setup

Before running the demos, you'll need to configure your Azure environment:

### 1. Azure Network Hosting Infrastructure

Deploy the network infrastructure to Azure:

```bash
# Navigate to the infrastructure directory
cd infra

# Deploy using the deployment script (Linux/macOS)
./deploy.sh -g <resource-group-name> -l eastus2 -e dev

# Or using PowerShell (Windows)
.\deploy.ps1 -ResourceGroupName <resource-group-name> -Location eastus2 -Environment dev
```

For detailed infrastructure documentation, see [infra/README.md](infra/README.md).

### 2. Environment Configuration

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. The `.env.example` file contains pre-configured values for the Microsoft Ignite 2025 demo environment. If you need to use different Azure resources, update the values in your `.env` file accordingly.

## Topics

Each folder in this repository represents a different topic area:

- **AI Observability** - AI Observability demos
- **AI Search** - AI Search demos
- **Agent Service** - Agent Service demos
- **Azure AI Foundry Agents** - Azure AI Foundry agent demos
- **Foundry Agent Service** - Foundry Agent Service demos
- **Foundry Local** - Foundry Local demos
- **Foundry Models** - Foundry Models demos
- **Foundry Tools** - Foundry Tools demos
- **The AI App and Agent Factory** - Azure AI Foundry: The AI App & Agent Factory demos

Explore each folder to find specific demos and examples.