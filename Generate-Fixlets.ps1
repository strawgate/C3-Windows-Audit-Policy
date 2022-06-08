$ErrorActionPreference = "stop"
Set-Strictmode -version 3

$HelperDir = (Join-Path $PSScriptRoot "Helpers")

# Load our Audit Policy-related functions
. (Join-Path $HelperDir "AuditPolicyInfo.ps1")
. (Join-Path $HelperDir "BESTemplates.ps1")
. (Join-Path $HelperDir "BESRelevanceHelpers.ps1")
. (Join-Path $HelperDir "FilesystemHelpers.ps1")
. (Join-Path $HelperDir "XMLHelpers.ps1")



Function Generate-AuditPolCategoryRelevance {
    param (
        [string] $Category
    )
    
    $Relevance = @()
    $Relevance += Get-isWindowsRelevance
    $Relevance += Get-AuditPolicyExistsRelevance
    $Relevance += Get-AuditPolicyCategoryExistsRelevance -Category $Category

    return $Relevance
}

Function Generate-AuditPolActionScript {
    param (
        [string] $Category,
        [string] $Subcategory,
        [switch] $Failure,
        [switch] $Success,
        [switch] $Enable
    )
    $actionscript = @()
    $actionscript += "action uses wow64 redirection {not x64 of operating system}"

    $auditPolActionPrefix = "waithidden"
    $auditPolActionBase = "auditpol.exe /set /subcategory:""$SubCategory"""

    $auditPolActionSuffix = ""
    if ($Failure) {
        $auditPolActionSuffix += "/failure:"
    }
    if ($Success) {
        $auditPolActionSuffix += "/success:"
    }

    if ($Enable) {
        $auditPolActionSuffix += "enable"
    }
    else {
        $auditPolActionSuffix += "disable"
    }

    $actionscript += $auditPolActionPrefix + " " + $auditPolActionBase + " " + $auditPolActionSuffix

    return ($actionscript -join "`r`n")
}

Function Generate-AuditPolRelevance {
    param (
        [string] $Category,
        [string] $Subcategory,
        [switch] $Failure,
        [switch] $Success,
        [switch] $Enabled
    )

    # Handle whether we want this setting enabled or not
    $Prefix = "not"
    if ($Enabled) { $prefix = ""}

    $Type = "Success"
    if ($Failure) { $Type = "Failure" }

    $GeneratedRelevance = Get-AuditPolicySubCategoryCheckRelevance -Category $Category -Subcategory $Subcategory -Type $Type
    
    $Relevance = @()
    $Relevance += Generate-AuditPolCategoryRelevance -Category $Category
    $Relevance += $Prefix + $GeneratedRelevance 

    return $Relevance
}

Function Generate-AuditPolicyAnalyses {
    $Categories = Get-AuditPolicyCategory

    $Analyses = @()

    foreach ($Category in $Categories) {
        $Analyses += Generate-AuditPolicyCategoryAnalysis -Category $Category
    }

    return $Analyses
}

Function Generate-AuditPolicyCategoryAnalysis {
    param (
        $Category
    )

    $Subcategories = Get-AuditPolicySubCategory -Category $Category

    
    $Name = "Audit Policy - $Category - Windows"
    $Description = "Audit Policy - $Category - Windows"

    $Relevance = Generate-AuditPolCategoryRelevance -Category $Category

    $Properties = [ordered] @{}

    # Generate two BES Properties for each audit policy Sub-Category: One to cover Success auditing and one to cover Failure auditing
    foreach ($SubCategory in $Subcategories) {
        $Properties += Generate-AuditPolicySubcategoryAnalysisProperty -Category $Category -Subcategory $SubCategory -Success
        $Properties += Generate-AuditPolicySubcategoryAnalysisProperty -Category $Category -Subcategory $SubCategory -Failure
    }

    $Analysis = Generate-BigFixAnalysis -Title $Name -Description $Description -Relevance $Relevance -Properties $Properties

    return $Analysis
}

