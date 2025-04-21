param location string = resourceGroup().location
param tenantId string = subscription().tenantId
param keyVaultName string 
param keyVaultSkuName string 
param ServicePrincipalAndUserPolicy array
// @description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
// param objectId string

// @description('Specifies the service principal ID of the Azure Active Directory application that should be used for authenticating requests to the key vault.')
// param servicePrincipalClientId string 

// @description('Specifies the permissions to keys in the vault. Valid values are: all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge.')
// param keysPermissions array = [
//   'list'
// ]

// @description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
// param secretsPermissions array = [
//   'list'
// ]

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

