function Invoke-MMePoClientTaskRun
{
    <#
    .SYNOPSIS
    Run Client Tasks.
    .DESCRIPTION
    Runs the client task on a supplied list of systems
    Requires edit permission for at least one product
    #>

    param (
        [string[]]
        $Names,
        [string]
        $ProductID,
        [int]
        $ObjectID,
        [int]
        $RNDMinutes
    )

    TestConnectioToePoServer

    $Names = $Names -join '%2C'
    $Url = "$($ePoVar.URL)/clienttask.run?names=$($Names)&productId=$($ProductID)&taskId=$($TaskID)&randomMinutes=$($RNDMinutes)"

    switch ($PSEdition)
    {
        'Desktop' { Invoke-WebRequest -Uri $Url -Credential $ePoVar.Credential }
        'Core' { Invoke-WebRequest -Uri $Url -Credential $ePoVar.Credential -SkipCertificateCheck }
        Default { "Powershell edition: $PSEdition is not supported" }
    }
}