Function Generate-AuditPolicySubcategoryAnalysisProperty {
    param (
        $Category,
        $Subcategory,
        [switch] $Success,
        [switch] $Failure
    )

    if ($Success) { $type = "Success" } else { $type = "Failure" }

    $PropertyName = "Audit Policy - $Category - $Type auditing for $SubCategory - Windows"

    $PropertyRelevance = Get-AuditPolicySubCategoryCheckRelevance -Type $Type -Category $Category -SubCategory $Subcategory

    return @{
        $PropertyName = $PropertyRelevance
    }
}



Function Generate-AuditPolicyFixlets {
    $Categories = Get-AuditPolicyCategory

    $Fixlets = @()

    foreach ($Category in $Categories) {
        $Fixlets += Generate-AuditPolicyCategoryFixlets -Category $Category
    }

    return $Fixlets
}

Function Generate-AuditPolicyCategoryFixlets {
    param (
        $Category
    )

    $Subcategories = Get-AuditPolicySubCategory -Category $Category

    $Fixlets = @()

    foreach ($SubCategory in $Subcategories) {
        $Fixlets += Generate-AuditPolicySubcategoryFixlets -Category $Category -Subcategory $SubCategory
    }

    return $Fixlets
}

Function Generate-AuditPolicySubcategoryFixlets {
    param (
        $Category,
        $Subcategory
    )
    $Fixlets = @()

    $Fixlets += Generate-AuditPolicySubcategoryFixlet -Category $Category -SubCategory $Subcategory -Enable -Success
    $Fixlets += Generate-AuditPolicySubcategoryFixlet -Category $Category -SubCategory $Subcategory -Enable -Failure
    $Fixlets += Generate-AuditPolicySubcategoryFixlet -Category $Category -SubCategory $Subcategory -Disable -Success
    $Fixlets += Generate-AuditPolicySubcategoryFixlet -Category $Category -SubCategory $Subcategory -Disable -Failure

    return $Fixlets
}

Function Generate-AuditPolicySubcategoryFixlet {
    param (
        $Category,
        $SubCategory,
        [switch] $Success,
        [switch] $Failure,
        [switch] $Enable,
        [switch] $Disable
    )

    $Type = if ($Success) {"Success"} else {"Failure"}
    $Action = if ($Enable) {"Enable"}   else {"Disable"}

    $Title = "$Action $($Type.ToLowerInvariant()) auditing for the $Category / $Subcategory audit policy"
    $Description = "This Fixlet $($Action.ToLowerInvariant())s the auditing of $Subcategory events that end in $($Type.ToLowerInvariant()). This policy is defined under ""$Category"" in the Windows audit policy."
    
    $Relevance = @(Generate-AuditPolRelevance -Category $Category -SubCategory $Subcategory -Success:$($Type -eq "Success") -Failure:$($Type -eq "Failure") -Enabled:$($Action -ne "Enable"))
    $ActionScript = Generate-AuditPolActionScript -Category $Category -SubCategory $Subcategory -Success:$($Type -eq "Success") -Failure:$($Type -eq "Failure") -Enable:$($Action -eq "Enable")

    $Fixlet = Generate-BigFixFixlet -Title $Title -Description $Description -Relevance $Relevance -ActionScript $ActionScript

    $Fixlet.BES.Fixlet.DefaultAction.Description.PostLink = "to $title"

    return $Fixlet
}


$OutputDir = (Join-Path $PSScriptRoot "Output")

Remove-Item $OutputDir -Recurse -ErrorAction SilentlyContinue | out-null
New-Item $OutputDir -ItemType Directory -ErrorAction SilentlyContinue | out-null

# Generate Fixlets
$AuditPolicyFixlets = Generate-AuditPolicyFixlets

foreach ($AuditPolicyFixlet in $AuditPolicyFixlets) {
    Save-BigFixFixlet -Fixlet $AuditPolicyFixlet -Directory $OutputDir
}

write-host "Generated $($AuditPolicyFixlets.Count) Fixlets"

# Generate Analyses
$AuditPolicyAnalyses = Generate-AuditPolicyAnalyses

foreach ($AuditPolicyAnalysis in $AuditPolicyAnalyses) {
    Save-BigFixAnalysis -Analysis $AuditPolicyAnalysis -Directory $OutputDir
}

