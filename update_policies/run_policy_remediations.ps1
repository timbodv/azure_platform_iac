
# (Get-AzPolicySetDefinition -ManagementGroupName lab-mg -Name plz_initiative).Properties.PolicyDefinitions | % { Write-Host """$($_.policyDefinitionReferenceId)""," }
# (Get-AzPolicySetDefinition -SubscriptionId "967d672b-7700-45c3-81cc-bfca8da60a25" -Name bcc_iaas_initiative).Properties.PolicyDefinitions | % { Write-Host """$($_.policyDefinitionReferenceId)""," }

# Development     967d672b-7700-45c3-81cc-bfca8da60a25
# Shared Services 8e9d95eb-7ef8-4c08-a817-b44fa8655224

$Params = @{
  PolicyAssignmentId = "/subscriptions/967d672b-7700-45c3-81cc-bfca8da60a25/providers/microsoft.authorization/policyassignments/bcc_iaas_init_asgmt"
  #ManagementGroupName = "lab-mg"
}

"config_periodic_update_checks_windows",
"config_periodic_update_checks_linux",
"config_periodic_update_checks_windows_arc",
"config_periodic_update_checks_linux_arc",
"schedule_update_installation_mc_one",
"schedule_update_installation_mc_two" | % { Start-AzPolicyRemediation @Params -PolicyDefinitionReferenceId $_ -Name "remediate_$($_)" -AsJob }



$Params = @{
  PolicyAssignmentId = " /subscriptions/8e9d95eb-7ef8-4c08-a817-b44fa8655224/providers/Microsoft.Authorization/policyAssignments/alz_init_asgmt"
  ResourceGroupName = "iaas-identity"

}

"configure_backup_when_not_tagged" | % { Start-AzPolicyRemediation @Params -PolicyDefinitionReferenceId $_ -Name "remediate_$($_)" -AsJob }

