targetScope = 'managementGroup'

module deployment_contributor_custom_role 'module_custom_role.bicep' = {
  name: 'deployment_contributor_custom_role'
  params: {
    role_name: 'CR - Deployment contributer'
    role_description: 'Grants users the ability to read and write deployments. A user will still require access to the write the resources themselves.'
    actions: [
      'Microsoft.Resources/deployments/read'
      'Microsoft.Resources/deployments/write'
      'Microsoft.Resources/deployments/cancel/action'
      'Microsoft.Resources/deployments/validate/action'
      'Microsoft.Resources/deployments/whatIf/action'
      'Microsoft.Resources/deployments/exportTemplate/action'
      'Microsoft.Resources/deployments/operations/read'
      'Microsoft.Resources/deployments/operationstatuses/read'
    ]
    data_actions: []
    not_actions: []
    not_data_actions: []
  }
}

module patching_operator_custom_role 'module_custom_role.bicep' = {
  name: 'patching_operator_custom_role'
  params: {
    role_name: 'CR - Patching operator'
    role_description: 'Grants users the ability to read Azure VM and Arc-enabled server machine configurations and assignments, and patch assessment results. Also allows the user to initiate a patch assessment, and perform a one-off patch installation.'
    actions: [
      'Microsoft.HybridCompute/machines/patchAssessmentResults/read'
      'Microsoft.HybridCompute/machines/patchAssessmentResults/*/read'
      'Microsoft.HybridCompute/machines/patchInstallationResults/read'
      'Microsoft.HybridCompute/machines/patchInstallationResults/*/read'
      'Microsoft.HybridCompute/machines/read'
      'Microsoft.HybridCompute/machines/assessPatches/action'
      'Microsoft.HybridCompute/machines/installPatches/action'
      'Microsoft.Compute/virtualMachines/read'
      'Microsoft.Compute/virtualMachines/patchAssessmentResults/*/read'
      'Microsoft.Compute/virtualMachines/patchInstallationResults/read'
      'Microsoft.Compute/virtualMachines/patchInstallationResults/*/read'
      'Microsoft.Compute/virtualMachines/assessPatches/action'
      'Microsoft.Compute/virtualMachines/installPatches/action'
      'Microsoft.Compute/virtualMachines/cancelPatchInstallation/action'
      'Microsoft.Maintenance/maintenanceConfigurations/read'
      'Microsoft.Maintenance/configurationAssignments/read'
      'Microsoft.Maintenance/configurationAssignments/maintenanceScope/InGuestPatch/read'
      'Microsoft.Maintenance/maintenanceConfigurations/maintenanceScope/InGuestPatch/read'
    ]
    data_actions: []
    not_actions: []
    not_data_actions: []
  }
}

module patching_reader_custom_role 'module_custom_role.bicep' = {
  name: 'patching_reader_custom_role'
  params: {
    role_name: 'CR - Patching reader'
    role_description: 'Grants users the ability to read Azure VM and Arc-enabled server machine configurations and assignments, and patch assessment results. Also allows the user to initiate a patch assessment.'
    actions: [
      'Microsoft.HybridCompute/machines/patchAssessmentResults/read'
      'Microsoft.HybridCompute/machines/patchAssessmentResults/*/read'
      'Microsoft.HybridCompute/machines/patchInstallationResults/read'
      'Microsoft.HybridCompute/machines/patchInstallationResults/*/read'
      'Microsoft.HybridCompute/machines/read'
      'Microsoft.HybridCompute/machines/assessPatches/action'
      'Microsoft.Compute/virtualMachines/patchAssessmentResults/*/read'
      'Microsoft.Compute/virtualMachines/patchInstallationResults/read'
      'Microsoft.Compute/virtualMachines/patchInstallationResults/*/read'
      'Microsoft.Compute/virtualMachines/read'
      'Microsoft.Compute/virtualMachines/assessPatches/action'
      'Microsoft.Maintenance/maintenanceConfigurations/read'
      'Microsoft.Maintenance/configurationAssignments/read'
      'Microsoft.Maintenance/configurationAssignments/maintenanceScope/InGuestPatch/read'
      'Microsoft.Maintenance/maintenanceConfigurations/maintenanceScope/InGuestPatch/read'
    ]
    data_actions: []
    not_actions: []
    not_data_actions: []
  }
}
