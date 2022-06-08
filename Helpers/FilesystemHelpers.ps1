
Function Sanitize-Filename {
    param(
        [String]$Name
    )
  
    $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''

    $re = "[{0}]" -f [RegEx]::Escape($invalidChars)

    return ($Name -replace $re)

}
