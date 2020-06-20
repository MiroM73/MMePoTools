function Set-MMePoSystemApplyTag
{
    <#
    .SYNOPSIS
    Apply tag name / ID.
    .DESCRIPTION
    Apply tag name "tagName" or tag "ID".
    Assign the given tag to a supplied list of systems. System list can contain
    names, IP addresses or IDs.
    Requires Tag use permission.
    #>

    [CmdletBinding(DefaultParameterSetName = 'SystemNameTagName')]

    param (
        # "System / Computer names" with a comma-separated list of "names / ip addresses".
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemNameTagName')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemNameTagID')]
        [string[]]
        $SystemName,
        # "System / Computer names" with a comma-separated list of "System IDs".
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemIDTagName')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'SystemIDTagID')]
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
        $TagID
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
            $Url = "$($ePoVar.URL)/system.applyTag?names=$SystemName&tagName=$TagName"
        }
        'SystemNameTagID'
        {
            $Url = "$($ePoVar.URL)/system.applyTag?names=$SystemName&tagID=$TagID"
        }
        'SystemIDTagID'
        {
            $Url = "$($ePoVar.URL)/system.applyTag?ids=$SystemID&tagID=$TagID"
        }
        Default
        {
            $Url = "$($ePoVar.URL)/system.applyTag?ids=$SystemID&tagName=$TagName"
        }
    }

    $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
    $Result = $EpoQuery.Content -split '\n'
    if ([int]($Result[1].Trim()) -eq $SystemCount)
    {
        Write-Host "$($Result[0].Trim()) $($Result[1].Trim()) of $SystemCount applied successfully."
    }
    else
    {
        Write-Host "$($Result[0].Trim()) $($Result[1].Trim()) of $SystemCount applied successfully." -BackgroundColor DarkRed
        Write-Host "If result is OK:, but not the all systems get the tag, some of the system/s may have the selected tag applied before."
    }

}
