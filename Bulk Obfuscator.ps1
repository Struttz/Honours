$Module = 'Invoke-Obfuscation'
If		(!(Get-Module $Module))
		{Try		{Import-Module "G:\Software\PowerShell\Modules\$Module-master\$Module.psd1"}
		 Catch		{Write-Warning "Module '$Module' could not be imported"}
		}
Function Obfuscate-Script 
{[CmdletBinding()]
 Param	([Parameter(Mandatory=$true,Position=0)][String]$ScriptPath)
# Obfuscate-Script snippet
# Assign variable $ScriptPath to the fullname of folder or file containing PowerShell script(s)
$Scripts=@()
If		((Get-Item $ScriptPath).PSIsContainer)
		{Try	{$Scripts = @(Get-ChildItem "$ScriptPath\*" -Include *.ps1)}
		 Catch	{Write-Warning "Script folder 'ScriptPath' not found";Exit 1}
		 $OutTest = "$($Scripts[0].DirectoryName) Obfuscated\$($Scripts[0].Name)"
		 $OutFolder = "$($Scripts[0].DirectoryName) Obfuscated"
		 Try	{[io.file]::OpenWrite($OutTest).close()}
		 Catch	{Write-Warning "Unable to write to output folder '$OutFolder'";Exit 2}
		}
Else	{Try	{$Scripts = @(Get-ChildItem $ScriptPath)}
		 Catch	{Write-Warning "Script file 'ScriptPath' not found";Exit 1}
		 $OutTest = "$($Scripts[0].DirectoryName) Obfuscated\$($Scripts[0].Name)"
		 $OutFolder = "$($Scripts[0].DirectoryName) Obfuscated"
		 Try	{[io.file]::OpenWrite($OutTest).close()}
		 Catch	{Write-Warning "Unable to write to output file '$OutTest'";Exit 2}
		}
$Obfuscate = 'TOKEN\ALL\1,ENCODING\6,STRING\2'
ForEach	($Script in $Scripts)
		{$ScriptFullName = $Script.FullName
# 		 $ScriptInfo = Get-Item $ScriptPath
		 $OutFullName = "$OutFolder\$($Script.Name)"
		 Write-Verbose "Obfuscating '$ScriptFullName' to '$OutFullName'"
		 Invoke-Obfuscation -ScriptPath $ScriptFullName -Command $Obfuscate -Quiet | Out-File $OutFullName
		 If		($Out = Get-Item -Path $OutFullName -ErrorAction 'SilentlyContinue')
				{$Out.CreationTime = $Script.CreationTime
				 $Out.LastWriteTime = $Script.LastWriteTime
				 $Out.LastAccessTime = $Script.LastAccessTime
				}
		}
Write-Verbose "Done"
}