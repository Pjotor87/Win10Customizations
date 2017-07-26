function Ensure-ModuleDirectoryForCurrentUser{
    $documentsForCurrentUser = "C:\Users\$env:USERNAME\Documents"
    if ((Test-Path $documentsForCurrentUser)){
        $powershellForCurrentUser = "$documentsForCurrentUser\WindowsPowerShell"
        if(!(Test-Path $powershellForCurrentUser)){
            New-Item $powershellForCurrentUser -ItemType Directory
        }
        if((Test-Path $powershellForCurrentUser)){
            $modulesForCurrentUser = "$powershellForCurrentUser\Modules"
            if(!(Test-Path $modulesForCurrentUser)){
                New-Item $modulesForCurrentUser -ItemType Directory
            }
        }
    }
}
Ensure-ModuleDirectoryForCurrentUser

function Add-Modules{
	$modulesPath = "$PSScriptRoot\Modules"
	$modules = Get-ChildItem $modulesPath | ?{ $_.PSIsContainer } | Select Name,FullName
	$destinationModulesFolder = "C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules"
	foreach ($module in $Modules){
		$destination = ($destinationModulesFolder + "\" + $module.Name)
		if((Test-Path $destination)){
			rmdir $destination # Prompt for removal of existing directory
		}
		if(!(Test-Path $destination)){
			Copy-Item -Path $module.FullName -Destination $destination -Recurse
		}
	}
}
Add-Modules