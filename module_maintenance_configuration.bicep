param location string = 'australiaeast'

resource maintenance_configuration 'Microsoft.Maintenance/maintenanceConfigurations@2023-04-01' = {
  name: 'default-patch-mc'
  location: location
  properties: {
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    installPatches: {
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
      rebootSetting: 'Always'
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      duration: '03:55'
      recurEvery: '1Month Second Friday'
      startDateTime: '2023-12-09 11:00'
      timeZone: 'E. Australia Standard Time'
    }
  }
}

output maintenance_configuration_id string = maintenance_configuration.id
