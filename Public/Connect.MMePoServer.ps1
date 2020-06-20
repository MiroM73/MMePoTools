function Connect-MMePoServer
{
    <#
    .SYNOPSIS
        Connect McAfee ePo server.
    .DESCRIPTION
        This command will create the variable $ePoVar in the module's context.
    .EXAMPLE
        PS C:\> Connect-MMePoServer -ServerName eposerver01 -Credential (Get-Credential eposerverAdmin -Message "Enter the password for eposerverAdmin")
        The command sets the values in the variable $ePoVar:
        ServerName       = eposerver01
        Port             = 8443
        URL              = "https://eposerver01:8443/remote"
        Credential       = <entered credential)
        SecurityProtocol = Enable-TLs12
        Connected        = $false
        The command will try to get the version of the ePo server by command Get-MMePoVersion.
        If the Get-MMePoVersion returns the value, $ePoVar.Connected will change to $True
        and it will display the info about the version on the user console.
    #>

    param (
        # The name of the ePo server
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ServerName,
        # Default ePo server port is 8443
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [int]
        $Port = 8443,
        # Enter credentials to connect the ePo server
        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $Credential = (Get-Credential -Message "Enter credentials to connect to ePo server:")
    )

    $Script:ePoVar = [PSCustomObject]@{
        ServerName       = $ServerName
        Port             = $Port
        URL              = "https://$($ServerName):$($Port)/remote"
        Credential       = $Credential
        SecurityProtocol = Enable-TLs12
        Connected        = $false
    }

    Disable-SslVerification

    $EpoVersion = Get-MMePoGetVersion
    if ($EpoVersion)
    {
        $ePoVar.Connected = $true
        Write-Output "Connected to ePoServer $($ePoVar.ServerName):$($ePoVar.Port)"
        Write-Output "Ver.: $EpoVersion"
    }
    else
    {
        Write-Output "Problem to connect to ePoServer $($ePoVar.ServerName):$($ePoVar.Port)"
    }
}
