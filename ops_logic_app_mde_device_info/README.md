
# Steps

* new logic apps consumption. no az
* enable system assigned managed identity
  * get the app and object ID
* assign application permissions (script below)
* assigned "Monitoring Metrics Publisher" role on resource group to managed identity
* NOTE : the access can take a while to take effect. Personal experience has been at least 30 minutes

~~~~ powershell
# adding application permissions to a managed identity is not available in the GUI
# STEP 1
# look up the "Windows Defender ATP" enterprise application, and the permission we are seeking. The app ID should be consistent, but we need the unique tenant object ids
$defenderAtpAppId = "fc780465-2017-40d4-a0c5-307022471b92"

az ad sp show --id $defenderAtpAppId --query "id"
az ad sp show --id $defenderAtpAppId --query "appRoles[?value=='Machine.Read.All'].[value, id]"

# STEP 2
# using the output from above
$defenderAtpObjectId = "b49d39ef-c327-4969-a56d-5108f9aab09b"
$permissionId = "ea8291d3-4b9a-44b5-bc3a-6cea3026dc79"

# managed identity details
$managedIdentityAppId = "73f54d36-9c2b-4ef8-b03b-7563041e760a"
$managedIdentityObjectId = "9bc0d07a-ff76-43ac-80a0-4eec861994d9"

az rest -m POST -u https://graph.microsoft.com/v1.0/servicePrincipals/$managedIdentityObjectId/appRoleAssignments -b "{""principalId"": ""$managedIdentityObjectId"", ""resourceId"": ""$defenderAtpObjectId"",""appRoleId"": ""$permissionId""}"
~~~~

## References

* <https://learn.microsoft.com/en-us/azure/logic-apps/authenticate-with-managed-identity?tabs=consumption>
* https://laurakokkarinen.com/authenticating-to-azure-ad-protected-apis-with-managed-identity-no-key-vault-required/
* https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/api/machine?view=o365-worldwide

# Helpers

## Execute workflow with authenticated trigger

~~~~ powershell
# the URL to the workflow trigger, without the SAS
$WORKFLOW_HTTP_TRIGGER_URI = "https://prod-07.australiaeast.logic.azure.com/workflows/eac74e0339a54c728630330cddf3f4f1/triggers/manual/paths/invoke?api-version=2016-10-01"

if (-not $token) {
  $token = Get-AzAccessToken
}

$Params = @{
  Method         = "POST"
  Uri            = $WORKFLOW_HTTP_TRIGGER_URI
  Authentication = "Bearer"
  Token          = (ConvertTo-SecureString $($token.Token) -AsPlainText -Force)
}

Invoke-RestMethod @Params -Body '{"message":"test3"}'
~~~~
