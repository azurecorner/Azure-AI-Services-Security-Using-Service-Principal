
$SecureStringPassword = ConvertTo-SecureString -String 'srv@cognSecu1#13' -AsPlainText -Force

$ServicePrincipalName="ai-srv-app"
$sp = New-AzADServicePrincipal -DisplayName $ServicePrincipalName
$secret = $sp.PasswordCredentials.SecretText
$clientId =$sp.AppId

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

