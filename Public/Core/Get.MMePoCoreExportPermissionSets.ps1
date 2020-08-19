function Get-MMePoCoreExportPermissionSets
{
    <#
    .SYNOPSIS
    Exports all permission sets.
    .DESCRIPTION
    Exports all permission sets. Returns the permission sets as a string of XML or throws on error.
    Requires administrator rights.
    Default output is user's console.
    .EXAMPLE
    PS>Get-MMePoCoreExportPermissionSets
    Displays the all permission sets to the user's console.
    .EXAMPLE
    PS>Get-MMePoCoreExportPermissionSets > x:\ePo_perm_sets.xml
    Redirects the all permission sets output into the x:\ePo_perm_sets.xml file.
    #>

    TestConnectioToePoServer

    $Url = "$($ePoVar.URL)/core.exportPermissionSets?"

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    if ($EpoQuery.Content -match '^OK')
    {
        $data = ($EpoQuery.Content -replace 'OK:', '').TrimStart()
        return $data
    }
    else
    {
        Write-Error $EpoQuery.StatusDescription
        Write-Error $EpoQuery.Content
        Write-Error $Url
    }
}
