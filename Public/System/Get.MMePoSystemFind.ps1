function Get-MMePoSystemFind
{
    <#
    .SYNOPSIS
    Find system or systems
    .DESCRIPTION
    Find systems in the ePO tree by name, IP address, MAC address, user name, agent
    GUID or tag.  Returns a list of database ids that can be used as input to any of
    the system commands.

    Requires permission to at least one group in the System Tree

    Parameters:
    [SearchText]
    - Search text can be IP address, MAC address, user name, agent GUID or tag
    [SearchNameOnly]
    - If this value is set to "true" we will only search the computer name. This might improve performance.
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $SearchText,
        [switch]
        $SearchNameOnly
    )

    TestConnectioToePoServer

    if ($SearchNameOnly)
    {
        $Url = "$($ePoVar.URL)/system.find?searchText=$($SearchText)&searchNameOnly=true&:output=json"
    }
    else
    {
        $Url = "$($ePoVar.URL)/system.find?searchText=$($SearchText)&:output=json"
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    $data = ConvertFrom-Json (($EpoQuery.Content -replace 'OK:').TrimStart())
    foreach ($i in $data)
    {
        $outputObject = New-Object -TypeName PSCustomObject
        $noteProperty = $i | Get-Member | Where-Object MemberType -EQ 'NoteProperty' | Select-Object -ExpandProperty name
        foreach ($j in $noteProperty)
        {
            $outputObject | Add-Member -MemberType NoteProperty -Name ($j -split '\.')[-1] -Value $i."$($j)"
        }
        $outputObject
    }
}
