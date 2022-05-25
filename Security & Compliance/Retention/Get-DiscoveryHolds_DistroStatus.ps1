function Get-DiscoveryHolds_DistroStatus {
    
    $eDiscCase = Get-ComplianceCase

    foreach($e in $eDiscCase){
        "-----"
        $eDiscHold = Get-CaseHoldPolicy -Case $e.Name -DistributionDetail
        $eDiscHold.Name
        $eDiscHold.GUID.ToString()
        $eDiscHold.DistributionStatus
        "-----"
    }
}