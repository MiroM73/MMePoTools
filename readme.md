# MMePoTools

- [MMePoTools](#mmepotools)
  - [Commandlets](#commandlets)
    - [Connect/Disconnect](#connectdisconnect)
      - [Connect-MMePoServer](#connect-mmeposerver)
      - [Disconnect-MMePoServer](#disconnect-mmeposerver)
    - [ClientTask](#clienttask)
      - [Get-MMePoClientTaskExport](#get-mmepoclienttaskexport)
      - [Get-MMePoClientTaskFind](#get-mmepoclienttaskfind)
      - [Invoke-MMePoClientTaskRun](#invoke-mmepoclienttaskrun)
    - [Core](#core)
      - [Get-MMePoCoreHelp](#get-mmepocorehelp)
      - [Get-MMePoCoreListPermSets](#get-mmepocorelistpermsets)
      - [Get-MMePoCoreListQueries](#get-mmepocorelistqueries)
      - [Invoke-MMePoCoreExecuteQuery](#invoke-mmepocoreexecutequery)
    - [epo](#epo)
      - [Get-MMePoGetVersion](#get-mmepogetversion)
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
    .EXAMPLE
    PS C:\>Get-MMePoClientTaskExport -Name 'ens' | select name, {$_.Section.BuildVersion}, {$_.Section.PackagePathType}
    Name                                 $_.Section.BuildVersion $_.Section.PackagePathType
    ----                                 ----------------------- --------------------------
    Install ENS Threat Prevention        10.6.11208              Current
    Install ENS Threat Prevention macOS  10.6.5101               Current
    Install ENS Threat Prevention (EVAL) 10.6.11666              Evaluation
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
    #>

### Core
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
    Get all user permission sets
    .DESCRIPTION
    List permission sets in the system.
    Requires administrator rights.
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
