param location string = 'australiaeast'

resource default_maintenance_configuration 'Microsoft.Maintenance/maintenanceConfigurations@2023-04-01' = {
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
      //startDateTime: '2023-12-09T11:00:00Z'
      startDateTime: '2023-12-09 11:00'
      timeZone: 'E. Australia Standard Time'
    }
  }
}

output default_maintenance_configuration_id string = default_maintenance_configuration.id
