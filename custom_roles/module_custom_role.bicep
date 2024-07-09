targetScope = 'managementGroup'

param role_name string
param role_description string
param actions array
param data_actions array
param not_actions array
param not_data_actions array

resource custom_role 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(managementGroup().id, role_name)
  properties: {
    assignableScopes: [
      tenantResourceId('Microsoft.Management/managementGroups', managementGroup().name)
    ]
    description: role_description
    permissions: [
      {
        actions: actions
        dataActions: data_actions
        notActions: not_actions
        notDataActions: not_data_actions
      }
    ]
    roleName: role_name
    type: 'CustomRole'
  }
}
