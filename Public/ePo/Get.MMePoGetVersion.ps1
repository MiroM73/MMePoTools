function Get-MMePoGetVersion
{
    <#
     .SYNOPSIS
     Gets version of ePo server.
     .DESCRIPTION
     Gets the ePO version.
     Requires admin rights on the ePo server..
    #>

    if (! $ePoVar.Credential)
    {
        Write-Host "The ePo server is not connected. First use Connect-MMePoServer."
        break
    }

    $Url = "$($ePoVar.URL)/epo.getVersion?:output=json"

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
