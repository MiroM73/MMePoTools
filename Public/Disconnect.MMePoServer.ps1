function Disconnect-MMePoServer
{
    #Return setup for SecurityProtocol to previous state
    if ([Net.ServicePointManager]::SecurityProtocol -ne $ePoVar.SecurityProtocol)
    {
        [Net.ServicePointManager]::SecurityProtocol = $ePoVar.SecurityProtocol
    }

    #Remove ePoVar
    Remove-Variable -Name ePoVar -Scope Script

    Enable-SslVerification
}
