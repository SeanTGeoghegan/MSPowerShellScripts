<#This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS OR A PARTICULAR PURPOSE. 
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: 
    (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
    (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
    (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorney's fees, that arise or result from the use or distribution of the Sample Code.
#>

####################################################################################################################################################
#                                               Nuke Compliance Cases (Core eDiscovery)
# Revision Author: Sean Geoghegan 
# Purpose: Nuke all Retention Policy
#
# USE AT YOUR OWN RISK
# USE AT YOUR OWN RISK
# USE AT YOUR OWN RISK
# USE AT YOUR OWN RISK
# 
# Techniques: Finds and loops through all Unified Retention Policies. Nukes them.
#
####################################################################################################################################################

#Adds double confirmation to 
Write-Host "Are you sure that you want to do this? We are NOT held liable for any policy destruction. Type 'Y' or type 'N'." -ForegroundColor Black -BackgroundColor White
$firstconfirm = Read-Host 

if ($firstconfirm -eq "Y") {
    Write-Host "Are you ABSOLUTELY sure that you want to do this? We are NOT held liable for any policy destruction. Type 'Y' or type 'N'." -ForegroundColor Black -BackgroundColor Red
    $secondconfirm = Read-Host 
}
else {
    break    
}

if ($secondconfirm -eq "Y") {
    $retPols = Get-RetentionCompliancePolicy
    [string]$deletedPols

    foreach ($retPol in $retPols) {         
        #If policy name does not equal the exempt from deletion policies (-notlike values), then delete the policy.
        if ($retpol.Name -notlike "*test*" -and $retpol.Name -notlike "*Email vs UPN") {
            $retpolName = $retpol.Name
            Write-Host "Removing retention policy: $retPolName" -ForegroundColor Black -BackgroundColor Cyan
            Remove-RetentionCompliancePolicy -identity $retpolName -Confirm:$true
            $deletedPols += "$retpolName `n"
        }
    }

    $pendingPolicies = Get-RetentionCompliancePolicy -DistributionDetail | Where-Object { $_.Mode -eq "PendingDeletion" }
    Write-Host "`n"
    Write-Host "Policies that you have marked for deletion, please allow up to 48 hours for change replication:" -ForegroundColor Black -BackgroundColor Green
    $deletedPols
    $deletedPols = $null

    Write-Host "`n"
    Write-Host "Policies that are currently in a PendingDeletion state:" -ForegroundColor Black -BackgroundColor Green
    $pendingPolicies | Format-Table Name, Mode, WhenChanged

}
else {
    break
}
