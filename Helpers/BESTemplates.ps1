Function Join-BESContent {
    param (
        [string[]] $File,
        [string] $OutFile
    )

    $FirstFile = $File[0]

    $Collection = [xml] (Get-Content -raw $FirstFile)
    
    foreach ($thisFile in $File) {
        $Object = [xml] (Get-Content -raw $thisFile)
        $Node = $Object.SelectSingleNode("BES").FirstChild
        $NewNode = $Collection.ImportNode($Node, $True)
        [void] $Collection.BES.AppendChild($NewNode)
    }

    $Collection.Save($OutFile)
} 

$FixletTemplate = [xml]@"
<?xml version="1.0" encoding="UTF-8"?>
<BES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="BES.xsd">
	<Fixlet>
		<Title></Title>
		<Description></Description>
        <Category>Audit Policy</Category>
		<DownloadSize>0</DownloadSize>
		<Source>C3 Audit Policy</Source>
		<SourceID></SourceID>
		<SourceReleaseDate>$((get-date).tostring("yyyy-MM-dd"))</SourceReleaseDate>
		<SourceSeverity></SourceSeverity>
		<DefaultAction ID="Action1">
			<Description>
				<PreLink>Click </PreLink>
				<Link>here</Link>
				<PostLink></PostLink>
			</Description>
			<ActionScript MIMEType="application/x-Fixlet-Windows-Shell"></ActionScript>
		</DefaultAction>
	</Fixlet>
</BES>
"@

$AnalysisTemplate = [xml] @"
<?xml version="1.0" encoding="UTF-8"?>
<BES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="BES.xsd">
	<Analysis>
		<Title></Title>
		<Description></Description>
		<Category>Audit Policy</Category>
	</Analysis>
</BES>
"@


Function Save-BigFixAnalysis {
    param (
        [xml] $Analysis,
        $Directory
    )

    $FileName = (Sanitize-Filename -Name $Analysis.BES.Analysis.Title) + ".bes"
    
    # Remove any double spaces
    $FileName = $FileName.Replace("  "," ")
    
    $FilePath = (Join-Path $Directory $FileName)

    Set-Content -Path $FilePath -Value (Format-XML $Analysis)
}
Function Save-BigFixFixlet {
    param (
        [xml] $Fixlet,
        $Directory
    )

    $FileName = (Sanitize-Filename -Name $Fixlet.BES.Fixlet.Title) + ".bes"

    # Remove any double spaces
    $FileName = $FileName.Replace("  "," ")

    $FilePath = (Join-Path $Directory $FileName)

    Set-Content -Path $FilePath -Value (Format-XML $Fixlet)
}

Function Generate-BigFixAnalysis {
    param (
        [string] $Title,
        [string] $Description,
        [string[]] $Relevance,
        $Properties,
        [switch] $asString
    )

    $thisNewAnalysis = $AnalysisTemplate.Clone()

    $thisNewAnalysis.BES.Analysis.Title = $Title
    $thisNewAnalysis.BES.Analysis.Description = $Description
    foreach ($RelevanceStatement in $Relevance) {
        $newElement = $thisNewAnalysis.CreateElement("Relevance")
        $CategoryNode = $thisNewAnalysis.BES.Analysis.SelectNodes("Category")

        [void] $thisNewAnalysis.BES.Analysis.InsertBefore($newElement,$CategoryNode[0])

        $newElement.InnerText = $RelevanceStatement
    }

    $PropertyId = 1
    $EvaluationPeriod = "PT12H"
    foreach ($PropertyKV in $Properties.GetEnumerator()) {
        $PropertyName = $PropertyKV.Name
        $PropertyRelevance = $PropertyKV.Value
        
        $newElement = $thisNewAnalysis.CreateElement("Property")
        $newElement.SetAttribute("Name", $PropertyName)
        $newElement.SetAttribute("ID", $PropertyId)
        $newElement.SetAttribute("EvaluationPeriod", $EvaluationPeriod)

        [void] $thisNewAnalysis.BES.Analysis.AppendChild($newElement)

        $newElement.InnerText = $PropertyRelevance
        $PropertyId ++
    }

    if ($asString) {
        return $thisNewAnalysis.InnerXml
    }
    else {
        return $thisNewAnalysis
    }
}

Function Generate-BigFixFixlet {
    param (
        [string] $Title,
        [string] $Description,
        [string] $Actionscript,
        [string[]] $Relevance,
        [switch] $asString
    )

    $thisNewFixlet = $FixletTemplate.Clone()

    $thisNewFixlet.BES.Fixlet.Title = $Title
    $thisNewFixlet.BES.Fixlet.Description = $Description
    foreach ($RelevanceStatement in $Relevance) {
        $newElement = $thisNewFixlet.CreateElement("Relevance")

        $CategoryNode = $thisNewFixlet.BES.Fixlet.SelectNodes("Category")

        [void] $thisNewFixlet.BES.Fixlet.InsertBefore($newElement,$CategoryNode[0])

        $newElement.InnerText = $RelevanceStatement
    }

    $thisNewFixlet.BES.Fixlet.DefaultAction.ActionScript.InnerText = $Actionscript

    if ($asString) {
        return $thisNewFixlet.InnerXml
    }
    else {
        return $thisNewFixlet
    }
}