param location string = 'australiaeast'
param prefix string

var recovery_vault_name = '${prefix}-${uniqueString(subscription().id)}-rv'

resource recovery_vault 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: recovery_vault_name
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

resource default_vm_backup_policy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-01-01' = {
  name: 'default-vm-backup-bkpol'
  location: location
  parent: recovery_vault
  properties: {
    policyType: 'V2'
    backupManagementType: 'AzureIaasVM'
    instantRpRetentionRangeInDays: 2
    schedulePolicy: {
      scheduleRunFrequency: 'Daily'
      dailySchedule: {
        scheduleRunTimes: [
          '2023-12-08T21:00:00Z'    
        ]
      }
      schedulePolicyType: 'SimpleSchedulePolicyV2'
    }
    retentionPolicy: {
      dailySchedule: {
        retentionTimes: [
          '2023-12-08T21:00:00Z'
        ]
        retentionDuration: {
          count: 7
          durationType: 'Days'
        }
      }
      retentionPolicyType: 'LongTermRetentionPolicy'
    }
    timeZone: 'E. Australia Standard Time'
  }
}

output default_vm_backup_policy_id string = default_vm_backup_policy.id
