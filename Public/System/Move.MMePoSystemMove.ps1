function Move-MMePoSystemMove
{
    <#
    .SYNOPSIS
    Move systems to a specified destination group.
    .DESCRIPTION
    Move systems to a specified destination group by the name or the ID as returned by the function Get-MMePoSystemFind.
    The ID of the destination group can be find by the function Get-MMePoSystemFindGroup.
    AutoSort param - If true, system is enabled for sorting. Defaults to false.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "SystemName",
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $SystemName,

        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "SystemID",
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $SystemID,

        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [int]
        $ParentGroupID,

        [Parameter(ParameterSetName = "SystemID")]
        [Parameter(ParameterSetName = "SystemName")]
        [switch]
        $AutoSort = $false
    )

    begin
    {
        TestConnectioToePoServer
        $Systems = $SystemName -join '%2C'
        if ($AutoSort)
        {
            $Url = "$($ePoVar.URL)/system.move?names=$Systems&parentGroupId=$($ParentGroupID)&autoSort=1&:output=json"
        }
        else
        {
            $Url = "$($ePoVar.URL)/system.move?names=$Systems&parentGroupId=$($ParentGroupID)&autoSort=0&:output=json"
        }
        Write-Verbose $Url
    }
    process
    {
        $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
        if ($EpoQuery.StatusDescription -eq 'OK')
        {
            Write-Output "Move process finished: $($EpoQuery.StatusDescription)"
        }
        else
        {
            Write-Output "Something is wrong.`nMove process finished: $($EpoQuery.StatusDescription)"
        }
    }
}
