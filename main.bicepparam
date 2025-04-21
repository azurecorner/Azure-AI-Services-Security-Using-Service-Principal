using './main.bicep'
param keyVaultName  = 'data-kv-ai-srv-001'  
param keyVaultSkuName  = 'standard'


param cognitiveServiceName = 'cog-srv-001' 

param cognitiveServiceSkuName  = 'S0'


param ServicePrincipalAndUserPolicy = [
  {
    objectId: '' // Admin User  Object ID
 
    keys: [
      'list'
      'get'
      'create'
      'import'
      'delete'
      'backup'
      'restore'
      'recover'
      'purge'
    ]
    secrets: [
      'list'
      'get'
      'set'
      'delete'
      'backup'
      'restore'
      'recover'
      'purge'
    ]
  }
  {
    objectId: '' // Service Principal Object ID
   
    keys: [
      'list'
      'get'
    ]
    secrets: [
      'list'
      'get'
    ]
  }
]

