# Add a menu choice to open powershell at the current location when right clicking
function Add-OpenPowershellWhenRightClicking(){
	$menu = 'Admin PS Here'
	$command = "$PSHOME\powershell.exe -NoExit -NoProfile -Command ""Set-Location '%V'"""
	'directory', 'directory\background', 'drive' | ForEach-Object {
		New-Item -Path "Registry::HKEY_CLASSES_ROOT\$_\shell" -Name runas\command -Force |
		Set-ItemProperty -Name '(default)' -Value $command -PassThru |
		Set-ItemProperty -Path {$_.PSParentPath} -Name '(default)' -Value $menu -PassThru |
		Set-ItemProperty -Name HasLUAShield -Value ''
	}
}

# Make powershell replace command prompt when pressing 'windows key' + 'x' -> 'a' or right clicking the start menu. 
# Starts working when computer reboots.
function Set-PowershellAsDefaultCommandLine(){
	New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name DontUsePowerShellOnWinX -PropertyType DWord -Value 0 -force
}

function Add-BatchFileToRightClickNew(){
	New-Item -Path "Registry::HKEY_CLASSES_ROOT\.bat" -Name ShellNew –Force
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\.bat\ShellNew" -Name NullFile -PropertyType String
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\.bat\ShellNew" -Name ItemName -PropertyType ExpandString -Value "@%SystemRoot%\System32\acppage.dll,-6002"
}

function Add-PowershellScriptToRightClickNew(){
	New-Item -Path "Registry::HKEY_CLASSES_ROOT\.ps1" -Name ShellNew –Force
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\.ps1\ShellNew" -Name NullFile -PropertyType String
}

function Call-Scripts{
    & ".\ImportModules.ps1"
	& ".\EditMachinePath.ps1"
}

########
# MAIN #
########
# {

    Add-OpenPowershellWhenRightClicking
    Set-PowershellAsDefaultCommandLine
    Add-BatchFileToRightClickNew
    Add-PowershellScriptToRightClickNew
    Call-Scripts
	
# }