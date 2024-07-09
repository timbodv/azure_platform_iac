param location string = 'australiaeast'

param resource_name string
param reboot_value string
param maint_window_duration string
param maint_window_recur string
param maint_window_start_time string
param linux_classifications array = [
  'Critical'
  'Security'
]
param linux_package_exclusions array = [
  'omi'
  'scx'
]
param windows_classifications array = [
  'Critical'
  'Security'
]
param windows_kb_exclusions array = []

resource maintenance_configuration 'Microsoft.Maintenance/maintenanceConfigurations@2023-04-01' = {
  name: resource_name
  location: location
  properties: {
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    installPatches: {
      linuxParameters: {
        classificationsToInclude: linux_classifications
        packageNameMasksToExclude: linux_package_exclusions
      }
      rebootSetting: reboot_value
      windowsParameters: {
        classificationsToInclude: windows_classifications
        kbNumbersToExclude: windows_kb_exclusions
      }
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      duration: maint_window_duration
      recurEvery: maint_window_recur
      startDateTime: maint_window_start_time
      timeZone: 'E. Australia Standard Time'
    }
  }
}

output maintenance_configuration_id string = maintenance_configuration.id
