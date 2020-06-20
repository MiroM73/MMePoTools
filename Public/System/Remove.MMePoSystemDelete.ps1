function Remove-MMePoSystemDelete
{
    <#
    .SYNOPSIS
    Deletes systems from the System Tree by name or ID if permissions allow.
    .DESCRIPTION
    system.delete names [uninstall] [uninstallSoftware]
    Deletes systems from the System Tree by name or ID if permissions allow.
    Requires permission to edit System Tree groups and systems
    Parameters:
     [SystemName (param 1) | SystemID] - You need to either supply the "names" with a
     comma-separated list of names/ip addresses or a comma-separated list of "IDs".
      Uninstall (param 2) - If true, this will also attempt to uninstall the agent
      from the affected systems. Default is false.
       UninstallSoftware (param 3) - If true, this will also attempt to uninstall all
       point products installed on the systems before uninstalling the agent. Default
       is false.
    .EXAMPLE
    $dupl = Invoke-MMePoCoreExecuteQuery -Id 935 | group 'EPOLeafNode.NodeName' -NoElement | select -ExpandProperty name
    PS C:\>$dupl | %{$t = (Get-MMePoSystemFind -SearchText $_ -SearchNameOnly | ? ComputerName -eq $_ | sort LastUpdate -Descending);
                Remove-MMePoSystemDelete -SystemID ($t[1..$t.count].parentid -join ',') | ft -autosize}

    The initial command lists all duplicate systems in the ePo DB using ePo query, then groups them by the system names, and the result stores into the variable $dupl.
    The next command runs through array $dupl, gots all the systems with the same name, order them by LastUpdate property descending and the result saves into the temporary array $t.
    Then we stake all the systems in the array $t except for the index 0 (the systems in the index 0 are the last communicated systems with the ePo server).
    We get the ParentIDs from these systems at the end, and these ids we will use in the command Remove-MMePoSystemDelete.
    #>

    [CmdletBinding(DefaultParameterSetName = 'SystemName')]

    param (
        # You need to either supply the "names" with a comma-separated list of names/ip addresses.
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemName')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemNameUninstall')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemNameUninstallSoftware')]
        [string[]]
        $SystemName,
        # You need to either supply a comma-separated list of IDs/ParentID (ParentID from Get-MMePoSystemFind).
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemID')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemIDUninstall')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemIDUninstallSoftware')]
        [string[]]
        $SystemID,
        # If true, this will also attempt to uninstall the agent from the affected systems.
        # Default is false.
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'SystemNameUninstall')]
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'SystemIDUninstall')]
        [switch]
        $Uninstall,
        # If true, this will also attempt to uninstall all point products installed on the systems before uninstalling the agent.
        # Default is false.
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'SystemNameUninstallSoftware')]
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'SystemIDUninstallSoftware')]
        [switch]
        $UninstallSoftware
    )

    TestConnectioToePoServer

    if ($SystemName)
    {
        $SystemName = $SystemName -join '%2C'
    }
    else
    {
        $SystemID = $SystemID -join '%2C'
    }

    switch ($PSCmdlet.ParameterSetName)
    {
        'SystemName'
        {
            $Url = "$($ePoVar.URL)/system.delete?names=$SystemName&:output=json"
        }
        'SystemNameUninstall'
        {
            $Url = "$($ePoVar.URL)/system.delete?names=$SystemName&uninstall=$Uninstall&:output=json"
        }
        'SystemNameUninstallSoftware'
        {
            $Url = "$($ePoVar.URL)/system.delete?names=$SystemName&uninstall=true&uninstallSoftware=$UninstallSoftware&:output=json"
        }
        'SystemID'
        {
            $Url = "$($ePoVar.URL)/system.delete?ids=$SystemID&:output=json"
        }
        'SystemIDUninstall'
        {
            $Url = "$($ePoVar.URL)/system.delete?ids=$SystemID&uninstall=$Uninstall&:output=json"
        }
        'SystemIDUninstallSoftware'
        {
            $Url = "$($ePoVar.URL)/system.delete?ids=$SystemID&uninstall=true&uninstallSoftware=$UninstallSoftware&:output=json"
        }
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    $data = ConvertFrom-Json (($EpoQuery.Content -replace 'OK:').TrimStart())
    foreach ($item in $data)
    {
        $item
    }
}
