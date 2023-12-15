param location string
param storage_account_name string
param storage_account_type string

resource storage_account 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storage_account_name
  location: location
  sku: {
    name: storage_account_type
  }
  kind: 'StorageV2'
  properties: {}
}
