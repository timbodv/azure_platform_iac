
# (Get-AzPolicySetDefinition -ManagementGroupName lab-mg -Name plz_initiative).Properties.PolicyDefinitions | % { Write-Host """$($_.policyDefinitionReferenceId)""," }
# (Get-AzPolicySetDefinition -SubscriptionId "8e9d95eb-7ef8-4c08-a817-b44fa8655224" -Name alz_initiative).Properties.PolicyDefinitions | % { Write-Host """$($_.policyDefinitionReferenceId)""," }

# Development     967d672b-7700-45c3-81cc-bfca8da60a25
# Shared Services 8e9d95eb-7ef8-4c08-a817-b44fa8655224

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
"configure_update_check_az"

"schedule_update_installation" | % { Start-AzPolicyRemediation @Params -PolicyDefinitionReferenceId $_ -Name "remediate_$($_)" -AsJob }



$Params = @{
  PolicyAssignmentId = " /subscriptions/8e9d95eb-7ef8-4c08-a817-b44fa8655224/providers/Microsoft.Authorization/policyAssignments/alz_init_asgmt"
  ResourceGroupName = "iaas-identity"

}

"configure_backup_when_not_tagged" | % { Start-AzPolicyRemediation @Params -PolicyDefinitionReferenceId $_ -Name "remediate_$($_)" -AsJob }

