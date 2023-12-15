param location string
param logic_app_name string
param managed_identity_id string
param logic_app_properties object

resource logic_app 'Microsoft.Logic/workflows@2019-05-01' = {
  name: '${logic_app_name}-logic'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managed_identity_id}' : {}
    }
  }
  properties: logic_app_properties
}

