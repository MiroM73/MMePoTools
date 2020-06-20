function Get-MMePoClientTaskFind
{
    <#
    .SYNOPSIS
    Find Client Tasks.
    .DESCRIPTION
    Finds client tasks filtered by supplied search text.
    If search text is ommited, all tasks are listed.
    Requires view permission for at least one product.
    #>

    param (
        [Parameter(Position = 0)]
        [string]
        $SearchText
    )

    TestConnectioToePoServer

    if (!$SearchText)
    {
        $Url = "$($ePoVar.URL)/clienttask.find?:output=json"
    }
    else
    {
        $Url = "$($ePoVar.URL)/clienttask.find?searchText=$($SearchText)&:output=json"
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    $data = ConvertFrom-Json (($EpoQuery.Content -replace 'OK:').TrimStart())
    foreach ($item in $data)
    {
        $item
    }
}
