function Enable-TLs12 ([System.Net.SecurityProtocolType]$SecurityProtocol)
{
    # the communication to the ePo server required min. TLS1.2 version
    $SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    return $SecurityProtocol
}
