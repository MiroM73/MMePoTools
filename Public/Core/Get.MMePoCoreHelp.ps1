function Get-MMePoCoreHelp
{
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
     Get-MMePoCoreHelp -DisplayAll | Select-String cleartag
     @{Command=system.clearTag; Description=names tagName [all] - Clears the tag from supplied systems}
     .EXAMPLE
     Get-MMePoCoreHelp system.clearTag
     system.clearTag names tagName [all]
     Clears the tag from supplied systems
     Requires Tag use permission
     Parameters:
      [names (param 1) | ids] - You need to either supply the "names" with a ...
    #>
    [CmdletBinding(DefaultParameterSetName = 'Command')]
    param (
        [Parameter(ParameterSetName = 'Command', Position = 0)]
        [string]
        $Command,
        [Parameter(ParameterSetName = 'Prefix')]
        [string]
        $Prefix,
        [Parameter(ParameterSetName = 'All')]
        [switch]
        $DisplayAll
    )

    TestConnectioToePoServer

    if ($Command)
    {
        $Url = "$($ePoVar.URL)/core.help?command=$($command)&:output=json"
    }
    elseif ($Prefix)
    {
        $Url = "$($ePoVar.URL)/core.help?prefix=$($Prefix)&:output=json"
    }
    else
    {
		$Url = "$($ePoVar.URL)/core.help"
		if ($DisplayAll) { $Url = "$($ePoVar.URL)/core.help?showHidden=1" }
        $EpoQuery = WebRequest -Uri $Url -Credential $ePoVar.Credential
        #(?s) ... single line mode and [dot] . always search end of line [\n]
        #(?i) ... case insensitive
        #(?:^|\n) ... do not search for a new line or an end of line
        #(\b\w+\b\.[a-z.]+?) ... prva skupina hladaneho vyrazu predstavuje slovo1.slovo2 (prikazy v ePo sa skladaju z prefixu.sufixu.pripadnedalsiesufixy)
        #+? znamena, ze hladame maximalne po najblizsi vyskyt dalsej casti regexu "lazy regex" a to medzery
        #\s+ the space is at the end of the ePo command, after it is the command description
        #(.+?) ... druha skupina predstavuje popis k predoslej skupine (prikazu), .+? znamena, ze hladame minimalnu dlzku stringu "lazy regex",
        #aby vysledkom nebol iba jeden znak, tak minimum ohranicime dalsim prikazom
        #(?=\n\b\w+\b\.\b\w+\b) ... ?= hladame nasledujuci text, ale nezahrnieme ho do vysledku (positeve lookahead)
        #hladany text je v podstate text v tvare prikazu na zaciatku riadku, respektive po zalomeni riadku v tvare prefix.sufix
        [regex]$regex = '(?s)(?i)(?:^|\n)(\b\w+\b\.[a-z.]+?)\s+(.+?)(?=\n\b\w+\b\.\b\w+\b)'
        foreach ($m in $regex.Matches($EpoQuery.Content))
        {
            [PSCustomObject]@{
                Command     = $m.Groups[1].value.trim()
                Description = ($m.Groups[2].value -replace "`r`n", " ").trim()
            }
        }
        return
    }

    try
    {
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
    catch
    {
        $_
    }
}
