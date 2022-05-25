function Get-Retention_DistroStatus {

    $retpols = Get-RetentionCompliancePolicy

    foreach ($r in $retpols) { 
        $retpoldetail = Get-RetentionCompliancePolicy $r.Name -DistributionDetail
        "----" 
        $retpoldetail.Name
        $retpoldetail.Mode
        $retpoldetail.GUID.ToString()
        $retpoldetail.DistributionStatus
        "----" 
    }
}