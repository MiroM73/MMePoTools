# MMePoTools

- [MMePoTools](#mmepotools)
  - [How to install](#how-to-install)
  - [Commandlets](#commandlets)
    - [Connect/Disconnect](#connectdisconnect)
      - [Connect-MMePoServer](#connect-mmeposerver)
      - [Disconnect-MMePoServer](#disconnect-mmeposerver)
    - [ClientTask](#clienttask)
      - [Get-MMePoClientTaskExport](#get-mmepoclienttaskexport)
      - [Get-MMePoClientTaskFind](#get-mmepoclienttaskfind)
      - [Invoke-MMePoClientTaskRun](#invoke-mmepoclienttaskrun)
    - [Core](#core)
      - [Get-MMePoCoreExportPermissionSets](#get-mmepocoreexportpermissionsets)
      - [Get-MMePoCoreHelp](#get-mmepocorehelp)
      - [Get-MMePoCoreListPermSets](#get-mmepocorelistpermsets)
      - [Get-MMePoCoreListQueries](#get-mmepocorelistqueries)
      - [Get-MMePoCoreListUsers](#get-mmepocorelistusers)
      - [Invoke-MMePoCoreExecuteQuery](#invoke-mmepocoreexecutequery)
    - [epo](#epo)
      - [Get-MMePoGetVersion](#get-mmepogetversion)
    - [Policy](#policy)
      - [Get-MMePoPolicyFind](#get-mmepopolicyfind)
      - [Get-MMePoPolicyExport](#get-mmepopolicyexport)
    - [Repository](#repository)
      - [Get-MMePoRepositoryFind](#get-mmeporepositoryfind)
    - [Scheduler](#scheduler)
      - [Get-MMePoSchedulerGetServerTask](#get-mmeposchedulergetservertask)
      - [Get-MMePoSchedulerListAllServerTasks](#get-mmeposchedulerlistallservertasks)
    - [System](#system)
      - [Get-MMePoSystemFind](#get-mmeposystemfind)
      - [Get-MMePoSystemFindGroup](#get-mmeposystemfindgroup)
      - [Get-MMePoSystemFindTag](#get-mmeposystemfindtag)
      - [Move-MMePoSystemMove](#move-mmeposystemmove)
      - [Remove-MMePoSystemClearTag](#remove-mmeposystemcleartag)
      - [Remove-MMePoSystemDelete](#remove-mmeposystemdelete)
      - [Set-MMePoSystemApplyTag](#set-mmeposystemapplytag)
    - [Other](#other)
      - [Get-MMePoOndemanScanReport](#get-mmepoondemanscanreport)

## How to install

  - Download the zip
  - Extract to folder to : C:\Program Files\WindowsPowerShell\Modules\MMePoTools
  - Unblock all the powershell files : dir -Path "C:\Program Files\WindowsPowerShell\Modules\MMePoTools" -Recurse | Unblock-File
  - Install module in Powershell : Import-Module -name MMePoTools

  - Test installation, open a Powershell try : Connect-MMePoServer -ServerName ePOSERVERNAME

## Commandlets
### Connect/Disconnect
#### Connect-MMePoServer

    <#
    .SYNOPSIS
        Connect McAfee ePo server.
    .DESCRIPTION
        This command will create the variable $ePoVar in the module's context.
    .EXAMPLE
        PS C:\> Connect-MMePoServer -ServerName eposerver01 -Credential (Get-Credential eposerverAdmin -Message "Enter the password for eposerverAdmin")
        The command sets the values in the variable $ePoVar:
        ServerName       = eposerver01
        Port             = 8443
        URL              = "https://eposerver01:8443/remote"
        Credential       = <entered credential)
        SecurityProtocol = $([Net.ServicePointManager]::SecurityProtocol)
        Connected        = $false
        The command will try to get the version of the ePo server by command Get-MMePoVersion.
        If the Get-MMePoVersion returns the value, $ePoVar.Connected will change to $True
        and it will display the info about the version on the user console.
    #>

#### Disconnect-MMePoServer

### ClientTask
#### Get-MMePoClientTaskExport

    <#
    .SYNOPSIS
    View / Export client tasks.
    .DESCRIPTION
    View / Exports client tasks
    Requires view permission for at least one product.
    If the parameter $FileName is omiited, output is displayed on the console.
    .EXAMPLE
    PS C:\>Get-MMePoClientTaskExport -Name '^Install DLP$'
    Find exactly "Install DLP" task.
    .EXAMPLE
    PS C:\>Get-MMePoClientTaskExport -Name 'Install DLP'
    Find all tasks whose name contains "Install DLP" string.
    .EXAMPLE
    PS C:\>Get-MMePoClientTaskExport -FileName export
    Export the client tasks configuration in to the c:\reports\export.xml file on the ePo server.
    .EXAMPLE
    PS C:\>Get-MMePoClientTaskExport -FileName "export$(([datetime]::now).tostring("yyyyMMddhhmmss"))"
    Export the client tasks configuration in to the c:\reports\exportACTUALDATETIME.xml file on the ePo server.
    #>

#### Get-MMePoClientTaskFind

    <#
    .SYNOPSIS
    Find Client Tasks.
    .DESCRIPTION
    Finds client tasks filtered by supplied search text.
    If search text is ommited, all tasks are listed.
    Requires view permission for at least one product.
    #>

#### Invoke-MMePoClientTaskRun

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

### Core

#### Get-MMePoCoreExportPermissionSets

    <#
    .SYNOPSIS
    Exports all permission sets.
    .DESCRIPTION
    Exports all permission sets. Returns the permission sets as a string of XML or throws on error.
    Requires administrator rights.
    Default output is user's console.
    .EXAMPLE
    PS>Get-MMePoCoreExportPermissionSets
    Displays the all permission sets to the user's console.
    .EXAMPLE
    PS>Get-MMePoCoreExportPermissionSets > x:\ePo_perm_sets.xml
    Redirects the all permission sets output into the x:\ePo_perm_sets.xml file.
    #>

#### Get-MMePoCoreHelp

    <#
     .SYNOPSIS
     Lists all registered commands and displays help strings.  Returns the list of
     commands or throws on error.
     .DESCRIPTION
     Lists all registered commands and displays help strings.  Returns the list of
     commands or throws on error.

     Command - If specified, the help string for a specific command is
     displayed. If omitted, a list of all commands is displayed.
     It is a Case Sensitive!!!

     Prefix - If specified, only commands with the given prefix are listed. This is
     useful for showing the commands for a single plug-in. This has no effect if the
     'Command' argument is specified.
     .EXAMPLE
     PS C:\>Get-MMePoCoreHelp -DisplayAll | Select-String cleartag
     @{Command=system.clearTag; Description=names tagName [all] - Clears the tag from supplied systems}
     .EXAMPLE
     PS C:\>Get-MMePoCoreHelp system.clearTag
     system.clearTag names tagName [all]
     Clears the tag from supplied systems
     Requires Tag use permission
     Parameters:
      [names (param 1) | ids] - You need to either supply the "names" with a ...
    #>

#### Get-MMePoCoreListPermSets

    <#
    .SYNOPSIS
    List permission sets
    .DESCRIPTION
    List permission sets in the system optionally filtered by username or id.
    Note: Dynamically assigned permission sets are not represented. Returns the list of permission sets or throws on error.
    Requires global administrator privilege.
    #>

#### Get-MMePoCoreListQueries

    <#
    .SYNOPSIS
    Get all queries
    .DESCRIPTION
    Displays all queries that the user is permitted to see. Returns the list of
    queries or throws on error.
    Requires permission to use queries.

    Output NoteProperties:
    id            : 1
    name          : Effective permissions for users
    description   : Shows all permissions for each user
    conditionSexp : Permission Does not equal "%%NOEPOROLES%%"
    groupName     : Permissions
    databaseType  :
    target        : EntitlementView
    createdBy     : ePoServerAdmin
    createdOn     : 2016-05-16T14:26:50+02:00
    modifiedBy    : ePoServerAdmin
    modifiedOn    : 2016-05-16T14:26:50+02:00

    .EXAMPLE
    C:\PS>Get-MMePoCoreListQueries | ? name -match 'effective'
    id            : 1
    name          : Effective permissions for users
    description   : Shows all permissions for each user
    conditionSexp : Permission Does not equal "%%NOEPOROLES%%"
    groupName     : Permissions
    userName      : Public
    databaseType  :
    target        : EntitlementView
    createdBy     : ePoServerAdmin
    createdOn     : 2016-05-16T14:26:50+02:00
    modifiedBy    : ePoServerAdmin
    modifiedOn    : 2016-05-16T14:26:50+02:00

    .EXAMPLE
    D:\ PS>(Get-MMePoCoreListQueries | ? createdby -eq 'ePoServerAdmin').count
    52

    .EXAMPLE
    D:\ PS>Get-MMePoCoreListQueries | group createdby -NoElement
    Count Name
    ----- ----
     52 ePoServerAdmin
    351 admin123456
     66 user12345
     18 oper123456
     22 oper1234

    .INPUTS
        None
    .OUTPUTS
        PSCustomObject
    #>

#### Get-MMePoCoreListUsers

    <#
    .SYNOPSIS
    List users in the system
    .DESCRIPTION
    List users in the system optionally filtered by permission set name or id.
    Returns the list of users or throws on error.
    Requires administrator rights.
    Parameters:
        [permSetName (param 1) | permSetId] - Either the unique id or name of the permission set
    .EXAMPLE
    PS>Get-MMePoCoreListUsers
    list all ePo users
    #>

#### Invoke-MMePoCoreExecuteQuery

    <#
     .SYNOPSIS
     Invokes ePo query by query ID
     .DESCRIPTION
     Invokes ePo query by query ID. ID can be find by function Get-MMePoCoreListQueries
     Returns the data from the execution of the query or throws on error.
     Requires permission to use queries.

     TODO:
     add  execute own query
     core.executeQuery target=<> [select=<>] [where=<>] [order=<>] [group=<>] [database=<>] [depth=<>] [joinTables=<>]
     target - The SQUID target type to query. Optionally, the database type can be prepended to the target with a '.' (for example, databaseType.target)
     select - The SQUID select clause of the query; if blank, all columns will be returned
     where - The SQUID where clause of the query; if blank, all rows will be returned
     order - The SQUID order-by clause of the query; if blank, database order will be returned
     group - The SQUID group-by clause of the query; if blank, no grouping will be performed
     database - The name of the remote database; if blank, the default database for the given database type will be used
     depth - The SQUID depth to fetch sub results (default: 5)
     joinTables - The comma-separated list of SQUID targets to join with the target type; * means join with all types
    #>

### epo
#### Get-MMePoGetVersion

    <#
     .SYNOPSIS
     Gets version of ePo server.
     .DESCRIPTION
     Gets the ePO version.
     Requires admin rights on the ePo server.
    #>

### Policy
#### Get-MMePoPolicyFind

    <#
     .SYNOPSIS
     Finds policies filtered by specified search text.
     .DESCRIPTION
     policy.find [searchText]
     Finds policies filtered by specified search text in all  policy properties
     featureId, featureName, objectId, objectName,  objectNotes
     Requires view permission for at least one product
     Parameters:
     searchText (param 1) - Search text. Wildcards and  regular expressions are not
     supported.
     .EXAMPLE
     Get-MMePoPolicyFind "policyname"
     Find the all policy configurations with "policyname"  string.
     .EXAMPLE
     Get-MMePoPolicyFind -PolicyName 'VIRUS' | ft -AutoSize
    #>

#### Get-MMePoPolicyExport

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

### Repository
#### Get-MMePoRepositoryFind

    <#
    .SYNOPSIS
    Finds repositories filtered by specified search text.
    .DESCRIPTION
    Finds repositories filtered by specified search text.
    Requires repository view permission.
    searchText (param 1) - Search text. Wildcards and regular expressions are not supported.
    .EXAMPLE
    PS>Get-MMePoRepositoryFind
    list all repositories
    .EXAMPLE
    PS>Get-MMePoRepositoryFind -SearchText asdfg
    list repositories containing asdfg text in their names
    #>

### Scheduler
#### Get-MMePoSchedulerGetServerTask

    <#
    .SYNOPSIS
    Get server task by name or ID
    .DESCRIPTION
    Gets details about a specific server task. Returns the task or throws on error.
    Requires permission to run server tasks.

    Parameters:
    TaskName | TaskId - The unique id of the task or the task name
    #>

#### Get-MMePoSchedulerListAllServerTasks

    <#
     .SYNOPSIS
     Displays all server tasks.
     .DESCRIPTION
     Displays all server tasks. Returns the list of tasks or throws on error.
     Requires permission to view server tasks.
    #>

### System
#### Get-MMePoSystemFind

    <#
    .SYNOPSIS
    Find system or systems
    .DESCRIPTION
    Find systems in the ePO tree by name, IP address, MAC address, user name, agent
    GUID or tag.  Returns a list of database ids that can be used as input to any of
    the system commands.

    Requires permission to at least one group in the System Tree

    Parameters:
    [SearchText]
    - Search text can be IP address, MAC address, user name, agent GUID or tag
    [SearchNameOnly]
    - If this value is set to "true" we will only search the computer name. This might improve performance.
    #>

#### Get-MMePoSystemFindGroup

    <#
    .SYNOPSIS
    Finds groups in the System Tree filtered by the search text.
    .DESCRIPTION
    Finds groups in the System Tree filtered by search text.
    Requires access to at least one group in the System Tree.
    Wildcards are not supported, but it is possible to use partially parts.
    If search text is ommited, all groups are listed.
    #>

#### Get-MMePoSystemFindTag

    <#
    .SYNOPSIS
    Find Tags.
    .DESCRIPTION
    Find Tags filtered by search text.
    If search text is ommitted, all tags are listed.
    #>

#### Move-MMePoSystemMove

    <#
    .SYNOPSIS
    Move systems to a specified destination group.
    .DESCRIPTION
    Move systems to a specified destination group by the name or the ID as returned by the function Get-MMePoSystemFind.
    The ID of the destination group can be find by the function Get-MMePoSystemFindGroup.
    #>

#### Remove-MMePoSystemClearTag

    <#
    .SYNOPSIS
    Clears the tag from supplied systems.
    .DESCRIPTION
    system.clearTag names tagName [all]
    Clears the tag from supplied systems
    Requires Tag use permission
    Parameters:
     [SystemName (param 1) | SystemID] - You need to either supply the "names" with a
       comma-separated list of names/ip addresses or a comma-separated list of "IDs".
     [TagName (param 2) | TagID] - You need to either supply the tag name or the tag ID.
     All (param 3) - Setting this argument to "true" clears all tags from the chosen
       systems. If this is set, the tagName or tagID provided is ignored.
    .EXAMPLE
    PS>Connect-MMePoServer
    Connected to ePoServer eposervername:8443
    Ver.: 5.9.1

    PS>$pctags = (Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    PS>$pctags
    Drive Encryption Uninstall, PCs, Windows10
    The command lists the all tags associated with the computer / system compxy.

    PS>Remove-MMePoSystemClearTag -SystemName compxy -all
    OK: 1 of 1 cleared successfully.

    PS>(Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    PS>Set-MMePoSystemApplyTag -SystemName compxy -TagName PCs
    OK: 1 of 1 applied successfully.

    PS>Set-MMePoSystemApplyTag -SystemName compxy -TagName Windows10
    OK: 1 of 1 applied successfully.

    PS>Set-MMePoSystemApplyTag -SystemName compxy -TagName 'Drive Encryption Uninstall'
    OK: 1 of 1 applied successfully.

    PS>(Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    Drive Encryption Uninstall, PCs, Windows10
    .EXAMPLE
    PS>Remove-MMePoSystemClearTag -SystemName compxy -TagName 'Drive Encryption Uninstall'
    OK: 1 of 1 cleared successfully.

    PS>(Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    PCs, Windows10

    PS>Set-MMePoSystemApplyTag -SystemName compxy -TagName 'Drive Encryption Uninstall'
    OK: 1 of 1 applied successfully.

    PS>(Get-MMePoSystemFind -SearchNameOnly compxy).Tags
    Drive Encryption Uninstall, PCs, Windows10
    #>

#### Remove-MMePoSystemDelete

    <#
    .SYNOPSIS
    Deletes systems from the System Tree by name or ID if permissions allow.
    .DESCRIPTION
    system.delete names [uninstall] [uninstallSoftware]
    Deletes systems from the System Tree by name or ID if permissions allow.
    Requires permission to edit System Tree groups and systems
    Parameters:
     [SystemName (param 1) | SystemID] - You need to either supply the "names" with a
     comma-separated list of names/ip addresses or a comma-separated list of "IDs".
      Uninstall (param 2) - If true, this will also attempt to uninstall the agent
      from the affected systems. Default is false.
       UninstallSoftware (param 3) - If true, this will also attempt to uninstall all
       point products installed on the systems before uninstalling the agent. Default
       is false.
    .EXAMPLE
    PS C:\>$dupl = Invoke-MMePoCoreExecuteQuery -Id 935 | group 'EPOLeafNode.NodeName' -NoElement | select -ExpandProperty name
    PS C:\>$dupl | %{$t = (Get-MMePoSystemFind -SearchText $_ -SearchNameOnly | ? ComputerName -eq $_ | sort LastUpdate -Descending)
    PS C:\>Remove-MMePoSystemDelete -SystemID ($t[1..$t.count].parentid -join ',') | ft -autosize}

    The initial command lists all duplicate systems in the ePo DB using ePo query, then groups them by the system names, and the result stores into the variable $dupl.
    The next command runs through array $dupl, got all the systems with the same name, order them by LastUpdate property descending and the result saves into the temporary array $t.
    Finaly we take the all systems from the array $t except for the index 0 (the systems in the index 0 are the last communicated systems with the ePo server), get the ParentIDs from these systems, and these IDs we will use in the command Remove-MMePoSystemDelete.
    #>

#### Set-MMePoSystemApplyTag

    <#
    .SYNOPSIS
    Apply tag name / ID.
    .DESCRIPTION
    Apply tag name "tagName" or tag "ID".
    Assign the given tag to a supplied list of systems. System list can contain
    names, IP addresses or IDs.
    Requires Tag use permission.
    #>

### Other
#### Get-MMePoOndemanScanReport

    <#
    .SYNOPSIS
    Get the info about the OnDemand Scan tasks running on the computers from thier OnDemandScan_Activity.log files.
    .DESCRIPTION
    This command retrieves a data from the OnDemand Scan log file/s on the computer/s.
    This log file (OnDemandScan_Activity.log) is located on the computer
    in the folder 'c:\programdata\mcafee\endpoint security\logs' by default.
    The path can be changed in the property $OnDemandLogPath.
    The command is looking for 'scan started' or 'scan resumed' messages in the log
    and from this line returns all next lines till the line matched
    'scan completed' or 'scan stopped' or 'scan auto paused' patterns.
    .EXAMPLE
    Get-MMePoOndemanScanReport -ComputerName comp1,comp2,comp3
    Returns all ondemand scan informations from comp1 ... comp3 computers.
    The every event is reported as an object and can be further processed through the pipe,
    or added to a variable.
    .EXAMPLE
    Get-MMePoOndemanScanReport -ComputerName omp1,comp2,comp3 | ? DateTime -gt ((get-date).AddHours(-1)) | ft
    Returns all ondemand scan informations from comp1 ... comp3 computers and filters out only last hour.
    The result is displayed as the table.
    .INPUTS
    [string[]] for $ComputerName
    [string]$OnDemandLogPath cannot be pipped into this cmdlet
    .OUTPUTS
    System.Array Output from this cmdlet is array of pscustom objects
    #>
