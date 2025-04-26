param location string = resourceGroup().location
param tenantId string = subscription().tenantId
param keyVaultName string 
param keyVaultSkuName string 
param ServicePrincipalAndUserPolicy array


@description('That name is the name of our application. It has to be unique.Type a name followed by your resource group name. (<name>-<resourceGroupName>)')
param cognitiveServiceName string 

@allowed([
  'S0'
])
param cognitiveServiceSkuName string = 'S0'


module keyvault './keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    keyVaultName: keyVaultName
    skuName: keyVaultSkuName
    tenantId: tenantId
   ServicePrincipalAndUserPolicy : ServicePrincipalAndUserPolicy
    
   }
}


module aiservice './cognitiveServices.bicep' = {
  name: 'cognitiveServices'
  params: {
    location: location
    cognitiveServiceName: cognitiveServiceName
    cognitiveServiceSkuName: cognitiveServiceSkuName
    keyVaultName: keyVaultName
  }
  dependsOn: [
    keyvault
  ]
}

