function Get-MMePoCoreListPermSets
{
    <#
    .SYNOPSIS
    Get all user permission sets
    .DESCRIPTION
    List permission sets in the system.
    Requires administrator rights.
    #>

    TestConnectioToePoServer

    $Url = "$($ePoVar.URL)/core.listPermSets?:output=json"

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
