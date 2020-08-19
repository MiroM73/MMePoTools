function Get-MMePoCoreListPermSets
{
    <#
    .SYNOPSIS
    List permission sets
    .DESCRIPTION
    List permission sets in the system optionally filtered by username or id.
    Note: Dynamically assigned permission sets are not represented. Returns the list of permission sets or throws on error.
    Requires global administrator privilege.
    #>

    [CmdletBinding(DefaultParameterSetName = 'UserName')]
    param (
        #unique name of the user
        [Parameter(ParameterSetName = 'UserName')]
        [string]
        $UserName,
        #unique id of the user
        [Parameter(ParameterSetName = 'UserID')]
        [int]
        $UserID
    )

    TestConnectioToePoServer

    if ($PSBoundParameters.Count -gt 0)
    {
        if (-not [string]::IsNullOrEmpty($UserName))
        {
            $Url = "$($ePoVar.URL)/core.listPermSets?userName=$UserName&:output=json"
        }
        elseif ($UserID -gt 0)
        {
            $Url = "$($ePoVar.URL)/core.listPermSets?userId=$UserID&:output=json"
        }
        else
        {
            $Url = "$($ePoVar.URL)/core.listPermSets?:output=json"
        }
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    if ($EpoQuery.StatusDescription -eq 'OK')
    {
        $data = ConvertFrom-Json (($EpoQuery.Content -replace 'OK:', '').TrimStart())
        if ($data.length -gt 0)
        {
            foreach ($item in $data)
            {
                $item
            }
        }
        else
        {
            Write-Verbose "There are no User Perm Sets for entered query."
            Write-Verbose $Url
        }
    }
}
