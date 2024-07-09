targetScope = 'subscription'

param location string = 'australiaeast'
param operations_subscription_id string = '3ab2b141-c036-4cdc-b4eb-368df9594c7c'
param iaas_resources_resource_group_name string = 'operations_logging'

module maintenance_configuration 'module_maintenance_configuration.bicep' = {
  name: 'event_orch_atp_deviceinfo_managed_identity_deployment'
  scope: resourceGroup(operations_subscription_id, iaas_resources_resource_group_name)
  params: {
    location: location
    resource_name: 'initial-mc'
    reboot_value: 'Never' // Always
    maint_window_duration: '03:55'
    maint_window_recur: '1Month Second Tuesday Offset2'
    maint_window_start_time: '2023-12-09 01:00'
    windows_kb_exclusions: [
      '5031989'
      '5032337'
      '5032336'
      '5037033'
      '5032336'
      '5036609'
      '5037033'
      '5037034'
      '5034119'
      '5032337'
      '5036899'
      '5037034'
    ]
  }
}
