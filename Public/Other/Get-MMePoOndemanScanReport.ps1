function Get-MMePoOndemanScanReport
{
    <#
    .SYNOPSIS
    Get the info about the OnDemand Scan tasks running on the computers from thier OnDemandScan_Activity.log files.
    .DESCRIPTION
    This command retrieves a data from the OnDemand Scan log file/s on the computer/s.
    This log file (OnDemandScan_Activity.log) is located on the computer
    in the folder 'c:\programdata\mcafee\endpoint security\logs' by default.
    The path can be changed in the property $OnDemandLogPath.
    The command is looking for 'scan started' or 'scan resumed' messages in the log
    and from this line returns all next lines till the line matched
    'scan completed' or 'scan stopped' or 'scan auto paused' patterns.
    .EXAMPLE
    Get-MMePoOndemanScanReport -ComputerName comp1,comp2,comp3
    Returns all ondemand scan informations from comp1 ... comp3 computers.
    The every event is reported as an object and can be further processed through the pipe,
    or added to a variable.
    .EXAMPLE
    Get-MMePoOndemanScanReport -ComputerName omp1,comp2,comp3 | ? DateTime -gt ((get-date).AddHours(-1)) | ft
    Returns all ondemand scan informations from comp1 ... comp3 computers and filters out only last hour.
    The result is displayed as the table.
    .INPUTS
    [string[]] for $ComputerName
    [string]$OnDemandLogPath cannot be pipped into this cmdlet
    .OUTPUTS
    System.Array Output from this cmdlet is array of pscustom objects
    #>

    [CmdletBinding()]

    Param (
        # one o more computer names
        [Parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false)]
        [string[]]
        $ComputerName,
        # path to OnDemandScan_Activity.log log file
        # by default 'c:\programdata\mcafee\endpoint security\logs\OnDemandScan_Activity.log'
        [string]
        $OnDemandLogPath = 'C:\ProgramData\McAfee\Endpoint Security\Logs\OnDemandScan_Activity.log'
    )

    begin
    {
        $OnDemandLogPath = $OnDemandLogPath -replace ':', '$'
        $PropertyNames = 'ComputerName,DateTime,Level,Facility,Process,PID,TID,Topic,FileName(Line),Message' -split ','
        function ProcessLine ($Comp, $Line)
        {
            $Line = "$Comp|" + $($Line -replace "\s*\|\s*", '|')
            return $Line
        }
    }

    process
    {
        foreach ($Comp in $ComputerName)
        {
            $scan = $false
            try
            {
                $LogFileTmp = Get-Content "\\$Comp\$OnDemandLogPath" -ErrorAction Stop
                foreach ($Line in $LogFileTmp)
                {
                    if ($Line -match 'scan started' -or $Line -match 'Scan resumed')
                    {
                        ConvertFrom-String -Delimiter '\|' -InputObject (ProcessLine $Comp $Line) -PropertyNames $PropertyNames
                        $scan = $true
                    }
                    elseif ($Line -match 'scan completed' -or $Line -match 'scan stopped' -or $Line -match 'Scan auto paused')
                    {
                        ConvertFrom-String -Delimiter '\|' -InputObject (ProcessLine $Comp $Line) -PropertyNames $PropertyNames
                        $scan = $false
                    }
                    elseif ($scan)
                    {
                        ConvertFrom-String -Delimiter '\|' -InputObject (ProcessLine $Comp $Line) -PropertyNames $PropertyNames
                    }
                }
            }
            catch
            {
                $_
            }
        }
    }
}
