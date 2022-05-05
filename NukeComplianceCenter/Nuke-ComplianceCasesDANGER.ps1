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
# Purpose: Nuke all Compliance Cases
#
# USE AT YOUR OWN RISK
# USE AT YOUR OWN RISK
# USE AT YOUR OWN RISK
# USE AT YOUR OWN RISK
# 
# Techniques: Finds and loops through all CED Cases. Nukes them.
#
####################################################################################################################################################

Write-Host "Are you sure that you want to do this. We are NOT held liable for any policy destruction. Type 'Y' or type 'N'." -ForegroundColor Black -BackgroundColor White
$firstconfirm = Read-Host 

if ($firstconfirm -eq "Y") {
    Write-Host "Are you ABSOLUTELY sure that you want to do this. We are NOT held liable for any policy destruction. Type 'Y' or type 'N'." -ForegroundColor Black -BackgroundColor Red
    $secondconfirm = Read-Host 
}
else {
    break    
}

if ($secondconfirm -eq "Y") {
    $cases = Get-ComplianceCase  
        
    foreach ($case in $cases) {
        Write-Host "Case is" $case.Name -Separator "="
        $holdpolicies = Get-CaseHoldPolicy -Case $case.Name
               
            
        foreach ($holdpolicy in $holdpolicies) {
            Write-Host "--Policy is " $holdpolicy.Name
            $caseholdrules = Get-CaseHoldRule -Policy $holdpolicy.Name
                    
            if ($null -ne "$caseholdrules") {
                Write-Host "Case Hold has Rules" -ForegroundColor Black -BackgroundColor Red
                    
                foreach ($caseholdrule in $caseholdrules) {
                    Write-Host "----Rule is " $caseholdrule.Name
                    Remove-CaseHoldRule $caseholdrule.Name -Confirm:$false
                    Remove-CaseHoldRule $caseholdrule.Name -ForceDeletion -Confirm:$false
                }
                
                Remove-CaseHoldPolicy -identity $holdpolicy.Name -Confirm:$false
                Remove-CaseHoldPolicy -identity $holdpolicy.Name -Confirm:$false -ForceDeletion
            }            
        }   
        Remove-ComplianceCase -Identity $case.Name -Confirm:$false
    }

    Write-Host "Script Complete. Current Compliance Cases are:"
    Get-ComplianceCase

}
else {
    break
}
