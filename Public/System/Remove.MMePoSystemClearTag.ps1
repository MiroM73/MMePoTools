function Remove-MMePoSystemClearTag
{
    <#
    .SYNOPSIS
    Clears the tag from supplied systems.
    .DESCRIPTION
    system.clearTag names tagName [all]
    Clears the tag from supplied systems
    Requires Tag use permission
    Parameters:
     [SystemName (param 1) | SystemID] - You need to either supply the "names" with a
       comma-separated list of names/ip addresses or a comma-separated list of "IDs".
     [TagName (param 2) | TagID] - You need to either supply the tag name or the tag ID.
     All (param 3) - Setting this argument to "true" clears all tags from the chosen
       systems. If this is set, the tagName or tagID provided is ignored.
    .EXAMPLE
    PS>Connect-MMePoServer
    Connected to ePoServer eposervername:8443
    Ver.: 5.9.1

    PS>$pctags = (Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    PS>$pctags
    Drive Encryption Uninstall, PCs, Windows10

    PS>Remove-MMePoSystemClearTag -SystemName compxy -all
    OK: 1 of 1 cleared successfully.

    PS>(Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    PS>Set-MMePoSystemApplyTag -SystemName compxy -TagName PCs
    OK: 1 of 1 applied successfully.

    PS>Set-MMePoSystemApplyTag -SystemName compxy -TagName Windows10
    OK: 1 of 1 applied successfully.

    PS>Set-MMePoSystemApplyTag -SystemName compxy -TagName 'Drive Encryption Uninstall'
    OK: 1 of 1 applied successfully.

    PS>(Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    Drive Encryption Uninstall, PCs, Windows10
    .EXAMPLE
    PS>Remove-MMePoSystemClearTag -SystemName compxy -TagName 'Drive Encryption Uninstall'
    OK: 1 of 1 cleared successfully.

    PS>(Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    PCs, Windows10

    PS>Set-MMePoSystemApplyTag -SystemName compxy -TagName 'Drive Encryption Uninstall'
    OK: 1 of 1 applied successfully.

    PS>(Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    Drive Encryption Uninstall, PCs, Windows10
    #>
    [CmdletBinding(DefaultParameterSetName = 'SystemNameTagName')]

    param (
        # "System / Computer names" with a comma-separated list of "names / ip addresses".
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemNameTagName')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemNameTagID')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemNameTagAll')]
        [string[]]
        $SystemName,
        # "System / Computer names" with a comma-separated list of "System IDs".
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemIDTagName')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemIDTagID')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemIDTagAll')]
        [string[]]
        $SystemID,
        # The tag name.
        # Get the list of tag names with the Get-MMePoSystemFindTag command
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'SystemNameTagName')]
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'SystemIDTagName')]
        [string]
        $TagName,
        # The tag  ID.
        # Get the list of tag IDs with the Get-MMePoSystemFindTag command
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'SystemNameTagID')]
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'SystemIDTagID')]
        [string]
        $TagID,
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemNameTagAll')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemIDTagAll')]
        [switch]
        $All
    )

    TestConnectioToePoServer

    if ($SystemName)
    {
        $SystemCount = $SystemName.Count
        $SystemName = $SystemName -join '%2C'
    }
    else
    {
        $SystemCount = $SystemID.Count
        $SystemID = $SystemID -join '%2C'
    }

    switch ($PSCmdlet.ParameterSetName)
    {
        'SystemNameTagName'
        {
            $Url = "$($ePoVar.URL)/system.clearTag?names=$SystemName&tagName=$TagName"
        }
        'SystemNameTagID'
        {
            $Url = "$($ePoVar.URL)/system.clearTag?names=$SystemName&tagID=$TagID"
        }
        'SystemIDTagID'
        {
            $Url = "$($ePoVar.URL)/system.clearTag?ids=$SystemID&tagID=$TagID"
        }
        'SystemNameTagAll'
        {
            $Url = "$($ePoVar.URL)/system.clearTag?names=$SystemName&all=true"
        }
        'SystemIDTagAll'
        {
            $Url = "$($ePoVar.URL)/system.clearTag?ids=$SystemID&all=true"
        }
        Default
        {
            $Url = "$($ePoVar.URL)/system.clearTag?ids=$SystemID&tagName=$TagName"
        }
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    $Result = $EpoQuery.Content -split '\n'
    if ([int]($Result[1].Trim()) -eq $SystemCount)
    {
        Write-Host "$($Result[0].Trim()) $($Result[1].Trim()) of $SystemCount cleared successfully."
    }
    else
    {
        Write-Host "$($Result[0].Trim()) $($Result[1].Trim()) of $SystemCount cleared successfully." -BackgroundColor DarkRed
        Write-Host "If result is OK:, but not the all systems have the tag/s cleared, some of the system/s may have not the selected tag applied before."
    }
}
