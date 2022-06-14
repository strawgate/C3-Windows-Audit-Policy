param (
    $Uri = "https://prd-bfx-srv-01.ad.weaston.org:52311/api",
    $Credential = (Get-Credential),
    $SiteName = "C3-Windows-Audit-Policy"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3

$AuditPolicyInfo = Get-ChildItem (Join-Path $PSScriptRoot "..") -File -Filter "AuditPolicyInfo.ps1" -Recurse

. $AuditPolicyInfo.FullName

$STIGInfo = Get-ChildItem (Join-Path $PSScriptRoot "..") -File -Filter "STIGBaselines.ps1" -Recurse

. $STIGInfo.FullName

$Platforms = Get-STIGPlatforms

Foreach ($Platform in $Platforms) {
    write-host "Creating STIG Baseline for $Platform"

    $Relevance = Get-STIGBaselineRelevance -Platform $Platform

    $FixletNames = @()

    $SuccessPolicies = Get-STIGBaselineSuccessPolicies -Platform $Platform

    $FixletNames += $SuccessPolicies | %{"Config - Audit Policy - Enable success auditing for $(Get-AuditPolicyCategoryFromSubcategory $_) / $_ - Windows"}

    $FailurePolicies = Get-STIGBaselineFailurePolicies -Platform $Platform
    
    $FixletNames += $FailurePolicies | %{"Config - Audit Policy - Enable failure auditing for $(Get-AuditPolicyCategoryFromSubcategory $_) / $_ - Windows"}

    $FixletNames = $FixletNames | Sort

    & .\New-BESBaselineFromFixletNames.ps1 -Uri $Uri -Credential $Credential -SiteType "custom" -SiteName $SiteName -Fixlet $FixletNames -BaselineName "Config - STIG Audit Policy Baseline - $Platform" -Relevance $Relevance
}
