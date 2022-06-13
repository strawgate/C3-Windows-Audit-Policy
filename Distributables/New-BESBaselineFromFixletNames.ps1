param (
    $Uri,
    $Credential,
    [string] $SiteType = "custom",
    [string] $SiteName = "C3-Windows-Audit-Policy",
    [string[]] $Fixlet = @("Config - Reset Audit Policy - Windows"),
    [string] $OutFile
)

Set-Strictmode -Version 3
$ErrorActionPreference = "Stop"

$BaselineTemplate = [xml] @"
<?xml version="1.0" encoding="UTF-8"?>
<BES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="BES.xsd">
    <Baseline>
       <Title>Custom Baseline</Title>
       <Description>My Baseline</Description>
       <Relevance>true</Relevance>
       <BaselineComponentCollection>
          <BaselineComponentGroup>
          </BaselineComponentGroup>
       </BaselineComponentCollection>
    </Baseline>
</BES>
"@

class BESConnection {
    [Uri] $Uri
    [PSCredential] $Credential
    [Boolean] $TrustedConnection

    BESConnection () {

    }

    BESConnection ([Uri] $Uri, [PSCredential] $Credential, [boolean] $TrustedConnection) {
        $this.ConnectionCreator($Uri, $Credential, $TrustedConnection)
    }

    BESConnection ([Uri] $Uri, [PSCredential] $Credential, [boolean] $TrustedConnection, [Boolean] $Test) {
        $this.ConnectionCreator($Uri, $Credential, $TrustedConnection)

        if ($Test -and -not $this.Test()) {
            throw "Invalid connection information"
        }
    }

    [void] ConnectionCreator ([Uri] $Uri, [PSCredential] $Credential, [boolean] $TrustedConnection) {
        $This.Uri = $Uri
        $This.Credential = $Credential
        $This.TrustedConnection = $TrustedConnection
    }

    [boolean] Test () {

        $TestUri = $this.GetUri("help")

        $this.InvokeRequest(@{"Uri" = $TestUri})

        return $true
    }

    [Uri] GetURI () {
        return $this.Uri
    }

    [Uri] GetURI ( [string] $Path ) {
        return $this.GetUri($Path, $null)
    }

    [Uri] GetURI ( [string] $Path, [string[]] $Query ) {
        $Builder = [System.UriBuilder]::New()

        $Builder.Scheme = $this.Uri.Scheme
        $Builder.Host = $this.Uri.Host
        $Builder.Port = $this.Uri.Port
        
        $Builder.Path = "api/" + $Path
        if ($Query -ne $null) {

            $Builder.Query = $Query -Join "&"
        }

        return $Builder.Uri
    }

    [Uri] GetURI ( [string] $Path, [int32] $Id ) {
        $Builder = [System.UriBuilder]::New()

        $Builder.Scheme = $this.Uri.Scheme
        $Builder.Host = $this.Uri.Host
        $Builder.Port = $this.Uri.Port
        $Builder.Path = ( $Path + "/" + $id )

        return $Builder.Uri
    }

    [object] InvokeRequest ( [hashtable] $Parameters) {
        write-verbose "Invoking $(ConvertTo-Json $Parameters)"

        $RequestParams = $Parameters.Clone()

        if ($null -eq $RequestParams["ContentType"]) {
            $RequestParams["ContentType"] = "application/xml"
        }
        
        $Response = Invoke-Webrequest    -Credential $this.Credential `
                                         -SkipCertificateCheck:(-not $this.TrustedConnection) `
                                         @RequestParams
        
        $ResponseObj = $null

        if ($RequestParams["ContentType"] -eq "application/xml") {
            $ResponseObj = [xml] $Response.Content
            write-verbose $ResponseObj.OuterXml
        }

        if ($RequestParams["ContentType"] -eq "application/json") {
            $ResponseObj = @(ConvertFrom-Json $Response.Content -AsHashtable -depth 10).Foreach{$_}
            write-Verbose "Returned $(ConvertTo-Json $ResponseObj)"
        }


        return $ResponseObj
    }

