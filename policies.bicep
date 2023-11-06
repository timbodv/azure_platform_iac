targetScope = 'managementGroup'
param location string = 'australiaeast'

// VARIABLES
var configure_defender_for_servers_with_subplan = json(loadTextContent('./policy_definitions/92cd0485-f6de-4a85-b699-1d44c92fa18e.json'))
//var security_admin_role_definition_id = 'fb1c8493-542b-48eb-b624-b4c8fea62acd'
//var contributor_role_definition_id = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
//var sql_security_manager_role_definition_id = '056cd41c-7e88-42e1-933e-88ba6a50c9c3'
var owner_role_definition_id = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'

var ms_cloud_security_benchmark_initiative_assignment_name = 'mscsb_init_asgmt'
var defender_logging_initiative_assignment_name = 'dfc_log_init_asgmt'
var defender_initiative_assignment_name = 'dfc_init_asgmt'
var defender_initiative_name = 'defender_initiative'

resource assign_defender_initiative_assignment_owner_role 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managementGroup().id, defender_initiative_assignment_name, owner_role_definition_id)
  scope: managementGroup()
  properties: {
    description: 'Defender for Cloud policy assignment remediation account'
    principalId: defender_initiative_assignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', owner_role_definition_id)
  }
}

resource assign_defender_logging_initiative_assignment_owner_role 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managementGroup().id, defender_logging_initiative_assignment_name, owner_role_definition_id)
  scope: managementGroup()
  properties: {
    description: 'Defender for Cloud AMA pipeline policy assignment remediation account'
    principalId: defender_logging_initiative_assignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', owner_role_definition_id)
  }
}

resource configure_defender_for_servers_with_subplan_policy_definition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: '92cd0485-f6de-4a85-b699-1d44c92fa18e'
  properties: configure_defender_for_servers_with_subplan.properties
}

