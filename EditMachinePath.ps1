$pathVariables = @("C:\Program Files (x86)\Notepad++")

function system-environmentvariable-exists($k, $v){
	if ($k -eq "Path"){
		return ([Environment]::GetEnvironmentVariable($k, [EnvironmentVariableTarget]::Machine)).Contains($v)
	} else {
		return ([Environment]::SetEnvironmentVariable($k, $v, [EnvironmentVariableTarget]::Machine) -ne $null)
	}
}
function system-environmentvariable-set($k, $v){
	if ($k -eq "Path"){
		[Environment]::SetEnvironmentVariable($k, ($env:Path + ";" + $v), [EnvironmentVariableTarget]::Machine)
	} else {
		[Environment]::SetEnvironmentVariable($k, $v, [EnvironmentVariableTarget]::Machine)
	}
}

$oldverbose = $VerbosePreference
$VerbosePreference = "continue"
foreach ($pathVariable in $pathVariables){
	if (!(system-environmentvariable-exists "Path" $pathVariable)){
		Write-Verbose "Key does not exist: $pathVariable"
		Write-Verbose "Adding..."
		system-environmentvariable-set "Path" $pathVariable
		Write-Verbose "Key added"
	} else {
		Write-Verbose "Key already exists. Skipping..."
	}
}
$VerbosePreference = $oldverbose