targetScope = 'resourceGroup'

param assignment_id string
param exemption_name string
param exemption_description string
param exemption_display_name string
param exemption_definitions array

resource policy_exemption 'Microsoft.Authorization/policyExemptions@2022-07-01-preview' = {
  name: exemption_name
  //scope: resourceId('' '/subscriptions/8e9d95eb-7ef8-4c08-a817-b44fa8655224/resourceGroups/plz-edge/providers/Microsoft.Network/networkInterfaces/edge-02-vm-nic-01')
  //scope: resourceGroup('8e9d95eb-7ef8-4c08-a817-b44fa8655224', 'plz-edge')
  // /resourceGroups/plz-edge/providers/Microsoft.Network/networkInterfaces/edge-02-vm-nic-01'')
  
  properties: {
    //assignmentScopeValidation: 'string'
    description: exemption_description
    displayName: exemption_display_name
    exemptionCategory: 'Mitigated'
    //expiresOn: 'string'
    //metadata: any()
    policyAssignmentId: assignment_id
    policyDefinitionReferenceIds: exemption_definitions
  }
}
