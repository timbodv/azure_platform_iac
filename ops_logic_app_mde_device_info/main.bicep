targetScope = 'subscription'

param location string = 'australiaeast'
var la_subscription_id = '8e9d95eb-7ef8-4c08-a817-b44fa8655224'
var la_resource_group_name = 'plz-shared-resources'
var data_collector_endpoint_name = 'plz-ops-tnjcuy5buzybs-dce'
var log_analytics_workspace_name = 'plz-ops-tnjcuy5buzybs-log'

var ops_mgmt_messages_table_columns = [
  {
    name: 'TimeGenerated'
    type: 'datetime'
    description: 'The time at which the data was generated'
  }
  {
    name: 'Level'
    type: 'string'
    description: 'The severity value of the message'
  }
  {
    name: 'Message'
    type: 'string'
    description: 'The message from the resource'
  }
  {
    name: 'ResourceName'
    type: 'string'
    description: 'An identifier for the resource that sent the message'
  }
  {
    name: 'MessageSource'
    type: 'string'
    description: 'The system or solution behind resource that created the message'
  }
]

var ops_mgmt_messages_stream_columns = [
  {
    name: 'timeStamp'
    type: 'datetime'
  }
  {
    name: 'Level'
    type: 'string'
  }
  {
    name: 'Message'
    type: 'string'
  }
  {
    name: 'ResourceName'
    type: 'string'
  }
  {
    name: 'MessageSource'
    type: 'string'
  }
]

module custom_ops_mgmt_messages_table 'module_la_custom_tables.bicep' = {
  name: 'deploy_custom_ops_mgmt_messages_tables'
  scope: resourceGroup(la_subscription_id, la_resource_group_name)
  params: {
    location: location
    log_analytics_workspace_name: log_analytics_workspace_name
    data_collector_endpoint_name: data_collector_endpoint_name

    data_collection_rule_name: 'ops-mgmt-message'
    custom_table_name: 'OpsMgmtMessages'
    table_columns: ops_mgmt_messages_table_columns
    stream_columns: ops_mgmt_messages_stream_columns
    transform_kql: 'source\n| extend TimeGenerated = todatetime(timeStamp)\n| project-away timeStamp'
  }
}

// "id": "19b477e4d87e7ce08a2c9593eda180bd21bab19d",
// "computerDnsName": "expw22sql01.lab.devriesitc.local",
// "firstSeen": "2023-04-26T03:28:52.1477595Z",
// "lastSeen": "2023-09-10T11:47:33.3464319Z",
// "osPlatform": "WindowsServer2022",
// "osVersion": null,
// "version": "21H2",
// "lastIpAddress": "192.168.228.108",
// "lastExternalIpAddress": "124.170.17.220",
// "agentVersion": "10.8040.20348.524",
// "osBuild": 20348,
// "healthStatus": "Inactive",
// "onboardingStatus": "Onboarded",

var mde_device_info_table_columns = [
  {
    name: 'TimeGenerated'
    type: 'datetime'
    description: 'The time at which the data was generated'
  }
  {
    name: 'ComputerDnsName'
    type: 'string'
    //description: ''
  }
  {
    name: 'MdeDeviceId'
    type: 'string'
    //description: 'The time at which the data was generated'
  }
  {
    name: 'FirstSeen'
    type: 'datetime'
    //description: 'The time at which the data was generated'
  }
  {
    name: 'LastSeen'
    type: 'datetime'
    //description: 'The time at which the data was generated'
  }
  {
    name: 'OsPlatform'
    type: 'string'
    //description: 'The message from the resource'
  }
  {
    name: 'Version'
    type: 'string'
    //description: 'An identifier for the resource that sent the message'
  }
  {
    name: 'OsVersion'
    type: 'string'
    //description: 'The system or solution behind resource that created the message'
  }
  {
    name: 'LastExternalIpAddress'
    type: 'string'
    //description: 'The system or solution behind resource that created the message'
  }
  {
    name: 'LastIpAddress'
    type: 'string'
    //description: 'The system or solution behind resource that created the message'
  }
  {
    name: 'AgentVersion'
    type: 'string'
    //description: 'The system or solution behind resource that created the message'
  }
  {
    name: 'OsBuild'
    type: 'string'
    //description: 'The system or solution behind resource that created the message'
  }
  {
    name: 'HealthStatus'
    type: 'string'
    //description: 'The system or solution behind resource that created the message'
  }
  {
    name: 'OnboardingStatus'
    type: 'string'
    //description: 'The system or solution behind resource that created the message'
  }
]

