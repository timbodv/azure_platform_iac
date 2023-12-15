targetScope = 'subscription'

param location string = 'australiaeast'
param storage_account_name string = 'cloudshell${uniqueString(subscription().id)}'
param storage_account_type string = 'Standard_LRS'
param resource_group_name string = 'cloud-shell-storage'
// Development
param subscription_id string = '967d672b-7700-45c3-81cc-bfca8da60a25'

module cloud_storage 'module_cloud_storage.bicep' = {
  name: '${uniqueString(deployment().name, location)}-cloud_storage'
  scope: subscription(subscription_id)
  params: {
    location: location
    resource_group_name: resource_group_name
    storage_account_name: storage_account_name
    storage_account_type: storage_account_type
  }
}
