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

#disable-next-line BCP081
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
