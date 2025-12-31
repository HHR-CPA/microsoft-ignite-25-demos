#!/bin/bash

# Azure Network Hosting Deployment Script
# This script deploys the network infrastructure for Microsoft Ignite 2025 demos

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
RESOURCE_GROUP_NAME=""
LOCATION="eastus2"
ENVIRONMENT="dev"

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if Azure CLI is installed
check_azure_cli() {
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI is not installed. Please install it from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        exit 1
    fi
    print_info "Azure CLI is installed"
}

# Function to check if logged in to Azure
check_azure_login() {
    if ! az account show &> /dev/null; then
        print_error "Not logged in to Azure. Please run 'az login' first"
        exit 1
    fi
    print_info "Logged in to Azure"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -g|--resource-group)
            RESOURCE_GROUP_NAME="$2"
            shift 2
            ;;
        -l|--location)
            LOCATION="$2"
            shift 2
            ;;
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -g, --resource-group    Name of the resource group (required)"
            echo "  -l, --location          Azure region (default: eastus2)"
            echo "  -e, --environment       Environment name (default: dev)"
            echo "  -h, --help              Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Validate required parameters
if [ -z "$RESOURCE_GROUP_NAME" ]; then
    print_error "Resource group name is required. Use -g or --resource-group to specify it"
    exit 1
fi

# Main deployment
print_info "Starting Azure Network Hosting deployment..."
print_info "Resource Group: $RESOURCE_GROUP_NAME"
print_info "Location: $LOCATION"
print_info "Environment: $ENVIRONMENT"

# Check prerequisites
check_azure_cli
check_azure_login

# Create resource group if it doesn't exist
print_info "Checking resource group..."
if ! az group show --name "$RESOURCE_GROUP_NAME" &> /dev/null; then
    print_info "Creating resource group $RESOURCE_GROUP_NAME..."
    az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION"
else
    print_info "Resource group $RESOURCE_GROUP_NAME already exists"
fi

# Deploy infrastructure
print_info "Deploying network infrastructure..."
DEPLOYMENT_NAME="ignite-network-$(date +%Y%m%d-%H%M%S)"

az deployment group create \
    --name "$DEPLOYMENT_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "$(dirname "$0")/main.bicep" \
    --parameters "$(dirname "$0")/main.parameters.json" \
    --parameters location="$LOCATION" environmentName="$ENVIRONMENT" \
    --verbose

# Get deployment outputs
print_info "Deployment completed successfully!"
print_info "Getting deployment outputs..."

az deployment group show \
    --name "$DEPLOYMENT_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --query properties.outputs \
    --output table

print_info "Azure Network Hosting setup completed!"
print_info "You can now configure your applications to use the deployed network infrastructure"
