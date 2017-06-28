﻿#region Initialize Cache
if (-not [Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Cache["snapshot"]) {
	[Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Cache["snapshot"] = @{ }
}
#endregion Initialize Cache

#region Tepp Data return
$ScriptBlock = {
    param (
        $commandName,
        
        $parameterName,
        
        $wordToComplete,
        
        $commandAst,
        
        $fakeBoundParameter
    )
    
    $start = Get-Date
    [Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Scripts["snapshot"].LastExecution = $start
	
	$server = $fakeBoundParameter['SqlInstance']
	
	if (-not $server) {
		$server = $fakeBoundParameter['Source']
	}
	
	if (-not $server) {
		$server = $fakeBoundParameter['ComputerName']
	}
	
	if (-not $server) { return }
	
    try
    {
        [DbaInstanceParameter]$parServer = $server | Select-Object -First 1
    }
    catch
    {
        [Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Scripts["snapshot"].LastDuration = (Get-Date) - $start
        return
    }
    
    if ([Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Cache["snapshot"][$parServer.FullSmoName.ToLower()])
    {
        foreach ($name in ([Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Cache["snapshot"][$parServer.FullSmoName.ToLower()] | Where-DbaObject -Like "$wordToComplete*"))
        {
            New-DbaTeppCompletionResult -CompletionText $name -ToolTip $name
        }
        [Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Scripts["snapshot"].LastDuration = (Get-Date) - $start
        return
    }
    
    try
    {
        foreach ($name in ([Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Cache["snapshot"][$parServer.FullSmoName.ToLower()] | Where-DbaObject -Like "$wordToComplete*"))
        {
            New-DbaTeppCompletionResult -CompletionText $name -ToolTip $name
        }
        [Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Scripts["snapshot"].LastDuration = (Get-Date) - $start
        return
    }
    catch
    {
        [Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Scripts["snapshot"].LastDuration = (Get-Date) - $start
        return
    }
}

Register-DbaTeppScriptblock -ScriptBlock $ScriptBlock -Name snapshot
#endregion Tepp Data return

#region Update Cache
$ScriptBlock = {
	if ($PSVersionTable.PSVersion.Major -ge 4) { [Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Cache["snapshot"][$FullSmoName] = $server.Databases.Where({ $_.IsDatabaseSnapShot }).Name }
	else { [Sqlcollaborative.Dbatools.TabExpansion.TabExpansionHost]::Cache["snapshot"][$FullSmoName] = ($server.Databases | Where-Object IsDatabaseSnapShot).Name }
}
Register-DbaTeppInstanceCacheBuilder -ScriptBlock $ScriptBlock
#endregion Update Cache
