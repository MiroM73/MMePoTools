function Get-MMePoCoreListUsers
{
    <#
    .SYNOPSIS
    List users in the system
    .DESCRIPTION
    List users in the system optionally filtered by permission set name or id.
    Returns the list of users or throws on error.
    Requires administrator rights.
    Parameters:
        [permSetName (param 1) | permSetId] - Either the unique id or name of the permission set
    .EXAMPLE
    PS>Get-MMePoCoreListUsers
    list all ePo users
    #>

    [CmdletBinding(DefaultParameterSetName = 'PermSetName')]
    param (
        #the unique name of the permission set
        [Parameter(ParameterSetName = 'PermSetName')]
        [string]
        $PermSetName,
        #the unique id of the permission set
        [Parameter(ParameterSetName = 'PermSetId')]
        [int]$PermSetId
    )

    TestConnectioToePoServer

    if ($PSBoundParameters.Count -gt 0)
    {
        if ([string]::IsNullOrEmpty($PermSetName))
        {
            $Url = "$($ePoVar.URL)/core.listUsers?permSetId=$PermSetId&:output=json"
        }
        else
        {
            $Url = "$($ePoVar.URL)/core.listUsers?permSetName=$PermSetName&:output=json"
        }
    }
    else
    {
        $Url = "$($ePoVar.URL)/core.listUsers?:output=json"
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    if ($EpoQuery.StatusDescription -eq 'OK')
    {
        $data = ConvertFrom-Json (($EpoQuery.Content -replace 'OK:', '').TrimStart())
        foreach ($item in $data)
        {
            $item
        }
    }
}
