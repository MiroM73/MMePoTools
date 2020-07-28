function Get-MMePoPolicyExport
{
    <#
    .SYNOPSIS
    Export client policy.
    .DESCRIPTION
    policy.export productId [fileName]
    Exports policies to an XML file in export folder
    Requires view permission for at least one product
    Parameters:
    productId (param 1) - Product ID as returned by policy.find command
    fileName (param 2) - Location within the export folder for the XML file to be
    stored, e.g. foo.xml, foo/foo.xml, etc.
    .EXAMPLE
    Get-MMePoPolicyExport -ProductID 'VIRUSCAN8800' -FolderPath c:\temp
    Export the policy configuration for ProductID VIRUSSCAN8800
    in to the c:\temp\MMePoPolicyExport\export.xml on local machine.
    If file with the export already exists in the export folder, the filen will be rewritted.
    .EXAMPLE
    (Get-MMePoPolicyFind VIRUSCAN8800 | group productId).name | Get-MMePoPolicyExport -FolderPath c:\temp
    Export the policy configuration for ProductID VIRUSSCAN8800
    in to the c:\temp\MMePoPolicyExport\ folder on the local machine.
    If file with the export already exists in the export folder, the file will be rewritted.
    .EXAMPLE
    (Get-MMePoPolicyFind | group productId).name | Get-MMePoPolicyExport -FolderPath c:\temp
    Export all the policy configurations in to the c:\temp\MMePoPolicyExport\export.xml on local machine.
    If files with the exports already exist in the export folder, the files will be rewritted.
    #>

    [CmdletBinding()]

    param (
        # ProductID - The product ID as returned from policy.find API used in the command
        # Get-MMePoPolicyFind
        # ProductID
        [Parameter(Position = 0, Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $ProductID,
        # FolderPath - Folder path to export policy.
        # Default path is current working directory .\MMePoPolicyExport
        # Default extension xml is used automaticaly.
        [Parameter(Position = 1, Mandatory = $false)]
        [string]
        $FolderPath
    )

    begin
    {
        TestConnectioToePoServer

        if ([string]::IsNullOrEmpty($FolderPath))
        {
            $FolderPath = (Get-Location).path
        }
        if (-not $(Test-Path $FolderPath)) {
            try {
                New-Item $FolderPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Error "$($_.Exception.Message)"
                break
            }
        }
    }

    process
    {
        foreach ($Product in $ProductID)
        {
            $Url = "$($ePoVar.URL)/policy.export?productId=$($Product)"
            $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
            if ($EpoQuery.Content -match '^Error')
            {
                Write-Host "policy $($Product) NOT exported: " -NoNewline
                Write-Host "$($EpoQuery.Content -split "$([System.Environment]::NewLine)" -join ' ')" -ForegroundColor White -BackgroundColor DarkRed -NoNewline
                Write-Host ''
            }
            else
            {
                $Data = ($EpoQuery.Content -replace 'OK:').TrimStart()
                $SavePath = "$($FolderPath)\MMePoPolicyExport\$($Product).xml"
                $Data | Out-File ( New-Item -Path $SavePath -Force)
                Write-Host "policy $($Product) exported to : " $SavePath
            }
        }
    }

    end
    {
        Write-Host "Export finished."
    }
}
