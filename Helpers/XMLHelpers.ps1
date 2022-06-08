
function Format-XML {
    <#
      .SYNOPSIS
      Pretty print the XML so it's easier for a person to read
      
      .DESCRIPTION
      Pretty print the XML so it's easier for a person to read
      
      .PARAMETER xml
      Parameter XML Object
      
      .EXAMPLE
      Format-XML $xml
      
      .NOTES
      4 Spaces per Indent by default
      #>
    param (
        [xml]$xml
    )
  
    $StringWriter = New-Object System.IO.StringWriter
    $XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter

    $xmlWriter.Formatting = "indented"
    $xmlWriter.Indentation = 4

    $xml.WriteContentTo($XmlWriter)

    $XmlWriter.Flush()
    $StringWriter.Flush()

    Write-Output $StringWriter.ToString()
}