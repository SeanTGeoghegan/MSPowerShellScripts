<#This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS OR A PARTICULAR PURPOSE. 
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: 
    (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
    (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
    (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorney's fees, that arise or result from the use or distribution of the Sample Code.
#>

####################################################################################################################################################
#
# Original Author: Sean Geoghegan
#
####################################################################################################################################################
 
#This script will gather SCC, Exchange, or Azure AD RoleGroups/Permissions, based on A) What you are connected to and B) what variable is passed
#In order to pull Exchange RBAC Roles, you must only be connected via Connect-ExchangeOnline, you CANNOT also be connected via Connect-IPPSSession
#In order to pull Microsoft Purview Compliance Portal or Defender Portal Roles, you must only be connected via Connect-IPPSSession, you CANNOT also be connected via Connect-ExchangeOnline

    $formatenumerationlimit = -1
    $RoleType = $null
    [bool]$ReturnedRoles = $false

    if ($null -eq $RoleType) {
        $roletype = Read-Host "Please Enter a RoleType"
    }
    
    if ($null -eq $RoleType -or $RoleType -eq '' -or $RoleType -eq 'SCC'){
        $SCCRoles = Get-RoleGroup
        $emptySccRoles = @()
        Write-Host "This is a list of Management Role Groups within Exchange Online or the Microsoft Purview/Security Portals." -BackgroundColor cyan -ForegroundColor Black
        
        foreach ($sccrole in $sccroles) {
            $sccRoleMembers = Get-RoleGroupMember -Identity $SCCRole.Name
            
            if ($null -ne $sccRoleMembers) {
                $sccRoleName = $sccrole.Name
                Write-Host "================== Returning Roles with Assigned Users: Role Members of '$sccroleName' ==================" -BackgroundColor Yellow -ForegroundColor Black
                $sccRoleMembers | FL Name
            }
            else {
                $sccRoleName = $sccrole.Name
                #Write-Host "================== $sccRoleName is empty ==================" -BackgroundColor Yellow -ForegroundColor Black
                $emptySccRoles += $sccRoleName
            }
        }
        Write-Host "================== The following Management Role Groups within Exchange Online or the Microsoft Purview are empty ==================" -BackgroundColor cyan -ForegroundColor Black
        $emptysccroles | Write-Host -BackgroundColor Green -ForegroundColor Black
        $returnedRoles = $true
    }

    if ($null -eq $RoleType -or $RoleType -eq '' -or $RoleType -eq 'AzureAD'){
        $AzADRoles = Get-AzureADDirectoryRole
        $emptyAzAdRoles = @()
        Write-Host "This is a list of Management Role Groups within Azure Active Directory" -BackgroundColor cyan -ForegroundColor Black
        
        foreach ($azadrole in $AzAdRoles) {
            $azadRoleMembers = Get-AzureADDirectoryRoleMember -ObjectId $AzADRole.ObjectId
            
            if ($null -ne $azadRoleMembers) {
                $azadroleName = $AzADrole.DisplayName
                Write-Host "================== Returning Roles with Assigned Users: Role Members of '$azadRoleName' ==================" -BackgroundColor Yellow -ForegroundColor Black
                $azadRoleMembers | FL DisplayName, UserPrincipalName
            }
            else {
                $azadroleName = $AzADrole.DisplayName
                #Write-Host "================== $azadRoleName is empty ==================" -BackgroundColor Yellow -ForegroundColor Black 
                $emptyAzAdRoles += $azadroleName
            }
        }
        Write-Host "================== The following Management Role Groups within Azure Active Directory are empty ==================" -BackgroundColor cyan -ForegroundColor Black
        $emptyazadroles | Write-Host -BackgroundColor Green -ForegroundColor Black
        $returnedRoles = $true
    }
    
    if ($ReturnedRoles -eq $false){
        Write-Host "================== There are no management roles for $roleType available through this script ===============" -ForegroundColor black -BackgroundColor Red
    }