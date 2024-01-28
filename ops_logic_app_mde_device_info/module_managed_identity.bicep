param location string
param managed_identity_name string

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${managed_identity_name}-id'
  location: location
}

output managed_identity_id string = managed_identity.id
output managed_identity_name string = managed_identity.name
