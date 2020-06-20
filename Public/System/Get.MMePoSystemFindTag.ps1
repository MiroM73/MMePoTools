function Get-MMePoSystemFindTag
{
    <#
    .SYNOPSIS
    Find Tags.
    .DESCRIPTION
    Find Tags filtered by search text.
    If search text is ommitted, all tags are listed.
    #>

    param (
        [Parameter(Position = 0)]
        [string]
        $SearchText
    )

    TestConnectioToePoServer

    if (!$SearchText)
    {
        $Url = "$($ePoVar.URL)/system.findTag?:output=json"
    }
    else
    {
        $Url = "$($ePoVar.URL)/system.findTag?searchText=$($SearchText)&:output=json"
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    $data = ConvertFrom-Json (($EpoQuery.Content -replace 'OK:').TrimStart())
    foreach ($item in $data)
    {
        $item
    }
}