var mde_device_info_stream_columns = [
  {
    name: 'computerDnsName'
    type: 'string'
  }
  {
    name: 'mdeDeviceId'
    type: 'string'
  }
  {
    name: 'firstSeen'
    type: 'datetime'
  }
  {
    name: 'lastSeen'
    type: 'datetime'
  }
  {
    name: 'osPlatform'
    type: 'string'
  }
  {
    name: 'version'
    type: 'string'
  }
  {
    name: 'osVersion'
    type: 'string'
  }
  {
    name: 'lastExternalIpAddress'
    type: 'string'
  }
  {
    name: 'lastIpAddress'
    type: 'string'
  }
  {
    name: 'agentVersion'
    type: 'string'
  }
  {
    name: 'osBuild'
    type: 'string'
  }
  {
    name: 'healthStatus'
    type: 'string'
  }
  {
    name: 'onboardingStatus'
    type: 'string'
  }
]

module custom_mde_device_info_table 'module_la_custom_tables.bicep' = {
  name: 'deploy_custom_mde_device_info_table'
  scope: resourceGroup(la_subscription_id, la_resource_group_name)
  params: {
    location: location
    log_analytics_workspace_name: log_analytics_workspace_name
    data_collector_endpoint_name: data_collector_endpoint_name

    data_collection_rule_name: 'mde-device-info'
    custom_table_name: 'MdeDeviceInfo'
    table_columns: mde_device_info_table_columns
    stream_columns: mde_device_info_stream_columns
    transform_kql: 'source\n| extend TimeGenerated = now(), AgentVersion = agentVersion, MdeDeviceId = mdeDeviceId, ComputerDnsName = computerDnsName, FirstSeen = firstSeen, HealthStatus = healthStatus, LastExternalIpAddress = lastExternalIpAddress, LastIpAddress = lastIpAddress, LastSeen = lastSeen, OnboardingStatus = onboardingStatus, OsBuild = osBuild, OsPlatform = osPlatform, OsVersion = osVersion, Version = version\n| project-away agentVersion, mdeDeviceId, computerDnsName, firstSeen, healthStatus, lastExternalIpAddress, lastIpAddress, lastSeen, onboardingStatus, osBuild, osPlatform, osVersion, version'
    //transform_kql: 'source\n| extend TimeGenerated = now()'
  }
}

var server_list_table_columns = [
  {
    name: 'TimeGenerated'
    type: 'datetime'
    description: 'The time at which the data was generated'
  }
  {
    name: 'ComputerName'
    type: 'string'
    //description: 'The severity value of the message'
  }
  {
    name: 'State'
    type: 'string'
    //description: 'The message from the resource'
  }
  {
    name: 'SupportTeam'
    type: 'string'
    //description: 'An identifier for the resource that sent the message'
  }
  {
    name: 'SystemCode'
    type: 'string'
    //description: 'The system or solution behind resource that created the message'
  }
]

var server_list_stream_columns = [
  {
    name: 'computerName'
    type: 'string'
  }
  {
    name: 'state'
    type: 'string'
  }
  {
    name: 'supportTeam'
    type: 'string'
  }
  {
    name: 'systemCode'
    type: 'string'
  }
]

module custom_server_list_table 'module_la_custom_tables.bicep' = {
  name: 'deploy_custom_server_list_table'
  scope: resourceGroup(la_subscription_id, la_resource_group_name)
  params: {
    location: location
    log_analytics_workspace_name: log_analytics_workspace_name
    data_collector_endpoint_name: data_collector_endpoint_name

    data_collection_rule_name: 'server-list'
    custom_table_name: 'ServerList'
    table_columns: server_list_table_columns
    stream_columns: server_list_stream_columns
    transform_kql: 'source\n| extend TimeGenerated = now(), ComputerName = computerName, State = state, SupportTeam = supportTeam, SystemCode = systemCode\n| project-away computerName,state,supportTeam,systemCode'
  }
}


var logic_apps_resource_group_name = 'ops-logic-apps'
var logic_apps_subscription_id = '967d672b-7700-45c3-81cc-bfca8da60a25'
var managed_identity_name = 'ops-ingest-to-log-mi'

module managed_identity 'module_managed_identity.bicep' = {
  name: '${uniqueString(deployment().name, location)}-managed_identity'
  scope: resourceGroup(logic_apps_subscription_id, logic_apps_resource_group_name)
  params: {
    location: location
    managed_identity_name: managed_identity_name
  }
}

// module start_vm_logic_app 'module_logic_app.bicep' = {
//   name: '${uniqueString(deployment().name, location)}-import_server_list'
//   scope: resourceGroup(logic_apps_subscription_id, logic_apps_resource_group_name)
//   params: {
//     location: location
//     logic_app_name: 'import-server-list-la'
//     logic_app_properties: loadJsonContent('blank_logic_app.json')
//     managed_identity_id: managed_identity.outputs.managed_identity_id
//   }
// }
