function Get-MMePoPolicyFind
{
    <#
    .SYNOPSIS
    Finds policies filtered by specified search text.
    .DESCRIPTION
    policy.find [searchText]
    Finds policies filtered by specified search text in all policy properties
    featureId, featureName, objectId, objectName, objectNotes
    Requires view permission for at least one product
    Parameters:
    searchText (param 1) - Search text. Wildcards and regular expressions are not
    supported.
    .EXAMPLE
    Get-MMePoPolicyFind "policyname"
    Find the all policy configurations with "policyname" string.
    .EXAMPLE
    Get-MMePoPolicyFind -PolicyName 'VIRUS' | ft -AutoSize
    #>

    [CmdletBinding()]

    param (
        # It is possible to use any part of searching string, but not wildcards or regex.
        [string]
        $PolicyName
    )

    TestConnectioToePoServer

    if ([string]::IsNullOrEmpty($PolicyName))
    {
        $Url = "$($ePoVar.URL)/policy.find?:output=json"
    }
    else
    {
        $Url = "$($ePoVar.URL)/policy.find?searchText=$($PolicyName)&:output=json"
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    $Data = ConvertFrom-Json ($EpoQuery.Content -replace 'OK:').TrimStart()

    $Data
}
