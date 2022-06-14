Set-StrictMode -Version 3
$ErrorActionPreference = "stop"

$OtherFixletFiles = Get-ChildItem (Join-Path $PSScriptRoot "Other Fixlets") -File

foreach ($FixletFile in $OtherFixletFiles) {
    $Fixlet = [xml] (Get-Content -Raw $FixletFile.FullName)

    $BaseNode = $null
    if ($Fixlet.BES.SelectSingleNode("Analysis")) {
        $BaseNode = $Fixlet.BES.Analysis 
    } elseif ($Fixlet.BES.SelectSingleNode("Fixlet")) {
        $BaseNode = $Fixlet.BES.Fixlet 

        $BaseNode.Category = "Audit Policy"
    } else {
        throw "Unknown object type"
    }

    $BaseNode.Source = "C3 Audit Policy"

    if ($BaseNode.SelectSingleNode("MIMEField")) {
        $BaseNode.RemoveChild($BaseNode.SelectSingleNode("MIMEField"))
    }

    [void] $Fixlet.Save($FixletFile.FullName)

    $Content = Get-Content $FixletFile.Fullname
    $Content = $Content -replace ("^        ","`t`t`t`t")
    $Content = $Content -replace ("^      ","`t`t`t")
    $Content = $Content -replace ("^    ","`t`t")
    $Content = $Content -replace ("^  ","`t")
    #$Content = $Content -replace ("</h6>","</h6>`r`n")
    #$Content = $Content -replace ("</p>","</p>`r`n")
    Set-Content -Path ($FixletFile.FullName) -Value $Content
}