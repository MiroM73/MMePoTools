function Invoke-MMePoCoreExecuteQuery
{
    <#
     .SYNOPSIS
     Invokes ePo query by query ID
     .DESCRIPTION
     Invokes ePo query by query ID. ID can be find by function Get-MMePoCoreListQueries
     Returns the data from the execution of the query or throws on error.
     Requires permission to use queries.

     TODO:
     add  execute own query
     core.executeQuery target=<> [select=<>] [where=<>] [order=<>] [group=<>] [database=<>] [depth=<>] [joinTables=<>]
     target - The SQUID target type to query. Optionally, the database type can be prepended to the target with a '.' (for example, databaseType.target)
     select - The SQUID select clause of the query; if blank, all columns will be returned
     where - The SQUID where clause of the query; if blank, all rows will be returned
     order - The SQUID order-by clause of the query; if blank, database order will be returned
     group - The SQUID group-by clause of the query; if blank, no grouping will be performed
     database - The name of the remote database; if blank, the default database for the given database type will be used
     depth - The SQUID depth to fetch sub results (default: 5)
     joinTables - The comma-separated list of SQUID targets to join with the target type; * means join with all types
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [Int]
        $Id
    )

    TestConnectioToePoServer

    $Url = "$($ePoVar.URL)/core.executeQuery?queryId=$id&:output=json"

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    $data = ConvertFrom-Json (($EpoQuery.Content -replace 'OK:').TrimStart())
    foreach ($item in $data)
    {
        $item
    }
}
