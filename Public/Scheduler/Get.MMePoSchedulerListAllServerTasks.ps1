function Get-MMePoSchedulerListAllServerTasks
{
    <#
     .SYNOPSIS
     Displays all server tasks.
     .DESCRIPTION
     Displays all server tasks. Returns the list of tasks or throws on error.
     Requires permission to view server tasks.
    #>

    TestConnectioToePoServer

    $Url = "$($ePoVar.URL)/scheduler.listAllServerTasks?:output=json"

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
