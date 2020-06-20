function Enable-SslVerification
{
    if ($PSEdition -eq 'Desktop')
    {
        # it is good to reenable the certificate checking after the work with the ePo server
        if (([System.Management.Automation.PSTypeName]"TrustEverything").Type)
        {
            [TrustEverything]::UnsetCallback()
        }
    }
}
