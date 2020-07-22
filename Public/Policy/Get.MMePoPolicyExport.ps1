function Get-MMePoPolicyExport
{
    <#
    .SYNOPSIS
    View / Export client policy.
    .DESCRIPTION
    View / Exports client Policy
    Requires view permission for at least one product.
    .EXAMPLE
    Get-MMePoPolicyExport -FolderPath c:\temp
    Export the client Policy configuration in to the c:\temp\export.xml on local machine.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Name')]

    param (
        # Save - the name of the task you are looking for.
        # It is possible to use regular expression like -match operator uses.
        [Parameter(Position = 0, Mandatory = $false, ParameterSetName = 'Save')]
        [Switch]
        $Save,
        # ProductID - The product ID as returned from policy.find API.
        [Parameter(Position = 1, Mandatory = $false)]
        [string]
        $ProductID,
        # FolderPath - Folder path to export policy.
        # Default path is c:\temp
        # Default extension xml is used automaticaly.
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName = 'FolderPath')]
        [string]
        $FolderPath = "c:\temp",
		# List all the policy
		[Parameter(Position = 3, Mandatory = $false, ParameterSetName = 'List')]
        [Switch]
        $List
    )

    TestConnectioToePoServer

    if ($ProductId)
    {
		$Url = "$($ePoVar.URL)/policy.export?productId=$($ProductId)"
        $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
        $EpoQuery = ($EpoQuery.Content -replace 'OK:').TrimStart()
		$SavePath = "$($FolderPath)\MMePoPolicyExport\$($ProductId).xml"
		$EpoQuery | Out-File ( New-Item -Path $SavePath -Force)
		echo "policy $($ProductId) exported to : " $SavePath
    }
    elseif($Save)
    {
        $Url = "$($ePoVar.URL)/policy.find"
		$EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential 
        $EpoQuery = ($EpoQuery.Content -replace 'OK:').TrimStart()
		$ProductIdOld = ""
		foreach($line in $EpoQuery.Split([Environment]::NewLine)) {
			if($line -match 'productId'){
				$ProductId = $line.Split(":")[1].TrimStart()
			}
			if($line -match 'productName'){
				$ProductName = $line.Split(":")[1].TrimStart()	#Can be used, but need a fix first
			}
			if ($ProductIdOld -ne $ProductId){
						$ProductIdOld = $ProductId
						$Url = "$($ePoVar.URL)/policy.export?productId=$($ProductId)"
						$EpoQuery2 = WebRequest -Uri $Url -Credential $ePoVar.Credential
						$EpoQuery2 = ($EpoQuery2.Content -replace 'OK:').TrimStart()
						$EpoQuery2 | Out-File ( New-Item -Path "$($FolderPath)\MMePoPolicyExport\$($ProductId).xml" -Force)
			}
		}
    }
	else {
	    $Url = "$($ePoVar.URL)/policy.find"
		$EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential 
        $EpoQuery = ($EpoQuery.Content -replace 'OK:').TrimStart()
		if($List) {echo $EpoQuery}
		echo("Choose a policy to export. cmd : Get-MMePoPolicyExport -Save -ProductId PRODUCTid_MCAFEE -FolderPath C:\MyFolder\ToSave")
		echo("To save all policy. cmd : Get-MMePoPolicyExport -Save")
  }
}
