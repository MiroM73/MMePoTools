function Get-MMePoSchedulerGetServerTask
{
    <#
    .SYNOPSIS
    Get server task by name or ID
    .DESCRIPTION
    Gets details about a specific server task. Returns the task or throws on error.
    Requires permission to run server tasks.

    Parameters:
    TaskName | TaskId - The unique id of the task or the task name
    #>

    param (
        # The Full task name
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'TaskName')]
        [String]
        $TaskName,
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'TaskID')]
        [int]
        $TaskID
    )

    TestConnectioToePoServer

    if ($TaskName)
    {
        $TaskName = $TaskName -replace ' ', '+'
        $Url = "$($ePoVar.URL)/scheduler.getServerTask?taskName=$($TaskName)&:output=json"
    }
    else
    {
        $Url = "$($ePoVar.URL)/scheduler.getServerTask?taskId=$($TaskID)&:output=json"
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
