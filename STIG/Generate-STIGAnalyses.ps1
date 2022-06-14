param (
    $OutDir
)

Set-StrictMode -Version 3
$ErrorActionPreference = "stop"

$HelperDir = (Join-Path $PSScriptRoot "..\Helpers")

. (Join-Path $PSScriptRoot "STIGBaselines.ps1")
. (Join-Path $HelperDir "AuditPolicyInfo.ps1")
. (Join-Path $HelperDir "BESRelevanceHelpers.ps1")
. (Join-Path $HelperDir "BESTemplates.ps1")
. (Join-Path $HelperDir "FilesystemHelpers.ps1")
. (Join-Path $HelperDir "HTMLHelpers.ps1")


$Platforms = $STIGs.Keys | %{$_.ToString()}

foreach ($Platform in $Platforms) {
    write-host "- Processing $Platform"
            
    $Stig = $STIGs[$Platform]

    $BaselineRelevance = $STIG["Relevance"]
    $BaselineName = $STIG["Baseline"]
    $AuditSuccess = $STIG["Success Policies"]
    $AuditFailure = $STIG["Failure Policies"]

    $Name = "STIG - $Platform Audit Policy - Windows"
    $Description = @"
$HTMLCSS
<body>
Compliance information for $Platform systems to the $BaselineName.
<h6>Properties</h6>
<p><b>STIG - $Platform Audit Policy Compliance - Windows:</b> Provides a percentage score that describes the percentage of STIG-required audit policies that are currently applied to this system.</p>
<p><b>STIG - $Platform Missing Audit Policies - Windows:</b> Provides the list of the STIG-required audit policies that are currently missing from the system.</p>
<p><b>STIG - $Platform Compliant Audit Policies - Windows:</b> Provides the list of the STIG-required audit policies that are currently active on the system.</p>
<p><b>STIG - $Platform Extra Audit Policies - Windows:</b> Provides the list of audit policies that are applied to the system but not required by the STIG baseline for this Operating System.</p>
<h6>Success Auditing</h6>
The following success auditing policies must be applied to meet STIG compliance:
<p>$($AuditSuccess.Foreach{"Config - Audit Policy - Enable Success auditing for $(Get-AuditPolicyCategoryFromSubcategory $_) $_ - Windows" } -join "<br>`r`n")</p>
<h6>Failure Auditing</h6>
The following success failure policies must be applied to meet STIG compliance:
<p>$($AuditFailure.Foreach{"Config - Audit Policy - Enable Failure auditing for $(Get-AuditPolicyCategoryFromSubcategory $_) $_ - Windows" } -join "<br>`r`n")</p>
$Copyright
</body>
"@

    $Relevance = @((Get-isWindowsRelevance), (Get-AuditPolicyExistsRelevance),$BaselineRelevance)

    $Properties = [ordered] @{}

    $SetOfSuccess = """" + ($AuditSuccess -join """;""") + """"
    $SetOfFailure = """" + ($AuditFailure -join """;""") + """"

    $PolicyCount = $AuditSuccess.Count + $AuditFailure.Count

    <#
    Add up the number of missing Audit Failure settings and the number of missing Audit Success settings and then divide them by the total
    number of policies in play to generate % Score
    #>
    $ScoreRelevance = @"
(it as string & "%25") of 
(100 * relative significance place 2 of 
(((/* Calculate the number of correctly configured failure policies of the $($AuditFailure.Count) policies */ 
    number of audit failures whose (it = true /*WE*/) of system policies of subcategories whose (
        set of ($SetOfFailure)
        contains (name of it)) of categories of audit policies
    )
+ 
(/* Calculate the number of correctly configured failure policies of the $($AuditSuccess.Count) policies */
    number of audit successes whose (it = true) of system policies of subcategories whose (
        set of ($SetOfSuccess)
        contains (name of it)) of categories of audit policies
    )
) as floating point / $PolicyCount))
"@

    <# List the required policies that are present on the system #>
    $PresentPoliciesRelevance = @"
unique values of (
    (it & " Success Auditing") of elements of (
        intersection of (
            set of ($SetOfSuccess);
            (set of names of subcategories whose (audit success of system policy of it /*WE*/) of categories of audit policies)
        )
    );
        
    (it & " Failure Auditing") of elements of (
        intersection of (
            set of ($SetOfFailure);
            (set of names of subcategories whose (audit failures of system policy of it) of categories of audit policies)
        )
    )
)
"@

    <# List the required policies that are missing from the system #>
    $MissingPoliciesRelevance = @"
unique values of (
    (it & " Success Auditing") of elements of (
        set of ($SetOfSuccess)
        -
        (set of names of subcategories whose (audit success of system policy of it) of categories of audit policies /*WE*/));
        
    (it & " Failure Auditing") of elements of (
        set of ($SetOfFailure)
        -
        (set of names of subcategories whose (audit failures of system policy of it) of categories of audit policies))
)
"@

    <# List the policies that are present but not required on the system #>
    $ExtraPoliciesRelevance = @"
unique values of (
    (it & " Success Auditing" /*WE*/) of elements of (
        (set of names of subcategories whose (audit success of system policy of it) of categories of audit policies)
        -
        set of ($SetOfSuccess)
        
    );
        
    (it & " Failure Auditing") of elements of (
        (set of names of subcategories whose (audit failures of system policy of it) of categories of audit policies)
        -
        set of ($SetOfFailure)
    )
)
"@

    $Properties += @{
        "STIG - $Platform Audit Policy Compliance - Windows"   = $ScoreRelevance
        "STIG - $Platform Missing Audit Policies - Windows"    = $MissingPoliciesRelevance
        "STIG - $Platform Compliant Audit Policies - Windows"  = $PresentPoliciesRelevance
        "STIG - $Platform Extra Audit Policies - Windows"      = $ExtraPoliciesRelevance
    }


    $Analysis = Generate-BigFixAnalysis -Title $Name -Description $Description -Relevance $Relevance -Properties $Properties

    $FileName = $Name
    $Analysis.Save((Join-Path $OutDir "$FileName.bes"))
}