write-host "Generated $($AuditPolicyAnalyses.Count) Analyses"

write-host "Zipping the generated files"

Compress-Archive -Path Output -DestinationPath Output.zip -Force

<#
# Generate Fixlets
foreach ($CategoryKV in $AuditCategoriesToSubcategoriesToGuids.GetEnumerator()) {
    $CategoryName = $CategoryKV.Name
    $Subcategories = $CategoryKV.Value

    $AnalysisName = "Audit Policy - $CategoryName - Windows"
    $AnalysisDescription = "Audit Policy - $CategoryName - Windows"
    $AnalysisRelevance = Generate-AuditPolCategoryRelevance -Category $CategoryName
    $AnalysisProperties = [ordered] @{}

    foreach ($SubcategoryKV in $Subcategories.GetEnumerator()) {
        $SubcategoryName = $SubcategoryKV.Name
        $SubcategoryGuid = $SubcategoryKV.Value

        write-host ""
        write-host "Processing $CategoryName -> $SubcategoryName = $SubcategoryGuid"

        $Types = @("Success", "Failure")
        $Modes = @("Enable", "Disable")

        foreach ($Type in $Types) {

            # Generate an Analysis property while we're here
            $PropertyName = "Audit Policy - $CategoryName - $Type auditing for $SubCategoryName - Windows"

            $PropertyRelevance = "audit $Type of system policy of subcategories whose (name of it = ""$SubcategoryName"") of $($CategoryName.ToLowerInvariant()) category of audit policy"

            $AnalysisProperties.Add($PropertyName,$PropertyRelevance)

            # Generate Fixlets now

            foreach ($Mode in $Modes) {
                
                write-host " Creating $Type / $Mode"

                $Title = "$Mode $($type.ToLowerInvariant()) auditing for the $CategoryName / $SubcategoryName audit policy"
                $Description = "This Fixlet $($mode.ToLowerInvariant())s the auditing of $SubcategoryName events that end in $($type.ToLowerInvariant()). This policy is defined under ""$CategoryName"" in the Windows audit policy."
                
                # If we want to enable a setting, we need our relevance to check if it's disabled
                # If we want to disable a setting, we need our relevance to check if it's enabled
                $Relevance = @(Generate-AuditPolRelevance -Category $CategoryName -SubCategory $SubcategoryName -Success:$($Type -eq "Success") -Failure:$($Type -eq "Failure") -Enabled:$($Mode -ne "Enable"))
                $ActionScript = Generate-AuditPolActionScript -Category $CategoryName -SubCategory $SubcategoryName -Success:$($Type -eq "Success") -Failure:$($Type -eq "Failure") -Enable:$($Mode -eq "Enable")

                $Fixlet = Generate-BigFixFixlet -Title $Title -Description $Description -Relevance $Relevance -ActionScript $ActionScript

                $Fixlet.BES.Fixlet.DefaultAction.Description.PostLink = "to $title"

                Save-BigFixFixlet -Directory (Join-Path $PSScriptRoot "Output") -Fixlet $Fixlet
            }
        }

        $Analysis = Generate-BigFixAnalysis -Title $AnalysisName -Description $AnalysisDescription -Relevance $AnalysisRelevance -Properties $AnalysisProperties
        Save-BigFixAnalysis -Directory (Join-Path $PSScriptRoot "Output") -Analysis $Analysis
    }
}

# Generate Analyses

<#
foreach ($CategoryKV in $AuditCategoriesToSubcategoriesToGuids.GetEnumerator()) {
    $CategoryName = $CategoryKV.Name
    $Subcategories = $CategoryKV.Value

    foreach ($SubcategoryKV in $Subcategories.GetEnumerator()) {
        $SubcategoryName = $SubcategoryKV.Name
        $SubcategoryGuid = $SubcategoryKV.Value

        $Types = @("Success", "Failure")

        foreach ($Type in $Types)
        $Relevance = "audit success of system policy of subcategories whose (name of it = ""$SubcategoryName"") of $($CategoryName.ToLowerInvariant()) category of audit policy"
    }
}#>

#>