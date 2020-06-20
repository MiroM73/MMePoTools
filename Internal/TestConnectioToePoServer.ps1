function TestConnectioToePoServer
{
    if (! $ePoVar.Connected)
    {
        Write-Host "The ePo server is not connected. First use Connect-MMePoServer."
        break
    }
}
