# Azure Network Hosting Deployment Script (PowerShell)
# This script deploys the network infrastructure for Microsoft Ignite 2025 demos

param(
    [Parameter(Mandatory=$true, HelpMessage="Name of the resource group")]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false, HelpMessage="Azure region")]
    [string]$Location = "eastus2",
    
    [Parameter(Mandatory=$false, HelpMessage="Environment name")]
    [string]$Environment = "dev"
)

# Function to write colored output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-ErrorMessage {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-WarningMessage {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

# Function to check if Azure CLI is installed
function Test-AzureCli {
    try {
        $null = az --version
        Write-Info "Azure CLI is installed"
        return $true
    }
    catch {
        Write-ErrorMessage "Azure CLI is not installed. Please install it from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        return $false
    }
}

# Function to check if logged in to Azure
function Test-AzureLogin {
    try {
        $null = az account show 2>$null
        Write-Info "Logged in to Azure"
        return $true
    }
    catch {
        Write-ErrorMessage "Not logged in to Azure. Please run 'az login' first"
        return $false
    }
}

# Main deployment
Write-Info "Starting Azure Network Hosting deployment..."
Write-Info "Resource Group: $ResourceGroupName"
Write-Info "Location: $Location"
Write-Info "Environment: $Environment"

# Check prerequisites
if (-not (Test-AzureCli)) {
    exit 1
}

if (-not (Test-AzureLogin)) {
    exit 1
}

# Create resource group if it doesn't exist
Write-Info "Checking resource group..."
$rgExists = az group exists --name $ResourceGroupName
if ($rgExists -eq "false") {
    Write-Info "Creating resource group $ResourceGroupName..."
    az group create --name $ResourceGroupName --location $Location
}
else {
    Write-Info "Resource group $ResourceGroupName already exists"
}

# Deploy infrastructure
Write-Info "Deploying network infrastructure..."
$deploymentName = "ignite-network-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateFile = Join-Path $scriptPath "main.bicep"
$parametersFile = Join-Path $scriptPath "main.parameters.json"

az deployment group create `
    --name $deploymentName `
    --resource-group $ResourceGroupName `
    --template-file $templateFile `
    --parameters $parametersFile `
    --parameters location=$Location environmentName=$Environment `
    --verbose

if ($LASTEXITCODE -eq 0) {
    # Get deployment outputs
    Write-Info "Deployment completed successfully!"
    Write-Info "Getting deployment outputs..."
    
    az deployment group show `
        --name $deploymentName `
        --resource-group $ResourceGroupName `
        --query properties.outputs `
        --output table
    
    Write-Info "Azure Network Hosting setup completed!"
    Write-Info "You can now configure your applications to use the deployed network infrastructure"
}
else {
    Write-ErrorMessage "Deployment failed. Please check the error messages above."
    exit 1
}
