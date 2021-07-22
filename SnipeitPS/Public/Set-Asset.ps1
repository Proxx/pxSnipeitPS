<#
    .SYNOPSIS
    Update a Asset in the Snipe-it asset system

    .DESCRIPTION
    Long description

    .PARAMETER id
    ID of the Asset

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
    Set-Asset -id 1 -status_id 1 -model_id 1 -name "Machine1"

    .EXAMPLE
    Set-Asset -id 1 -status_id 1 -model_id 1 -name "Machine1" -CustomValues = @{ "_snipeit_os_5 = "Windows 10 Pro" }

    .NOTES
    Update by Proxx (30-06-2020)
        - Pipeline aware Cmdlet
#>

function Set-Asset()
{
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]

    Param(
        [parameter(mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [int]$id,

        [parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$Name,

        [parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$Status_id,

        [parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$Model_id,

        [parameter(mandatory = $true)]
        [string]$url,

        [parameter(mandatory = $true)]
        [string]$apiKey,

        [parameter(ValueFromPipelineByPropertyName = $true)]
        [hashtable] $customfields
    )
    Begin {}

    Process {

        if (-Not $Input) {
            $Input = New-Object -TypeName PSObject -Property @{
                id = $id
                url = $url
                apiKey = $apiKey
            }
        }

        ForEach($Item in $input)
        {
            $Values = @{}

            if (-Not [String]::IsNullOrWhiteSpace($Name))
            {
                $Values.name = $Name
            }

            if (-Not [String]::IsNullOrWhiteSpace($Status_id))
            {
                $Values.status_id = $Status_id
            }

            if (-Not [String]::IsNullOrWhiteSpace($Model_id))
            {
                $Values.model_id = $Model_id
            }

            if ($customfields)
            {
                $Values += $customfields
            }

            $Body = $Values | ConvertTo-Json;

            $Parameters = @{
                Uri    = "$url/api/v1/hardware/$id"
                Method = 'Put'
                Body   = $Body
                Token  = $apiKey
            }
            If ($PSCmdlet.ShouldProcess("ShouldProcess?"))
            {
                $result = Invoke-SnipeitMethod @Parameters
            }
            else
            {
                $result = $Parameters
            }

            $result
        }
    }

    End {}
}
