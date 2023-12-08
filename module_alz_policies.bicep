targetScope = 'subscription'
param location string = 'australiaeast'

var owner_role_definition_id = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'

var policy_assignment_display_name = 'Application landing zone framework (${subscription().subscriptionId})'
var policy_assignment_name = 'alz_init_asgmt'

var policy_initiative_name = 'alz_initiative'
var policy_initiative_display_name = 'Application landing zone framework'


resource assign_alz_initiative_assignment_owner_role 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, policy_initiative_display_name, owner_role_definition_id)
  properties: {
    description: '${policy_assignment_display_name} remediation account'
    principalId: alz_initiative_assignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', owner_role_definition_id)
  }
}

resource alz_initiative_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policy_assignment_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: policy_assignment_display_name
    enforcementMode: 'Default'
    policyDefinitionId: alz_initiative.id
  }
}

resource alz_initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: policy_initiative_name
  properties: {
    policyType: 'Custom'
    displayName: policy_initiative_display_name

    policyDefinitions: [
      {
        // Configure Azure Defender for servers to be enabled with plan 1
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '85b005b2-95fc-4953-b9cb-f9ee6427c754')
        policyDefinitionReferenceId: 'test_definition'
        parameters: {}
      }
    ]
  }
}
