# Securing Azure AI Services Using a Service Principal

Azure AI services help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box, prebuilt, and customizable APIs and models.  
Example applications include natural language processing for conversations, search, monitoring, translation, speech, vision, and decision-making.

For more information about Azure AI services, see the official documentation:  
 [What are Azure AI Services?](https://learn.microsoft.com/en-us/azure/ai-services/what-are-ai-services)

---

## Project Overview

### 1. Formal and professional

Security is a fundamental aspect of any application. Developers must implement proper access controls to ensure that Azure AI services are available only to authorized users.  
Access to Azure AI services is generally managed through **authentication keys**, issued during resource creation.

---

### 2. Clear and concise

Securing access to Azure AI services is crucial. Developers should make sure that only trusted users can interact with these resources, typically using **authentication keys** created when the service is deployed.

---

### 3. Friendly and accessible

When building applications, keeping your Azure AI services secure is a must.  
Access is usually managed with **authentication keys** that are generated when you first set up your service.

In this project, we secure access to an Azure AI Service using a **Service Principal** and **Azure Key Vault**.

---

## Steps Overview

1. **Create an Azure AI Service (Multi-Service Account)**  
   - Set up a multi-service Azure AI resource via the [Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_ProjectOxford/CognitiveServicesHub/~/AllInOne) or the [Azure AI Services page](https://azure.microsoft.com/en-us/products/ai-services/).

2. **Create an Azure Key Vault**  
   - Securely store the Azure AI Service key in Key Vault as a secret.

3. **Create a Service Principal**  
   - Register an application in Azure Active Directory.
   - Grant the Service Principal `Get` and `List` permissions on the Key Vault secrets using Access Policies.

4. **Create a `.env` file**  
   - Store the following environment variables:
     - `AI_SERVICE_ENDPOINT` – The endpoint URL of the Azure AI Service.
     - `KEY_VAULT` – The name of the Azure Key Vault.
     - `TENANT_ID` – The Azure Active Directory tenant ID.
     - `APP_ID` – The client ID (application ID) of the Service Principal.
     - `APP_PASSWORD` – The client secret (password) of the Service Principal.

5. **Develop a Python Application**  
   - Authenticate to Azure using the Service Principal.
   - Retrieve the AI Service key from the Key Vault.
   - Interact securely with the Azure AI Service.

---

## PowerShell Script for Resource Group and Deployment

### Set the subscription context

You use `Get-AzContext` to retrieve the current Azure subscription and set it for further commands using `az account set`.

### Create a resource group

You define a resource group named `"RG-AZURE-AI-SECURITY-001"` in the `"francecentral"` region with `New-AzResourceGroup`.

### Create an application registration

The following command creates a **new Azure Active Directory Service Principal** with the display name `"ai-srv-app"`:

```powershell
$ServicePrincipalName="ai-srv-app"
$sp = New-AzADServicePrincipal -DisplayName $ServicePrincipalName
$sp = Get-AzADServicePrincipal -DisplayName $ServicePrincipalName
$secret = $sp.PasswordCredentials.SecretText
$clientId =$sp.AppId
```

### Deploy the Bicep template

You use `New-AzResourceGroupDeployment` to deploy your **Bicep template** (`main.bicep`) with the associated parameters (`main.bicepparam`) to the previously created resource group. The `-DeploymentDebugLogLevel All` ensures you get detailed logs of the deployment.

```powershell
$subscriptionId= (Get-AzContext).Subscription.id
az account set --subscription $subscriptionId
$resourceGroupName="RG-AZURE-AI-SECURITY-001"
New-AzResourceGroup -Name $resourceGroupName -Location "francecentral"


New-AzResourceGroupDeployment `
    -Name "azure-ai-service-security-001" `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile "main.bicep" `
    -TemplateParameterFile "main.bicepparam" `
    -DeploymentDebugLogLevel All

```

## Python Package Installation

### Install Azure SDK packages

You install the required Azure Python SDK packages:

- `azure-ai-textanalytics==5.3.0`: For interacting with the Azure AI Text Analytics service.
- `azure-identity==1.17.1`: For authentication.
- `azure-keyvault-secrets==4.8.0`: For interacting with Azure Key Vault secrets.

### Run Python Script

The command `python TextAnalyticsClient.py` runs your Python script (`TextAnalyticsClient.py`), which should use the Azure SDKs to interact with the Azure services.

This code loads environment variables from a `.env` file and assigns them to Python variables.

1. **`load_dotenv()`**:
   - This function comes from the `python-dotenv` library.
   - It loads environment variables from a `.env` file into the environment, making them accessible to the Python script.

2. **`ai_endpoint = os.getenv('AI_SERVICE_ENDPOINT')`**:
   - `os.getenv()` retrieves the value of the environment variable `AI_SERVICE_ENDPOINT`.
   - This variable should contain the endpoint URL of the Azure AI service.
   - The value is assigned to the variable `ai_endpoint` in Python.

3. **`key_vault_name = os.getenv('KEY_VAULT')`**:
   - This retrieves the environment variable `KEY_VAULT`, which should contain the name of the Azure Key Vault.
   - The value is assigned to the variable `key_vault_name`.

4. **`app_tenant = os.getenv('TENANT_ID')`**:
   - This retrieves the environment variable `TENANT_ID`, which contains the tenant ID of the Azure Active Directory.
   - The value is assigned to the variable `app_tenant`.

5. **`app_id = os.getenv('APP_ID')`**:
   - This retrieves the environment variable `APP_ID`, which contains the client ID (or Application ID) of the Azure Service Principal.
   - The value is assigned to the variable `app_id`.

6. **`app_password = os.getenv('APP_PASSWORD')`**:
   - This retrieves the environment variable `APP_PASSWORD`, which contains the client secret (password) for the Azure Service Principal.
   - The value is assigned to the variable `app_password`.

### Purpose

- The purpose of this code is to load sensitive information, like API endpoints, credentials, and configuration data, from a `.env` file into environment variables, making it easy to securely manage and access these settings in your Python application.

### Prerequisite

- Make sure the `python-dotenv` package is installed using the following command

  ```bash
  pip install python-dotenv
  ```

```python
 # Get Configuration Settings
        load_dotenv()
        ai_endpoint = os.getenv('AI_SERVICE_ENDPOINT')
        key_vault_name = os.getenv('KEY_VAULT')
        app_tenant = os.getenv('TENANT_ID')
        app_id = os.getenv('APP_ID')
        app_password = os.getenv('APP_PASSWORD')
```

```python
pip install azure-ai-textanalytics==5.3.0
pip install azure-identity==1.17.1
pip install azure-keyvault-secrets==4.8.0


python TextAnalyticsClient.py

```

## Bicep code

```bicep
@description('Specifies the name of the key vault.')
param keyVaultName string

@description('Specifies the Azure location where the key vault should be created.')
param location string 

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.')
param tenantId string = subscription().tenantId

param ServicePrincipalAndUserPolicy array

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

resource kv 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: keyVaultName
  location: location
  properties: {

    tenantId: tenantId

    accessPolicies: [
      for policy in ServicePrincipalAndUserPolicy: {
        objectId: policy.objectId 
        tenantId: tenantId
        permissions: {
          keys: policy.keys
          secrets: policy.secrets
        }
      }
    ]
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

output location string = location
output name string = kv.name
output resourceGroupName string = resourceGroup().name
output resourceId string = kv.id

@description('That name is the name of our application. It has to be unique.Type a name followed by your resource group name. (<name>-<resourceGroupName>)')
param cognitiveServiceName string 

@description('Location for all resources.')
param location string 

@allowed([
  'S0'
])
param cognitiveServiceSkuName string 

param accounts_cog_srv_002_name string = 'cog-srv-002'

param keyVaultName string 

#disable-next-line BCP081
resource openAIAccount 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: cognitiveServiceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: cognitiveServiceSkuName
  }
  kind: 'AIServices'
  
  properties: {
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
    }
    disableLocalAuth: false

  }
}


resource accounts_cog_srv_002_name_resource 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: accounts_cog_srv_002_name
  location: location
  sku: {
    name: cognitiveServiceSkuName
  }
  kind: 'CognitiveServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    apiProperties: {}
    customSubDomainName: accounts_cog_srv_002_name
    networkAcls: {
      defaultAction: 'Allow'
     
    }
    publicNetworkAccess: 'Enabled'
  }
}


resource secret 'Microsoft.KeyVault/vaults/secrets@2024-11-01' = {
  name: '${keyVaultName}/AI-Services-Key'
  
    properties: {
      value: accounts_cog_srv_002_name_resource.listKeys().key1
    }
  }

```
