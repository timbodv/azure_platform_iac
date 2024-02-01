targetScope = 'subscription'

param location string = 'australiaeast'

var logic_apps_resource_group_name = 'ops-logic-apps'
var logic_apps_subscription_id = '967d672b-7700-45c3-81cc-bfca8da60a25'

module managed_identity_atp_machine_read 'module_managed_identity.bicep' = {
  name: '${uniqueString(deployment().name, location)}-managed_identity_atp_machine_read'
  scope: resourceGroup(logic_apps_subscription_id, logic_apps_resource_group_name)
  params: {
    location: location
    managed_identity_name: 'event-orch-atp-machine-read'
  }
}

module managed_identity_metric_publisher 'module_managed_identity.bicep' = {
  name: '${uniqueString(deployment().name, location)}-managed_identity_metric_publisher'
  scope: resourceGroup(logic_apps_subscription_id, logic_apps_resource_group_name)
  params: {
    location: location
    managed_identity_name: 'event-orch-metric-publisher'
  }
}
