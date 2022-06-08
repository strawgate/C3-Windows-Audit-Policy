$ReferenceDir = Get-Item (Join-Path $PSScriptRoot "Reference")
$OutputDir = Get-Item (Join-Path $PSScriptRoot "Output")

$ReferenceFixlets = Get-ChildItem -File $ReferenceDir

write-host "Checking $($ReferenceFixlets.count) Fixlets"

foreach ($ReferenceFixlet in $ReferenceFixlets) {
    $ReferenceFixletName = $ReferenceFixlet.Name

    $OutputFixlet = (Join-Path $OutputDir $ReferenceFixletName)


    $ReferenceFixletContents = Get-Content $ReferenceFixlet
    $OutputFixletContents = Get-Content $OutputFixlet

    $Result = Compare-Object $ReferenceFixletContents $OutputFixletContents

    if ($Result -ne $null) {
        write-host "Comparing $ReferenceFixletName"
        write-host $Result
    }
}