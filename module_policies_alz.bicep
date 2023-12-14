targetScope = 'subscription'
param location string = 'australiaeast'

param default_vm_backup_policy_id string

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
        // Configure backup on virtual machines without a given tag to an existing recovery services vault in the same location
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '09ce66bc-1220-4153-8104-e3f51c936913')
        policyDefinitionReferenceId: 'configure_backup_when_not_tagged'
        parameters: {
          backupPolicyId: {
            value: default_vm_backup_policy_id
          }
          vaultLocation: {
            value: location
          }
          exclusionTagName: {
            value: 'default_backup_policy_exclude'
          }
          exclusionTagValue: {
            value: [
              'true'
            ]
          }
        }
      }
    ]
  }
}
