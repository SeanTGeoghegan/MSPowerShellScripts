<#This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS OR A PARTICULAR PURPOSE. 
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: 
    (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
    (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
    (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorney's fees, that arise or result from the use or distribution of the Sample Code.
#>

<#
    This script is designed to gather information about DLP Policies and Rules, such as Distribution Status, actions, and conditions.
    Written by: Sean Geoghegan
    Created: 7/26/2022
    Last Updated: 7/26/2022
#>


$dlpPolicies = Get-DLPCompliancePolicy
$outputpath = "C:\Temp\"
$filename = "dlpcompliancePoliciesRules"
$FormatEnumerationLimit = -1
$policyCount = 0
$ruleCount = 0

[string]$dateDay = (Get-Date).Day
[string]$dateMonth = (Get-Date).Month
[string]$dateYear = Get-Date -Format "yyyy"
[string]$dateHour = Get-Date -Format "hh"
[string]$dateMinute = Get-Date -Format "mm"
[string]$date = "_" + $dateMonth + "_" + $dateDay + "_" + $dateYear + "__" + "$dateHour" + "-" + "$dateMinute"

foreach ($dlpPol in $dlpPolicies){
    $dlpPol = Get-DlpCompliancePolicy -Identity "$dlpPol" -DistributionDetail 
    $dlpRules = Get-DLPComplianceRule -Policy $dlpPol.Name

    #Writes Information to LogFile
    "=========================================" | Out-File $outputPath\$filename$date.txt -Append
    "DLP Policy: " + $dlpPol.Name | Out-File $outputPath\$filename$date.txt -Append
    "=========================================" |Out-File $outputPath\$filename$date.txt -Append
    $dlpPol | Format-List | Out-File $outputPath\$filename$date.txt -Append
    $policyCount++

    foreach ($dlpRule in $dlpRules){
        "=========================================" | Out-File $outputPath\$filename$date.txt -Append
        "DLP Rule: " + $dlpRule.Name | Out-File $outputPath\$filename$date.txt -Append
        "=========================================" |Out-File $outputPath\$filename$date.txt -Append
        $dlpRules | Format-List | Out-File $outputPath\$filename$date.txt -Append
        $ruleCount++
    }

}

Write-Host "Script Complete. Found $policyCount Policies & $ruleCount Rules" -ForegroundColor White -BackgroundColor Yellow
Write-Host "Please review these at $outputPath." -BackgroundColor Yellow -ForegroundColor Black
