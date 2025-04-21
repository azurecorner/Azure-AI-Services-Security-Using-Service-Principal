
curl -X POST "https://cog-srv-002.cognitiveservices.azure.com/language/:analyze-text?api-version=2023-04-01" -H "Content-Type: application/json" -H "Ocp-Apim-Subscription-Key:FyZgHEtSiG5Ws2p4CwA1qSFolF43LAhTe5lgUAaPQuQUUqLQyvPkJQQJ99BDAC5T7U2XJ3w3AAAEACOGqySR" --data-ascii "{'analysisInput':{'documents':[{'id':1,'text':'hello'}]}, 'kind': 'LanguageDetection'}"


$ServicePrincipalName="ai-srv-app"
$sp = New-AzADServicePrincipal -DisplayName $ServicePrincipalName

$sp = Get-AzADServicePrincipal -DisplayName $ServicePrincipalName
$secret = $sp.PasswordCredentials.SecretText
$clientId =$sp.AppId

$objectId = (Get-AzADServicePrincipal -ApplicationId $clientId ).id

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


pip install azure-ai-textanalytics==5.3.0
pip install azure-identity==1.17.1
pip install azure-keyvault-secrets==4.8.0


python TextAnalyticsClient.py