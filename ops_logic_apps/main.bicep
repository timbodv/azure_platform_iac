targetScope = 'subscription'

param location string = 'australiaeast'
param resource_group_name string = 'ops-logic-apps'
// Development
param subscription_id string = '967d672b-7700-45c3-81cc-bfca8da60a25'

module cloud_storage 'module_ops_logic_apps.bicep' = {
  name: '${uniqueString(deployment().name, location)}-ops_logic_apps'
  scope: subscription(subscription_id)
  params: {
    location: location
    resource_group_name: resource_group_name
  }
}
