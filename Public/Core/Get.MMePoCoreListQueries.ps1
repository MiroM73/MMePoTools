function Get-MMePoCoreListQueries
{
    <#
    .SYNOPSIS
    Get all queries
    .DESCRIPTION
    Displays all queries that the user is permitted to see. Returns the list of
    queries or throws on error.
    Requires permission to use queries.

    Output NoteProperties:
    id            : 1
    name          : Effective permissions for users
    description   : Shows all permissions for each user
    conditionSexp : Permission Does not equal "%%NOEPOROLES%%"
    groupName     : Permissions
    databaseType  :
    target        : EntitlementView
    createdBy     : ePoServerAdmin
    createdOn     : 2016-05-16T14:26:50+02:00
    modifiedBy    : ePoServerAdmin
    modifiedOn    : 2016-05-16T14:26:50+02:00

    .EXAMPLE
    C:\PS>Get-MMePoCoreListQueries | ? name -match 'effective'
    id            : 1
    name          : Effective permissions for users
    description   : Shows all permissions for each user
    conditionSexp : Permission Does not equal "%%NOEPOROLES%%"
    groupName     : Permissions
    userName      : Public
    databaseType  :
    target        : EntitlementView
    createdBy     : ePoServerAdmin
    createdOn     : 2016-05-16T14:26:50+02:00
    modifiedBy    : ePoServerAdmin
    modifiedOn    : 2016-05-16T14:26:50+02:00

    .EXAMPLE
    D:\ PS>(Get-MMePoCoreListQueries | ? createdby -eq 'ePoServerAdmin').count
    52

    .EXAMPLE
    D:\ PS>Get-MMePoCoreListQueries | group createdby -NoElement
    Count Name
    ----- ----
     52 ePoServerAdmin
    351 admin123456
     66 user12345
     18 oper123456
     22 oper1234

    .INPUTS
        None
    .OUTPUTS
        PSCustomObject
    #>

    TestConnectioToePoServer

    $Url = "$($ePoVar.URL)/core.listQueries?:output=json"

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
