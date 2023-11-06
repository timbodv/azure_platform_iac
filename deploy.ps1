New-AzTenantDeployment -TemplateFile .\management_groups.bicep -Location australiaeast



New-AzManagementGroupDeployment -ManagementGroupId lab-mg -Location australiaeast -TemplateFile .\custom_roles.bicep
New-AzManagementGroupDeployment -ManagementGroupId lab-mg -Location australiaeast -TemplateFile .\policies.bicep

<#
payg-prd-sub    18d4f73e-3520-4039-bc67-e0d65ad7a981
payg-dev3-sub   d4b21116-8631-4b1f-8e06-9bb428895816
Development     967d672b-7700-45c3-81cc-bfca8da60a25
Shared Services 8e9d95eb-7ef8-4c08-a817-b44fa8655224
#>


New-AzSubscriptionDeployment -Location australiaeast -TemplateFile .\plz.bicep
New-AzSubscriptionDeployment -Location australiaeast -TemplateFile .\alz.bicep