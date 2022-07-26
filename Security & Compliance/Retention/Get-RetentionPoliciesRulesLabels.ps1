<#This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS OR A PARTICULAR PURPOSE. 
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: 
    (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
    (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
    (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorney's fees, that arise or result from the use or distribution of the Sample Code.
#>

<#
    This script is designed to gather information about Retention Policies, Rules, and Labels, as well as Adaptive Scopes.
    Written by: Sean Geoghegan
    Created: 7/26/2022
    Last Updated: 7/26/2022
#>

$FormatEnumerationLimit = -1
$outputpath = "C:\Temp\"
$fileName1 = "Retention_Policies_Rules"
$filename2 = "Retention_Labels"
$filename3 = "Adaptive_Scopes"

#Sets Date Variables for use in FileNames
[string]$dateDay = (Get-Date).Day
[string]$dateMonth = (Get-Date).Month
[string]$dateYear = Get-Date -Format "yyyy"
[string]$dateHour = Get-Date -Format "hh"
[string]$dateMinute = Get-Date -Format "mm"
[string]$date = "_" + $dateMonth + "_" + $dateDay + "_" + $dateYear + "__" + "$dateHour" + "-" + "$dateMinute"

#Gathers all Policies and Labels
$retPols = Get-RetentionCompliancePolicy
$retLabels = Get-ComplianceTag
$adScopes = Get-AdaptiveScope

#Sets Counters
$policyCount = 0
$ruleCount = 0
$labelCount = 0
$scopeCount = 0


foreach($retPol in $retPols){

    $retPol = Get-RetentionCompliancePolicy -Identity $retPol.Id -DistributionDetail

    "=========================================" | Out-File $outputPath\$fileName1$date.txt -Append
    "*Retention Policy: " + $retPol.Name | Out-File $outputPath\$fileName1$date.txt -Append
    "=========================================" | Out-File $outputPath\$fileName1$date.txt -Append

    $retPol | Format-List | Out-File $outputPath\$fileName1$date.txt -Append
    $retRules = Get-RetentionComplianceRule -Policy $retPol.Id
    $policyCount++

    foreach($retRule in $retRules){
     
        "=========================================" | Out-File $outputPath\$fileName1$date.txt -Append
        "**Retention Rule: " + $retRule.Name | Out-File $outputPath\$fileName1$date.txt -Append
        "=========================================" | Out-File $outputPath\$fileName1$date.txt -Append    

        $retRule | Format-List | Out-File $outputpath\$filename1$date.txt -Append

        $ruleCount++

    }

}

foreach ($retLabel in $retLabels){


    "=========================================" | Out-File $outputPath\$fileName2$date.txt -Append
    "Retention Label: " + $retLabel.Name | Out-File $outputPath\$fileName2$date.txt -Append
    "=========================================" | Out-File $outputPath\$fileName2$date.txt -Append

    $retLabel | Format-List | Out-File $outputpath\$filename1$date.txt -Append
    $labelcount++

}

foreach($adScope in $adScopes){

    "=========================================" | Out-File $outputPath\$fileName3$date.txt -Append
    "Adaptive Scope " + $adScope.Name | Out-File $outputPath\$fileName3$date.txt -Append
    "=========================================" | Out-File $outputPath\$fileName3$date.txt -Append

    $adScope | Format-List | Out-File $outputpath\$filename3$date.txt -Append
    $scopeCount++

}

Write-Host "Script Processing Complete. Found $policyCount Policies with $ruleCount Rules. Found $labelCount Retention Labels. Found $scopeCount Adapative Scopes" -BackgroundColor Yellow -ForegroundColor Black
Write-Host "Please review these at $outputPath." -BackgroundColor Yellow -ForegroundColor Black
