function WebRequest
{
    param (
        $Uri,
        [pscredential]$Credential
    )
    switch ($PSEdition)
    {
        'Desktop'
        {
            $EpoQuery = Invoke-WebRequest -Uri $Url -Credential $Credential
            return $EpoQuery
        }
        'Core'
        {
            $EpoQuery = Invoke-WebRequest -Uri $Url -Credential $Credential -SkipCertificateCheck
            return $EpoQuery
        }
        Default { "Not supported PowerShell edition: $PSEdition"; exit }
    }
}
