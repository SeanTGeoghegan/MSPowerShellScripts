<#This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS OR A PARTICULAR PURPOSE. 
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: 
    (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
    (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
    (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorney's fees, that arise or result from the use or distribution of the Sample Code.
#>

<#
    This script is designed to gather information about eDiscovery Cases (Standard and Premium), as well as any associated Holds.
    Written by: Sean Geoghegan
    Created: 7/26/2022
    Last Updated: 7/26/2022
#>

$standardComplianceCases = Get-ComplianceCase
$PremiumComplianceCases = Get-ComplianceCase -CaseType AdvancedEdiscovery
$complianceSearches = Get-ComplianceSearch
$outputpath = "C:\Temp\"
$fileNameStandard = "eDiscoveryStandard"
$fileNamePremium = "eDiscoveryPremium"
$fileNameSearches = "ComplianceSearches"
$FormatEnumerationLimit = -1
$standardCaseCount = 0
$standardHoldCount = 0
$premiumCaseCount = 0
$premiumHoldCount = 0
$csActionCount = 0
$searchCount = 0

[string]$dateDay = (Get-Date).Day
[string]$dateMonth = (Get-Date).Month
[string]$dateYear = Get-Date -Format "yyyy"
[string]$dateHour = Get-Date -Format "hh"
[string]$dateMinute = Get-Date -Format "mm"
[string]$date = "_" + $dateMonth + "_" + $dateDay + "_" + $dateYear + "__" + "$dateHour" + "-" + "$dateMinute"

foreach ($standardComplianceCase in $standardComplianceCases){

    $caseHolds = Get-CaseHoldPolicy -Case $standardComplianceCase.identity -DistributionDetail

    #Writes Information to LogFile
    "=========================================" | Out-File $outputPath\$fileNameStandard$date.txt -Append
    "eDiscovery Case: " + $standardComplianceCase.Name | Out-File $outputPath\$fileNameStandard$date.txt -Append
    "=========================================" |Out-File $outputPath\$fileNameStandard$date.txt -Append
    $standardComplianceCase | Format-List | Out-File $outputPath\$fileNameStandard$date.txt -Append
    $standardCaseCount++

    foreach ($caseHold in $caseHolds){
        $caseHold = Get-CaseHoldPolicy $caseHold.Id -DistributionDetail

        "=========================================" | Out-File $outputPath\$fileNameStandard$date.txt -Append
        "Hold Policy: " + $caseHold.Name | Out-File $outputPath\$fileNameStandard$date.txt -Append
        "=========================================" |Out-File $outputPath\$fileNameStandard$date.txt -Append
        
        $caseHold | Format-List | Out-File $outputPath\$fileNameStandard$date.txt -Append
        $standardHoldCount++
    }

}

foreach ($complianceSearch in $complianceSearches){

    "=========================================" | Out-File $outputPath\$fileNameSearches$date.txt -Append
    "Compliance Search Name: " + $complianceSearch.Name | Out-File $outputPath\$fileNameSearches$date.txt -Append
    "=========================================" |Out-File $outputPath\$fileNameSearches$date.txt -Append

    $complianceSearch | Format-List | Out-File $outputPath\$fileNameSearches$date.txt -Append
    $searchCount++

    $csActions = Get-ComplianceSearchAction | ? {$_.Name -like "*$complianceSearch.Name*"}
    
    foreach($csAction in $csActions){
        
        "=========================================" | Out-File $outputPath\$fileNameSearches$date.txt -Append
        "Compliance Search Action Name: " + $complianceSearch.Name | Out-File $outputPath\$fileNameSearches$date.txt -Append
        "=========================================" |Out-File $outputPath\$fileNameSearches$date.txt -Append

        $csAction | Format-List | Out-File $outputpath\$fileNameSearches$date.txt -Append
        $csActionCount++
    }

}

foreach ($PremiumComplianceCase in $PremiumComplianceCases){

    $premiumCaseHolds = Get-CaseHoldPolicy -Case $premiumComplianceCase.identity -DistributionDetail

    #Writes Information to LogFile
    "=========================================" | Out-File $outputPath\$fileNamePremium$date.txt -Append
    "Advanced eDiscovery Case: " + $PremiumComplianceCase.Name | Out-File $outputPath\$fileNamePremium$date.txt -Append
    "=========================================" |Out-File $outputPath\$fileNamePremium$date.txt -Append
    $PremiumComplianceCase | Format-List | Out-File $outputPath\$fileNamePremium$date.txt -Append
    $premiumCaseCount++

    foreach ($premiumCaseHold in $premiumCaseHolds){
        "=========================================" | Out-File $outputPath\$fileNamePremium$date.txt -Append
        "Advanced Hold Policy: " + $premiumCaseHold.Name | Out-File $outputPath\$fileNamePremium$date.txt -Append
        "=========================================" | Out-File $outputPath\$fileNamePremium$date.txt -Append
        $premiumCaseHold | Format-List | Out-File $outputPath\$fileNamePremium$date.txt -Append
        $premiumHoldCount++
    }

}

Write-Host "Script Processing Complete. For eDiscovery (Standard), found $standardCaseCount Cases & $standardHoldCount Holds. For eDiscovery (Premium) found $premiumCaseCount Cases & $premiumHoldCount Holds." -ForegroundColor White -BackgroundColor Yellow
Write-Host "Please review these at $outputPath." -BackgroundColor Yellow -ForegroundColor Black
