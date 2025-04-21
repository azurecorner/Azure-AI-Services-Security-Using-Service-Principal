using './main.bicep'
param keyVaultName  = 'data-kv-ai-srv-001'  
param keyVaultSkuName  = 'standard'

// param objectId  = '7abf4c5b-9638-4ec4-b830-ede0a8031b25'
// param servicePrincipalClientId='d2456c10-a741-4e64-be33-1ac2088ad58b' // $clientId =$sp.AppId
// param keysPermissionsUser  = [
//   'list','get','create','import','delete','backup','restore','recover','purge'
// ]

// param secretsPermissionsUser  = [
//   'list','get','set','delete','backup','restore','recover','purge'
// ]


// param keysPermissionsServicePrincipal  = [
//   'list','get'
// ]

// param secretsPermissionsServicePrincipal  = [
//   'list','get'
// ]


param cognitiveServiceName = 'cog-srv-001' 

param cognitiveServiceSkuName  = 'S0'


param ServicePrincipalAndUserPolicy = [
  {
    objectId: '7abf4c5b-9638-4ec4-b830-ede0a8031b25'
 
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
    objectId: '011f96f2-5232-4674-ba67-bff3f35f2230'
   
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

