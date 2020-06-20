function Get-MMePoSystemFindGroup
{
    <#
    .SYNOPSIS
    Finds groups in the System Tree filtered by the search text.
    .DESCRIPTION
    Finds groups in the System Tree filtered by search text.
    Requires access to at least one group in the System Tree.
    Wildcards are not supported, but it is possible to use partially parts.
    If search text is ommited, all groups are listed.
    #>

    param (
        [Parameter(Position = 0)]
        [string]
        $SearchText
    )

    TestConnectioToePoServer

    if (!$SearchText)
    {
        $Url = "$($ePoVar.URL)/system.findGroups?:output=json"
    }
    else
    {
        $Url = "$($ePoVar.URL)/system.findGroups?searchText=$($SearchText)&:output=json"
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    $data = ConvertFrom-Json (($EpoQuery.Content -replace 'OK:').TrimStart())
    foreach ($item in $data)
    {
        $item
    }
}
