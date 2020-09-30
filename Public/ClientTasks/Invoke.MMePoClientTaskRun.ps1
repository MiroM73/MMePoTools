function Invoke-MMePoClientTaskRun
{
    <#
    .SYNOPSIS
    Run Client Tasks.
    .DESCRIPTION
    Runs the client task on a supplied list of systems
    Requires edit permission for at least one product

    Parameters:
    [Name | Id] - A comma-separated list of system names/ip addresses
        or a comma-separated list of system IDs
    productId  - Product ID (productID) as returned by Get-MMePoClientTaskFind command
    taskId  - Task ID (objectID) as returned by Get-MMePoClientTaskFind command
    RNDMinutes - Duration in minutes over which to randomly spread
        task execution. Defaults to 0 (execute on all clients immediately).

    NOT Implemented:
    retryAttempts  - Number of times the server will attempt to send the
        task to the client. Defaults to 1.
    retryIntervalInSeconds  - Retry interval in seconds. Defaults to 30.
    abortAfterMinutes - Maximum number of minutes before aborting all
        attempts. Defaults to 5.
    useAllAgentHandlers - If true, any Agent Handler can send the task.
        Defaults to false (only the last connected Agent Handler will be used).
    stopAfterMinutes - Maximum duration in minutes the client task is
        allowed to run. Defaults to 20.
    .EXAMPLE
    Get-MMePoClientTaskFind | sort objectName | ft

    Lists all the client tasks sorted by the objectname and format the output as a table.

    objectId objectName                                             productId    productName                          typeId typeName
    -------- ----------                                             ---------    -----------                          ------ --------
          38 Collect All                                            EPOAGENTMETA McAfee Agent                             12 McAfee Agent: McAfee Agent Statistics
          39 Collect only RelayServer                               EPOAGENTMETA McAfee Agent                             12 McAfee Agent: McAfee Agent Statistics
          59 Deploy ePO Deep Command Client                         EPOAGENTMETA McAfee Agent                             10 McAfee Agent: Product Deployment
          57 Deploy ePO Deep Command Discovery and Reporting Plugin EPOAGENTMETA McAfee Agent                             10 McAfee Agent: Product Deployment
         177 On-Demand Scan - Quick Scan                            ENDP_AM_1000 Endpoint Security Threat Prevention      26 Endpoint Security Threat Prevention: Policy Based On-Demand Scan

    .EXAMPLE
    Invoke-MMePoClientTaskRun -Name comp1,comp2,comp3 -ProductID ENDP_AM_1000 -TaskID 177

    From the previous command we want to use the On-Demand scan
    ObjectID = 177 = TaskID
    ProductID = ENDP_AM_1000
    and start it on the computers comp1, comp2 and comp3
    #>

    [CmdletBinding(DefaultParameterSetName = 'Name')]
    param (
        #[names | ids | IPs] - A comma-separated list of system names/ip addresses
        #   or a comma-separated list of system IDs
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = 'Name')]
        [Alias("IpAddress")]
        [string[]]
        $Name,
        #[names | ids | IPs] - A comma-separated list of system names/ip addresses
        #   or a comma-separated list of system IDs
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = 'id')]
        [string[]]
        $Id,
        #Product ID (productID) as returned by Get-MMePoClientTaskFind command
        [Parameter(Mandatory = $true,
            Position = 1,
            ParameterSetName = 'Name')]
        [Parameter(Mandatory = $true,
            Position = 1,
            ParameterSetName = 'id')]
        [string]
        $ProductID,
        #Task ID (objectID) as returned by Get-MMePoClientTaskFind command
        [Parameter(Mandatory = $true,
            Position = 2,
            ParameterSetName = 'Name')]
        [Parameter(Mandatory = $true,
            Position = 2,
            ParameterSetName = 'id')]
        [int]
        $TaskID,
        #Duration in minutes over which to randomly spread task execution.
        #Defaults to 0 (execute on all clients immediately).
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Name')]
        [Parameter(Mandatory = $false,
            ParameterSetName = 'id')]
        [int]
        $RNDMinutes = 0
    )

    TestConnectioToePoServer

    if ($null -ne $Name)
    {
        $Names = $Name -join '%2C'
        $Url = "$($ePoVar.URL)/clienttask.run?names=$($Names)&productId=$($ProductID)&taskId=$($TaskID)&randomMinutes=$($RNDMinutes)"
    }
    if ($null -ne $Id)
    {
        $IDs = $Id -join '%2C'
        $Url = "$($ePoVar.URL)/clienttask.run?ids=$($IDs)&productId=$($ProductID)&taskId=$($TaskID)&randomMinutes=$($RNDMinutes)"
    }

    switch ($PSEdition)
    {
        'Desktop' { Invoke-WebRequest -Uri $Url -Credential $ePoVar.Credential }
        'Core' { Invoke-WebRequest -Uri $Url -Credential $ePoVar.Credential -SkipCertificateCheck }
        Default { "Powershell edition: $PSEdition is not supported" }
    }
}
