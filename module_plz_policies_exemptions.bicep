targetScope = 'resourceGroup'

param assignment_id string

// resource virtual_machine 'Microsoft.Compute/virtualMachines@2022-11-01' existing = {
//   name: 'edge-02-vm'
//   scope: resourceGroup('8e9d95eb-7ef8-4c08-a817-b44fa8655224', 'plz-edge')
// }

resource cloud_security_benchmark_initiative_assignment_exemption 'Microsoft.Authorization/policyExemptions@2022-07-01-preview' = {
  name: 'ExemptNetworkApplianceFromIpForwardingCheck'
  //scope: resourceId('' '/subscriptions/8e9d95eb-7ef8-4c08-a817-b44fa8655224/resourceGroups/plz-edge/providers/Microsoft.Network/networkInterfaces/edge-02-vm-nic-01')
  //scope: resourceGroup('8e9d95eb-7ef8-4c08-a817-b44fa8655224', 'plz-edge')
  // /resourceGroups/plz-edge/providers/Microsoft.Network/networkInterfaces/edge-02-vm-nic-01'')
  
  properties: {
    //assignmentScopeValidation: 'string'
    description: 'Enabled to support connectivity to private cloud'
    displayName: 'Exemption for IP forwarding on edge-02'
    exemptionCategory: 'Mitigated'
    //expiresOn: 'string'
    //metadata: any()
    policyAssignmentId: assignment_id
    policyDefinitionReferenceIds: [
      'disableIPForwardingMonitoring'
    ]
  }
}