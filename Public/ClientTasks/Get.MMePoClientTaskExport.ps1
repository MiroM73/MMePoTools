function Get-MMePoClientTaskExport
{
    <#
    .SYNOPSIS
    View / Export client tasks.
    .DESCRIPTION
    View / Exports client tasks
    Requires view permission for at least one product.
    If the parameter $FileName is omiited, output is displayed on the console.
    .EXAMPLE
    Get-MMePoClientTaskExport -Name '^Install DLP$'
    Find exactly "Install DLP" task.
    .EXAMPLE
    Get-MMePoClientTaskExport -Name 'Install DLP'
    Find all tasks whose name contains "Install DLP" string.
    .EXAMPLE
    Get-MMePoClientTaskExport -FileName export
    Export the client tasks configuration in to the c:\reports\export.xml file on the ePo server.
    .EXAMPLE
    Get-MMePoClientTaskExport -FileName "export$(([datetime]::now).tostring("yyyyMMddhhmmss"))"
    Export the client tasks configuration in to the c:\reports\exportACTUALDATETIME.xml file on the ePo server.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Name')]

    param (
        # Name - the name of the task you are looking for.
        # It is possible to use regular expression like -match operator uses.
        [Parameter(Position = 0, Mandatory = $false, ParameterSetName = 'Name')]
        [string]
        $Name,
        # ProductID - The product ID as returned from Get-MMePoClientTaskFind command.
        [Parameter(Position = 1, Mandatory = $false)]
        [int]
        $ProductID,
        # FileName - File name to export. The exported file is saved on the ePo server.
        # Default path is c:\reports
        # Default extension xml is used automaticaly.
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName = 'FileName')]
        [string]
        $FileName
    )

    TestConnectioToePoServer

    if ($ProductId)
    {
        $Url = "$($ePoVar.URL)/clienttask.export?productId=$($ProductId)"
    }
    else
    {
        $Url = "$($ePoVar.URL)/clienttask.export"
    }

    if (!$FileName)
    {
        $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
        $EpoQuery = ($EpoQuery.Content -replace 'OK:').TrimStart()
        $Data = [xml]$EpoQuery
        foreach ($Instance in $($Data.EPOTaskSchema.EPOTaskObjectInstance | Where-Object name -Match $Name))
        {
            Write-Host "$($Instance.name)" -ForegroundColor White -BackgroundColor DarkRed -NoNewline
            Write-Host ""
            Write-Host "   ServerID=$($Instance.serverid), ProductID=$($Instance.productid)" -NoNewline
            Write-Host ", TypeID=$($Instance.typeid), Description=$($Instance.description)" -NoNewline
            Write-Host ", TaskObjectFlag=$($Instance.taskobjectflag), Platform=$($Instance.platform)"
            $Instance.Section | ForEach-Object {
                Write-Host "      $($_.name)"
                $_.ChildNodes.GetEnumerator() | ForEach-Object {
                    "         {0}:{1}" -f $_.name, $_.value
                }
            }
            Write-Host ""
        }
    }
    else
    {
        $Url = "$($ePoVar.URL)/clienttask.export?fileName=$FileName"
        $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
        $EpoQuery.Content
    }
}
