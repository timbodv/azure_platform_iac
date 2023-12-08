param location string = 'australiaeast'

var recovery_vault_name = 'alz-${uniqueString(subscription().id)}-rv'

resource recovery_vault 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: recovery_vault_name
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    publicNetworkAccess:'Enabled'
  }
}

resource symbolicname 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-01-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  parent: resourceSymbolicName
  eTag: 'string'
  properties: {
    protectedItemsCount: int
    resourceGuardOperationRequests: [
      'string'
    ]
    backupManagementType: 'string'
    // For remaining properties, see ProtectionPolicy objects
  }
}
