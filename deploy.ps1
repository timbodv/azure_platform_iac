New-AzManagementGroupDeployment -ManagementGroupId lab-mg -Location australiaeast -TemplateFile .\custom_roles.bicep
New-AzManagementGroupDeployment -ManagementGroupId lab-mg -Location australiaeast -TemplateFile .\policies.bicep
