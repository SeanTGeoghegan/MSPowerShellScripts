<#This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS OR A PARTICULAR PURPOSE. 
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: 
    (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
    (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
    (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorney's fees, that arise or result from the use or distribution of the Sample Code.
#>

####################################################################################################################################################
#                                               HoldsAppliedToMailbox
# Revision Author: Sean Geoghegan
# Orig. Author: Unknown 
# Purpose: Review all holds, Org-Wide or Specific, applied to a specific mailbox
# 
# Techniques: This script utilizes the Mailbox Hold Tracking fields to understand 
# when a specific hold was applied to a mailbox, and if it is still applied.
#
####################################################################################################################################################
 
## Small Script to get Retention Holds applied to mailboxes.
    $mbx = Read-Host "Provide a UPN of the mailbox you would like to review holds from."
    $tenant = Get-OrganizationConfig
    $tenantName = $tenant.Name
    $ht = Export-MailboxDiagnosticLogs $mbx -ComponentName HoldTracking
    $sht = Export-MailboxDiagnosticLogs $mbx -ComponentName SubstrateHoldTracking
    $policies = Get-RetentionCompliancePolicy

#Gathers all Holds Configured Within Tenant
    #Write-Host "Hold Policies configured within tenant"
    #Write-Host "========================"
    #$policies | Select-Object Name, GUID
    #Write-Host -Separator " "

#Gathers Mailbox-Specific Holds
    Write-Host "Mailbox-Specific Holds for $mbx" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "========================"
    Get-Mailbox $mbx | Select-Object -ExpandProperty InPlaceHolds
    Write-Host -Separator " "

#Gathers eDiscovery Case Holds
    #$eDiscCases = Get-ComplianceCase
    #$eDiscHolds = Get-CaseHoldPolicy

#Gathers Org-Wide Holds that are on tenant. These can contain exceptions 
    Write-Host "Organization-Wide Holds for $tenantName" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "========================"
    Get-OrganizationConfig | Select-Object -ExpandProperty InPlaceHolds
    Write-Host -Separator " "

#Gathers Mailbox Holds for "$mbx" variable as defined above
    Write-Host "Compare these values below, with the holds above." -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "ed  : end date of hold - if applicable" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "hid : provides the GUID of the holds applied to the mailbox" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "lsd : last start date of hold application" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "osd : original start date of hold application" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "========================"
    $ht.MailboxLog | ConvertFrom-Json