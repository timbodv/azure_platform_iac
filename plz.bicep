targetScope = 'managementGroup'

param location string = 'australiaeast'

module plz_deployment_module 'module_plz_deployment.bicep' = {
  name: 'plz-deployment'
  // Shared Services
  scope: subscription('8e9d95eb-7ef8-4c08-a817-b44fa8655224')
  params: {
    location: location
  }
}

module plz_policies_module 'module_plz_policies.bicep' = {
  name: 'plz-policies'
  params: {
    location: location
  }
}

module plz_custom_roles_module 'module_plz_custom_roles.bicep' = {
  name: 'plz-custom-roles'
  params: {
  }
}
