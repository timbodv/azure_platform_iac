targetScope = 'tenant'

resource lab_management_group 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: 'lab-mg'
}

resource platform_management_group 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'platform-mg'
  properties: {
    displayName: 'Platform'
    details: {
      parent: {
        id: lab_management_group.id
      }
    }
  }
}

resource lz_management_group 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'landing_zone-mg'
  properties: {
    displayName: 'Landing Zones'
    details: {
      parent: {
        id: lab_management_group.id
      }
    }
  }
}

resource sandbox_management_group 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'sandbox-mg'
  properties: {
    displayName: 'Sandbox'
    details: {
      parent: {
        id: lab_management_group.id
      }
    }
  }
}

resource decomissioned_management_group 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'decomissioned-mg'
  properties: {
    displayName: 'Decomissioned'
    details: {
      parent: {
        id: lab_management_group.id
      }
    }
  }
}

resource parked_management_group 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'parked-mg'
  properties: {
    displayName: 'Parked'
    details: {
      parent: {
        id: lab_management_group.id
      }
    }
  }
}

resource lz_development_management_group 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'development-lz-mg'
  properties: {
    displayName: 'Development'
    details: {
      parent: {
        id: lz_management_group.id
      }
    }
  }
}

resource platform_shared_management_group 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'shared-platform-mg'
  properties: {
    displayName: 'Shared Services'
    details: {
      parent: {
        id: platform_management_group.id
      }
    }
  }
}

// payg-dev3-sub
resource payg_dev_sub_to_management_group 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = {
  name: '${parked_management_group.name}/d4b21116-8631-4b1f-8e06-9bb428895816'
}

// payg-prd-sub
resource payg_prd_sub_to_management_group 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = {
  name: '${parked_management_group.name}/18d4f73e-3520-4039-bc67-e0d65ad7a981'
}

// Shared Services
resource shared_services_sub_to_management_group 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = {
  name: '${platform_shared_management_group.name}/8e9d95eb-7ef8-4c08-a817-b44fa8655224'
}

// Development
resource dev_sub_to_management_group 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = {
  name: '${lz_development_management_group.name}/967d672b-7700-45c3-81cc-bfca8da60a25'
}
