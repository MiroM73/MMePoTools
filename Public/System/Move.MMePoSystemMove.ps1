function Move-MMePoSystemMove
{
    <#
    .SYNOPSIS
    Move systems to a specified destination group.
    .DESCRIPTION
    Move systems to a specified destination group by the name or the ID as returned by the function Get-MMePoSystemFind.
    The ID of the destination group can be find by the function Get-MMePoSystemFindGroup.
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
        $ParentGroupID
    )

    begin
    {
        TestConnectioToePoServer
        $Systems = $SystemName -join '%2C'
        $Url = "$($ePoVar.URL)/system.move?names=$Systems&parentGroupId=$($ParentGroupID)&:output=json"
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
