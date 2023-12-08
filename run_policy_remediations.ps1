
# (Get-AzPolicySetDefinition -ManagementGroupName lab-mg -Name plz_initiative).Properties.PolicyDefinitions | % { Write-Host """$($_.policyDefinitionReferenceId)""," }

$Params = @{
  PolicyAssignmentId = "/providers/Microsoft.Management/managementGroups/lab-mg/providers/Microsoft.Authorization/policyAssignments/plz_init_asgmt"
  ManagementGroupName = "lab-mg"

}

"add_system_managed_identity",
"configure_tls_windows",
"deploy_guest_configuration_linux",
"deploy_guest_configuration_windows",
"configure_vtpm",
"deploy_guest_attestation_linux",
"deploy_guest_attestation_windows",
"configure_update_check_arc",
"configure_update_check_az" | % { Start-AzPolicyRemediation @Params -PolicyDefinitionReferenceId $_ -Name "remediate_$($_)" -AsJob }
