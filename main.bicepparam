using './main.bicep'
param keyVaultName  = 'data-kv-ai-srv-001'  
param keyVaultSkuName  = 'standard'

param objectId  = '7abf4c5b-9638-4ec4-b830-ede0a8031b25'
param servicePrincipalClientId='2934e340-ed81-48ce-afc8-38ee1b0fdc06' // $clientId =$sp.AppId
param keysPermissions  = [
  'list','get','create','import','delete','backup','restore','recover','purge'
]

param secretsPermissions  = [
  'list','get','set','delete','backup','restore','recover','purge'
]


param cognitiveServiceName = 'cog-srv-001' 



param cognitiveServiceSkuName  = 'S0'
