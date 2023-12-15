targetScope = 'subscription'

param location string
param resource_group_name string
param storage_account_name string
param storage_account_type string

resource resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resource_group_name
  location: location
  properties: {}
}

module storage_account 'module_storage_account.bicep' = {
  name: '${uniqueString(deployment().name, location)}-storage_account'
  scope: resourceGroup(resource_group.name)
  params: {
    location: location
    storage_account_name: storage_account_name
    storage_account_type: storage_account_type
  }
}
