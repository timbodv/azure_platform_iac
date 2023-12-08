targetScope = 'managementGroup'
//param location string = 'australiaeast'

// VARIABLES
var log_analytics_table_reader_custom_role_name = 'Log Analytics Table Reader'

// https://learn.microsoft.com/en-us/azure/azure-monitor/logs/manage-access?tabs=portal#set-table-level-read-access
resource log_analytics_table_reader_custom_role 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(managementGroup().id, log_analytics_table_reader_custom_role_name)
  properties: {
    assignableScopes: [
      tenantResourceId('Microsoft.Management/managementGroups', managementGroup().name)
    ]
    description: 'Grants users read access to specific table data in a Log Analytics workspace'
    permissions: [
      {
        actions: [
          'Microsoft.OperationalInsights/workspaces/read'
          'Microsoft.OperationalInsights/workspaces/query/read'
          'Microsoft.OperationalInsights/workspaces/analytics/query/action'
          'Microsoft.OperationalInsights/workspaces/search/action'
        ]
        dataActions: []
        notActions: [
          'Microsoft.OperationalInsights/workspaces/sharedKeys/read'
        ]
        notDataActions: []
      }
    ]
    roleName: log_analytics_table_reader_custom_role_name
    type: 'CustomRole'
  }
}
