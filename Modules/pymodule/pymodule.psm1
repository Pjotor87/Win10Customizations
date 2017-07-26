function new-py {
$projectLocation = ((Get-Location).Path + "\$args")
$pyCharmPath = "C:\Program Files (x86)\JetBrains\PyCharm Community Edition 2016.3.3\bin\pycharm.exe"
$mainContent = 
'#!/usr/bin/env python
# -*- coding: utf-8 -*-
import logging
import pyutil
config = pyutil.init_and_get_config("pyconfig.txt")
"""
Description: 
"""

def main():
	pass
        
if __name__ == "__main__":
    main()'
$pyUtilContent = 
'#!/usr/bin/env python
# -*- coding: utf-8 -*-
import ConfigParser
"""
Description: Imports logging and ConfigParser
"""
def init_and_get_config(config_file_name):
	config = None
	try:
		config = ConfigParser.ConfigParser()
		config.read(config_file_name)
	except:
		import logging
		logging.basicConfig(filename="debug.log",level=logging.DEBUG)
		logging.debug("Failed to import ConfigParser")
	else:
		if config.get("Logging", "Active").lower() == "true":
			if config.get("Logging", "Mode").lower() == "debug":
				logging.basicConfig(filename="debug.log",level=logging.DEBUG)
	return config'
$configContent = 
'[Logging]
Active: true
Mode: debug'
$freezeRequirementsAndCommitContent =
'@echo off
call workon $args
pip freeze > Requirements.txt
git add Requirements.txt
git commit -m "Requirements updated"'
$startVirtualEnvContent = 
'@echo off
:: Ask if user wants to start powershell as admin and load virtualenv
CHOICE /M "Open powershell and boot virtualenv"
IF "%ERRORLEVEL%" == "1" goto :start_powershell_and_boot_virtualenv
IF "%ERRORLEVEL%" == "2" goto :do_not_start_powershell_and_boot_virtualenv
:start_powershell_and_boot_virtualenv
SET STARTVIRTUALENVSCRIPTPATH=%~dp0start_virtualenv.ps1
PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList ''-NoProfile -NoExit -ExecutionPolicy Bypass -File ""%STARTVIRTUALENVSCRIPTPATH%""'' -Verb RunAs}"
:do_not_start_powershell_and_boot_virtualenv
exit'
$startVirtualEnvPowershellContent = 
'$virtualenvName = "'+$args+'"
ps-workon $virtualenvName'
$startDevelopmentContent =
'@echo off
:: Start pycharm
SET PYCHARMPATH="'+$pyCharmPath+'"
SET PROJECTDIRECTORY="'+$projectLocation+'"
start "" %PYCHARMPATH% %PROJECTDIRECTORY%
:: Prompt for starting powershell and loading virtualenv
timeout 15
SET STARTVIRTUALENVPATH="%~dp0start_virtualenv.bat"
start "" %STARTVIRTUALENVPATH%'
	$dirExists = Test-Path $args
	if ($dirExists -eq $false){
		# Create Virtualenv
		mkvirtualenv $args
		. "$env:USERPROFILE\Envs\$args\Scripts\activate.ps1"
		mkdir $args
		setprojectdir $args
		Set-Location -Path $projectLocation
		## Create base files
		New-Item "$args.py" -Force -Value $mainContent
		New-Item "pyutil.py" -Force -Value $pyUtilContent
		New-Item "pyconfig.txt" -Force -Value $configContent
		New-Item "freeze_requirements_and_commit.bat" -Force -Value $freezeRequirementsAndCommitContent
		New-Item "start_virtualenv.bat" -Force -Value $startVirtualEnvContent
		New-Item "start_virtualenv.ps1" -Force -Value $startVirtualEnvPowershellContent
		New-Item "start_development.bat" -Force -Value $startDevelopmentContent
		## Init git repository and do initial commit
		git init
		git add .
		git commit -m "Initial commit"
		Write-Output "Install all of the desired python packages and run 'freeze_requirements_and_commit.bat' to save a Requirements file."
		Write-Output "Use 'start_development.bat' to begin working on the project"
	}
}

function ps-workon{
	# Set directory path in shell to project directory if one has been set
	$projectDir = Get-Content "$env:USERPROFILE\Envs\$args\.project" -First 1 -ErrorAction 'silentlycontinue'
	if ($projectDir -ne $null){
		if (Test-Path $projectDir){
			cd $projectDir
		}
	}
	# Activate virtualenv the powershell way
	. "$env:USERPROFILE\Envs\$args\Scripts\activate.ps1"
}