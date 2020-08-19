function Get-MMePoRepositoryFind
{
    <#
    .SYNOPSIS
    Finds repositories filtered by specified search text.
    .DESCRIPTION
    Finds repositories filtered by specified search text.
    Requires repository view permission.
    searchText (param 1) - Search text. Wildcards and regular expressions are not supported.
    .EXAMPLE
    PS>Get-MMePoRepositoryFind
    list all repositories
    .EXAMPLE
    PS>Get-MMePoRepositoryFind -SearchText asdfg
    list repositories containing asdfg text in their names
    #>

    [CmdletBinding()]
    param (
        #Search text. Wildcards and regular expressions are not supported.
        [string]
        $SearchText
    )

    TestConnectioToePoServer

    if (-not [string]::IsNullOrEmpty($SearchText))
    {
        $Url = "$($ePoVar.URL)//repository.find?searchText=$SearchText&:output=json"
    }
    else
    {
        $Url = "$($ePoVar.URL)//repository.find?:output=json"
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
