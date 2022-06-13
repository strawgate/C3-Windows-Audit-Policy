
Function Sanitize-Filename {
    param(
        [String]$Name
    )
  
    $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''

    $re = "[{0}]" -f [RegEx]::Escape($invalidChars)

    return ($Name -replace $re)

}

Function Shorten-Filename {
    param (
        [string] $Name
    )

    <#
    $Name = $Name -replace ("Config - ","")
    $Name = $Name -replace (" - Windows","")
    $Name = $Name -replace ("Audit Policy - ","")
    $Name = $Name -replace ("auditing ","")
    #>
    #$Name = $Name -replace ("Audit Policy","Audit")
    $Name = $Name -replace ("- Windows","")
    $Name = $Name -replace ("^Config - Audit Policy - ","")
    return $Name
}
