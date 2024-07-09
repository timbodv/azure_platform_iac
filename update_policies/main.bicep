targetScope = 'subscription'
param location string = 'australiaeast'

var owner_role_definition_id = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'

var policy_assignment_display_name = 'BCC - IaaS - Common initative on ${subscription().subscriptionId}'
var policy_assignment_name = 'bcc_iaas_init_asgmt'

var policy_initiative_name = 'bcc_iaas_initiative'
var policy_initiative_display_name = 'BCC - IaaS - Common initative'

param operations_subscription_id string = '967d672b-7700-45c3-81cc-bfca8da60a25'
param iaas_resources_resource_group_name string = 'ops-arc'

module maintenance_configuration_two 'module_maintenance_configuration.bicep' = {
  name: 'maintenance_configuration_two_deployment'
  scope: resourceGroup(operations_subscription_id, iaas_resources_resource_group_name)
  params: {
    location: location
    resource_name: 'maintenance_configuration_two'
    reboot_value: 'Always' // Always
    maint_window_duration: '01:30'
    maint_window_recur: '1Month Second Tuesday'
    maint_window_start_time: '2023-12-09 18:00'
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

module maintenance_configuration_one 'module_maintenance_configuration.bicep' = {
  name: 'maintenance_configuration_one_deployment'
  scope: resourceGroup(operations_subscription_id, iaas_resources_resource_group_name)
  params: {
    location: location
    resource_name: 'maintenance_configuration_one'
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

resource assign_alz_initiative_assignment_owner_role 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, policy_initiative_display_name, owner_role_definition_id)
  properties: {
    description: '${policy_assignment_display_name} remediation account'
    principalId: initiative_assignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', owner_role_definition_id)
  }
}

resource initiative_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policy_assignment_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: policy_assignment_display_name
    enforcementMode: 'Default'
    policyDefinitionId: initiative.id
  }
}

resource initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: policy_initiative_name
  properties: {
    policyType: 'Custom'
    displayName: policy_initiative_display_name
    policyDefinitionGroups: [
      {
        displayName: 'Patch management'
        name: 'patch_management'
      }
      {
        displayName: 'Endpoint protection'
        name: 'edr_protection'
      }
    ]
    policyDefinitions: [
      // Configure periodic checking for missing system updates on azure virtual machines
      {
        policyDefinitionId: tenantResourceId(
          'Microsoft.Authorization/policyDefinitions',
          '59efceea-0c96-497e-a4a1-4eb2290dac15'
        )
        policyDefinitionReferenceId: 'config_periodic_update_checks_windows'
        groupNames: [
          'patch_management'
        ]
        parameters: {
          assessmentMode: {
            value: 'AutomaticByPlatform'
          }
          osType: {
            value: 'Windows'
          }
          tagValues: {
            value: {
              iaas_enable_aum_pc: 'true'
            }
          }
          tagOperator: {
            value: 'All'
          }
        }
      }
      // Configure periodic checking for missing system updates on azure virtual machines
      {
        policyDefinitionId: tenantResourceId(
          'Microsoft.Authorization/policyDefinitions',
          '59efceea-0c96-497e-a4a1-4eb2290dac15'
        )
        policyDefinitionReferenceId: 'config_periodic_update_checks_linux'
        groupNames: [
          'patch_management'
        ]
        parameters: {
          assessmentMode: {
            value: 'AutomaticByPlatform'
          }
          osType: {
            value: 'Linux'
          }
          tagValues: {
            value: {
              iaas_enable_aum_pc: 'true'
            }
          }
          tagOperator: {
            value: 'All'
          }
        }
      }
      // Configure periodic checking for missing system updates on azure Arc-enabled servers
      {
        policyDefinitionId: tenantResourceId(
          'Microsoft.Authorization/policyDefinitions',
          'bfea026e-043f-4ff4-9d1b-bf301ca7ff46'
        )
        policyDefinitionReferenceId: 'config_periodic_update_checks_windows_arc'
        groupNames: [
          'patch_management'
        ]
        parameters: {
          assessmentMode: {
            value: 'AutomaticByPlatform'
          }
          osType: {
            value: 'Windows'
          }
          tagValues: {
            value: {
              iaas_enable_aum_pc: 'true'
            }
          }
          tagOperator: {
            value: 'All'
          }
        }
      }
      // Configure periodic checking for missing system updates on azure Arc-enabled servers
      {
        policyDefinitionId: tenantResourceId(
          'Microsoft.Authorization/policyDefinitions',
          'bfea026e-043f-4ff4-9d1b-bf301ca7ff46'
        )
        policyDefinitionReferenceId: 'config_periodic_update_checks_linux_arc'
        groupNames: [
          'patch_management'
        ]
        parameters: {
          assessmentMode: {
            value: 'AutomaticByPlatform'
          }
          osType: {
            value: 'Linux'
          }
          tagValues: {
            value: {
              iaas_enable_aum_pc: 'true'
            }
          }
          tagOperator: {
            value: 'All'
          }
        }
      }
      {
        // Schedule recurring updates using Azure Update Manager
        policyDefinitionId: tenantResourceId(
          'Microsoft.Authorization/policyDefinitions',
          'ba0df93e-e4ac-479a-aac2-134bbae39a1a'
        )
        policyDefinitionReferenceId: 'schedule_update_installation_mc_one'
        groupNames: [
          'patch_management'
        ]
        parameters: {
          maintenanceConfigurationResourceId: {
            value: maintenance_configuration_one.outputs.maintenance_configuration_id
          }
          tagValues: {
            value: [
              {
                key: 'iaas_aum_mc'
                value: 'iaas_aum_mc_one'
              }
            ]
          }
        }
      }
      {
        // Schedule recurring updates using Azure Update Manager
        policyDefinitionId: tenantResourceId(
          'Microsoft.Authorization/policyDefinitions',
          'ba0df93e-e4ac-479a-aac2-134bbae39a1a'
        )
        policyDefinitionReferenceId: 'schedule_update_installation_mc_two'
        groupNames: [
          'patch_management'
        ]
        parameters: {
          maintenanceConfigurationResourceId: {
            value: maintenance_configuration_two.outputs.maintenance_configuration_id
          }
          tagValues: {
            value: [
              {
                key: 'iaas_aum_mc'
                value: 'iaas_aum_mc_two'
              }
            ]
          }
        }
      }
    ]
  }
}