    [object] InvokeQuery ( [string] $Relevance ) {
        return $this.InvokeRequest(
            @{
                "Uri" = $this.GetURI("query", 
                    @("relevance=$Relevance","output=json")
                )
                "ContentType" = "application/json"
            }
        )
    }

    [object] GET ( [String] $Path ) {
        return $this.InvokeRequest(@{"Uri" = ($This.GetURI($Path))})
    }

    [object] GET ( [Uri] $Uri ) {
        return $this.InvokeRequest(@{"Uri" = $Uri})
    }

    [object] POST ( [String] $Path, [string] $Body ) {
        return $this.InvokeRequest(@{"Uri" = ($This.GetURI($Path)); "Body" = $Body; "Method" = "POST"})
    }

    [object] POST ( [Uri] $Uri, [string] $Body ) {
        return $this.InvokeRequest(@{"Uri" = $Uri; "Body" = $Body; "Method" = "POST"})
    }

    [object] PUT ( [Uri] $Uri, [string] $Body ) {
        return $this.InvokeRequest(@{"Uri" = $Uri; "Body" = $Body; "Method" = "PUT"})
    }
}

Function New-BESBaseline {
    param (
        [BESConnection] $Connection,
        [string] $SiteType,
        [string] $SiteName,
        [xml] $Baseline
    )

    return $Connection.POST(
        "baselines/$SiteType/$SiteName", ('<?xml version="1.0" encoding="UTF-8"?>' + $Baseline.BES.OuterXml)
    )
}

Function Invoke-BESSessionQuery {
    param (
        [BESConnection] $Connection,
        [String] $Relevance
    )

    return $Connection.InvokeQuery($Relevance)
}

Function New-BESServerConnection {
    param (
        [string]$Server,
        [PSCredential] $Credential,
        [Boolean] $TrustedConnection
    )

    return [BESConnection]::new($Server, $Credential, $TrustedConnection)
}

if ($Credential -eq $null) { 
    $Credential = Get-Credential
}

$BESConnection = New-BESServerConnection -Server "https://prd-bfx-srv-01.ad.weaston.org:52311/api" -Credential $Credential -TrustedConnection $False

$SitePath = "site/$SiteType/$SiteName"

$Site = $BESConnection.GET($SitePath).BES.CustomSite

$FixletsInSite = $BESConnection.GET("$SitePath\content").BESAPI.Fixlet

<#

<Fixlet Resource="https://prd-bfx-srv-01.ad.weaston.org:52311/api/fixlet/custom/C3-Windows-Audit-Policy/20458" LastModified="Sat, 11 Jun 2022 16:59:36 +0000">
    <Name>Config - Audit Policy - Disable Command Line data in Process Creation Events - Windows</Name>
    <ID>20458</ID>
</Fixlet>

#>

$NewBaseline = $BaselineTemplate.Clone()

foreach ($FixletInSite in $FixletsInSite) {
    $SiteUrl = $Site.GatherURL
    $id = $FixletInSite.Id
    $name = $FixletInSite.Name

    if ($FixletInSite.Name -notin $Fixlet) { continue; <# Skip #>}

    write-host "Adding $name ($id) to Baseline"
    
    $NewBaselineComponent = $NewBaseline.CreateElement("BaselineComponent")
    $NewBaselineComponent.SetAttribute("IncludeInRelevance", "true")
    $NewBaselineComponent.SetAttribute("SourceSiteURL", $SiteUrl)
    $NewBaselineComponent.SetAttribute("SourceID", $id)
    $NewBaselineComponent.SetAttribute("ActionName", "Action1")

    $Parentnode = $NewBaseline.SelectSingleNode("BES/Baseline/BaselineComponentCollection/BaselineComponentGroup")
    #[void] $ParentNode.AppendChild($NewBaselineComponent)    
}


New-BESBaseline -Connection $BESConnection -SiteType $SiteType -SiteName $SiteName -Baseline $NewBaseline

$NewBaseline.Save((Join-Path $PSScriptRoot "Baseline.bes"))

write-host "Done"