resource defender_initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: defender_initiative_name
  properties: {
    policyType: 'Custom'
    displayName: 'Defender for Cloud features'

    policyDefinitions: [
      {
        // Configure Azure Defender for servers to be enabled with plan 1
        policyDefinitionId: configure_defender_for_servers_with_subplan_policy_definition.id
        policyDefinitionReferenceId: 'enable_defender_for_servers_plan_one'
        parameters: {}
      }
      // Configure Defender for Databases (all)
      {
        // Configure Azure Defender for Azure SQL database to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'b99b73e7-074b-4089-9395-b7236f094491')
        policyDefinitionReferenceId: 'enable_defender_for_databases_mssql'
        parameters: {}
      }
      {
        // Configure Azure Defender for SQL servers on machines to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '50ea7265-7d8c-429e-9a7d-ca1f410191c3')
        policyDefinitionReferenceId: 'enable_defender_for_databases_mssql_server'
        parameters: {}
      }
      {
        // Configure Azure Defender for open-source relational databases to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '44433aa3-7ec2-4002-93ea-65c65ff0310a')
        policyDefinitionReferenceId: 'enable_defender_for_databases_oss'
        parameters: {}
      }
      {
        // Configure Microsoft Defender for Azure Cosmos DB to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '82bf5b87-728b-4a74-ba4d-6123845cf542')
        policyDefinitionReferenceId: 'enable_defender_for_databases_cosmos'
        parameters: {}
      }
      {
        // Configure Azure Defender to be enabled on SQL managed instances
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'c5a62eb0-c65a-4220-8a4d-f70dd4ca95dd')
        policyDefinitionReferenceId: 'configure_defender_for_databases_mssql_mi'
        parameters: {}
      }
      {
        // Configure Microsoft Defender for SQL to be enabled on Synapse workspaces
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '951c1558-50a5-4ca3-abb6-a93e3e2367a6')
        policyDefinitionReferenceId: 'configure_defender_for_databases_synapse'
        parameters: {}
      }
      {
        // Configure Azure Defender to be enabled on SQL servers
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '36d49e87-48c4-4f2e-beed-ba4ed02b71f5')
        policyDefinitionReferenceId: 'configure_defender_for_databases_mssql'
        parameters: {}
      }
      {
        // Configure Advanced Threat Protection to be enabled on Azure database for MySQL servers
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '80ed5239-4122-41ed-b54a-6f1fa7552816')
        policyDefinitionReferenceId: 'configure_defender_for_databases_mysql'
        parameters: {}
      }
      {
        // Configure Advanced Threat Protection to be enabled on Azure database for PostgreSQL servers
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'db048e65-913c-49f9-bb5f-1084184671d3')
        policyDefinitionReferenceId: 'configure_defender_for_databases_postgresql'
        parameters: {}
      }
      {
        // Configure Advanced Threat Protection to be enabled on Azure database for MariaDB servers
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'a6cf7411-da9e-49e2-aec0-cba0250eaf8c')
        policyDefinitionReferenceId: 'configure_defender_for_databases_mariadb'
        parameters: {}
      }
      {
        // Configure Azure Defender for App Service to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'b40e7bcd-a1e5-47fe-b9cf-2f534d0bfb7d')
        policyDefinitionReferenceId: 'enable_defender_for_app_service'
        parameters: {}
      }
      {
        // Configure Azure Defender for DNS to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '2370a3c1-4a25-4283-a91a-c9c1a145fb2f')
        policyDefinitionReferenceId: 'enable_defender_for_dns'
        parameters: {}
      }
      {
        // Configure Azure Defender for Key Vaults to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '1f725891-01c0-420a-9059-4fa46cb770b7')
        policyDefinitionReferenceId: 'enable_defender_for_key_vault'
        parameters: {}
      }
      {
        // Configure Azure Defender for Resource Manager to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'b7021b2b-08fd-4dc0-9de7-3c6ece09faf9')
        policyDefinitionReferenceId: 'enable_defender_for_azurerm'
        parameters: {}
      }
      {
        // Configure Microsoft Defender for Containers to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'c9ddb292-b203-4738-aead-18e2716e858f')
        policyDefinitionReferenceId: 'enable_defender_for_containers'
        parameters: {}
      }
      {
        // Configure Microsoft Defender for Storage to be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'cfdc5972-75b3-4418-8ae1-7f5c36839390')
        policyDefinitionReferenceId: 'enable_defender_for_storage'
        parameters: {}
      }
      {
        // Configure Microsoft Defender for APIs should be enabled
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'e54d2be9-5f2e-4d65-98e4-4f0e670b23d6')
        policyDefinitionReferenceId: 'enable_defender_for_api'
        parameters: {
          effect: {
            value: 'Disabled'
          }
        }
      }
    ]
  }
}

resource defender_initiative_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: defender_initiative_assignment_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Defender for Cloud features'
    enforcementMode: 'Default'
    policyDefinitionId: defender_initiative.id
  }
}

resource cloud_security_benchmark_initiative_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: ms_cloud_security_benchmark_initiative_assignment_name
  location: location
  // identity: {
  //   type: 'SystemAssigned'
  // }
  properties: {
    displayName: 'Microsoft cloud security benchmark'
    enforcementMode: 'Default'
    policyDefinitionId: tenantResourceId('Microsoft.Authorization/policySetDefinitions', '1f3afdf9-d0c9-4c3d-847f-89da613e70a8')
  }
}

// Configure machines to create the user-defined Microsoft Defender for Cloud pipeline using Azure Monitor Agent
resource defender_logging_initiative_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: defender_logging_initiative_assignment_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Defender for Cloud AMA pipeline'
    enforcementMode: 'Default'
    policyDefinitionId: tenantResourceId('Microsoft.Authorization/policySetDefinitions', '500ab3a2-f1bd-4a5a-8e47-3e09d9a294c3')
    parameters: {
      workspaceRegion: {
        value: location
      }
      userWorkspaceResourceId: {
        value: '/subscriptions/8e9d95eb-7ef8-4c08-a817-b44fa8655224/resourcegroups/iaas-core-management/providers/microsoft.operationalinsights/workspaces/security-logs-la'
      }
      bringYourOwnUserAssignedManagedIdentity: {
        value: false
      }
      // userAssignedManagedIdentityName
      // userAssignedManagedIdentityResourceGroup
    }
  }
}
