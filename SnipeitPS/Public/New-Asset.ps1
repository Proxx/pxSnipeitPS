<#
    .SYNOPSIS
    Add a new Asset to Snipe-it asset system

    .DESCRIPTION
    Long description

    .PARAMETER Tag
    Asset Tag for the Asset

    .PARAMETER Name
    Name of the Asset

    .PARAMETER Status_id
    Status ID of the asset, this can be got using Get-Status

    .PARAMETER Model_id
    Model ID of the asset, this can be got using Get-Model

    .PARAMETER url
    URL of Snipeit system, can be set using Set-Info command

    .PARAMETER apiKey
    Users API Key for Snipeit, can be set using Set-Info command

    .PARAMETER customfields
    Hastable of custom fields and extra fields that need passing through to Snipeit

    .EXAMPLE
    New-Asset -status_id 1 -model_id 1 -name "Machine1"

    .EXAMPLE
    New-Asset -status_id 1 -model_id 1 -name "Machine1" -CustomValues = @{ "_snipeit_os_5 = "Windows 10 Pro" }
#>

function New-Asset()
{
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]

    Param(
        [parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$tag,

        [parameter(mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Name,

        [parameter(mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [int]$Status_id,

        [parameter(mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [int]$Model_id,

        [parameter(mandatory = $true)]
        [string]$url,

        [parameter(mandatory = $true)]
        [string]$apiKey,

        [parameter(ValueFromPipelineByPropertyName = $true)]
        [hashtable] $customfields
    )

    Begin {

    }

    Process {
        $Values = @{}

        if ($PSBoundParameters.ContainsKey('Name'))
        {
            $Values.name = $Name
        }
        if ($PSBoundParameters.ContainsKey('Status_id'))
        {
            $Values.status_id = $Status_id
        }
        if ($PSBoundParameters.ContainsKey('Model_id'))
        {
            $Values.model_id = $Model_id
        }
        if ($PSBoundParameters.ContainsKey('tag'))
        {
            $Values.asset_tag = $tag
        }
    
        if ($PSBoundParameters.ContainsKey('customfields'))
        {
            $Values += $customfields
        }
    
        $Body = $Values | ConvertTo-Json;
    
        $Parameters = @{
            Uri    = "$url/api/v1/hardware"
            Method = 'Post'
            Body   = $Body
            Token  = $apiKey
        }
    
        If ($PSCmdlet.ShouldProcess("ShouldProcess?"))
        {
            $result = Invoke-SnipeitMethod @Parameters
        }
    
        $result
    }

    End {

    }
    
}
