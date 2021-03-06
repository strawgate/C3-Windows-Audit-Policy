$ErrorActionPreference = "stop"
Set-Strictmode -version 3

$HelperDir = (Join-Path $PSScriptRoot "Helpers")

# Load our Audit Policy-related functions
. (Join-Path $HelperDir "AuditPolicyInfo.ps1")
. (Join-Path $HelperDir "BESTemplates.ps1")
. (Join-Path $HelperDir "BESRelevanceHelpers.ps1")
. (Join-Path $HelperDir "FilesystemHelpers.ps1")
. (Join-Path $HelperDir "HTMLHelpers.ps1")
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
    $Prefix = "not "
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
    $Description = @"
$HTMLCSS
<body>
Returns information related to the current state of audit policies under the $Category audit policy category.
<h6>$Category Audit Information</h6>
<p>$(Get-AuditPolicyCategoryDescription -Category $Category)</p>
$Copyright
</body>
"@
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

    $Title = "Config - Audit Policy - $Action $($Type.ToLowerInvariant()) auditing for $Category / $Subcategory - Windows"
    $ActionTitle = "$($Action.ToLowerInvariant()) $($Type.ToLowerInvariant()) auditing for $Category / $Subcategory"

    $Description = @"
$HTMLCSS
<body>

<p>This Fixlet $($Action.ToLowerInvariant())s the auditing of $Subcategory events that end in $($Type.ToLowerInvariant()).</p>
<br>
<h6>$Category Audit Information</h6>
<p>$(Get-AuditPolicyCategoryDescription -Category $Category)</p>
<h6>Configuring Audit Policies</h6>
<p>Audit Policies are configured using secpol.msc under "Advanced Audit Policy Configuration" or via Group Policy by navigating to "Windows Settings" then "Security Settings" then "Advanced Audit Policy Configuration".</p> The setting this Fixlet changes is defined under the ""$Category"" section of the Advanced Audit Policy Configuration in a setting called, ""$Subcategory"".
<h6>Limitations</h6>
<p>Audit Policy settings applied via Group Policy will take precedence over settings applied via BigFix.</p>
<h6>Event Volume</h6>
<p>Finding the right balance between auditing enough network and computer activity and auditing too little network and computer activity can be challenging. You can achieve this balance by identifying the most important resources, critical activities, and users or groups of users. Then design a security audit policy that targets these resources, activities, and users.</p>
$Copyright
</body>
"@
    
    $Relevance = @(Generate-AuditPolRelevance -Category $Category -SubCategory $Subcategory -Success:$($Type -eq "Success") -Failure:$($Type -eq "Failure") -Enabled:$($Action -ne "Enable"))
    $ActionScript = Generate-AuditPolActionScript -Category $Category -SubCategory $Subcategory -Success:$($Type -eq "Success") -Failure:$($Type -eq "Failure") -Enable:$($Action -eq "Enable")

    $Fixlet = Generate-BigFixFixlet -Title $Title -Description $Description -Relevance $Relevance -ActionScript $ActionScript

    $Fixlet.BES.Fixlet.DefaultAction.Description.PostLink = " to $ActionTitle"

    return $Fixlet
}


$OutputDir = (Join-Path $PSScriptRoot "Output")
$FixletOutputDir = (Join-Path $PSScriptRoot "Output\Individual Fixlets")
$AnalysisOutputDir = (Join-Path $PSScriptRoot "Output\Individual Analyses")

Remove-Item $OutputDir -Recurse -ErrorAction SilentlyContinue | out-null
New-Item $OutputDir -ItemType Directory -ErrorAction SilentlyContinue | out-null
New-Item $FixletOutputDir -ItemType Directory -ErrorAction SilentlyContinue | out-null
New-Item $AnalysisOutputDir -ItemType Directory -ErrorAction SilentlyContinue | out-null

# Generate Fixlets
$AuditPolicyFixlets = Generate-AuditPolicyFixlets

foreach ($AuditPolicyFixlet in $AuditPolicyFixlets) {
    Save-BigFixFixlet -Fixlet $AuditPolicyFixlet -Directory $FixletOutputDir
}

write-host "Generated $($AuditPolicyFixlets.Count) Fixlets"

# Generate Analyses
write-host "Generating Audit Policy Category Analyses"
$AuditPolicyAnalyses = Generate-AuditPolicyAnalyses

foreach ($AuditPolicyAnalysis in $AuditPolicyAnalyses) {
    Save-BigFixAnalysis -Analysis $AuditPolicyAnalysis -Directory $AnalysisOutputDir
}

# Generate STIG Analyses
write-host "Generating STIG Analyses"
& (Join-Path $PSScriptRoot "STIG\Generate-STIGAnalyses.ps1") -OutDir $AnalysisOutputDir

write-host "Generated $($AuditPolicyAnalyses.Count) Analyses"

write-host "Copying other fixlets to output directory"

$OtherFixlets = Get-ChildItem (Join-Path $PSScriptRoot "Other Fixlets") -file

Foreach ($OtherFixlet in $OtherFixlets) {
    $SourceFileName = $OtherFixlet.Name
    $SourceFilePath = $OtherFixlet.FullName

    $DestinationFileName = Shorten-Filename -Name $SourceFileName
    $DestinationFilePath = (Join-Path $FixletOutputDir $DestinationFileName) 

    Copy-Item $SourceFilePath $DestinationFilePath
}

Copy-Item (Join-Path $PSScriptRoot "Distributables\Readme.md") (Join-Path $OutputDir "Readme.md")

# Shorten File Names

$OutputFiles = Get-ChildItem $OutputDir -file -recurse -Filter "*.bes"

Join-BESContent -File $OutputFiles -OutFile (Join-Path $OutputDir "C3 Windows Audit Policy - All Analyses and Fixlets.bes")

write-host "Zipping the generated files"

Compress-Archive -Path Output\* -DestinationPath Output.zip -Force