function new-html5 {
	$projectLocation = ((Get-Location).Path + "\$args")
	$dirExists = Test-Path $args
	if ($dirExists -eq $false){
		mkdir $args
	}
	$dirExists = Test-Path $args
	if ($dirExists -eq $true){
		$html5BoilerplateUrl = "https://html5boilerplate.com/"
		$WebResponse = Invoke-WebRequest $html5BoilerplateUrl
		$linksOnPage = $WebResponse.Links
		$html5BoilerplateDownloadLink = ""
		foreach ($link in $linksOnPage){
			if ($link.href.StartsWith("https://github.com/h5bp/html5-boilerplate/releases/download") -and $link.href.EndsWith(".zip")) {
				$html5BoilerplateDownloadLink = $link.href
				break
			}
		}
		$tempZipFilePath = "html5Boilerplate.zip"
		
		Write-Output ("Downloading boilerplate from: " + $html5BoilerplateDownloadLink)
		if ([Net.ServicePointManager]::SecurityProtocol.ToString().Contains("Tls12") -eq $false){
			Write-Output "Setting SecurityProtocol..."
			[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		}
		wget $html5BoilerplateDownloadLink -OutFile $tempZipFilePath
		
		if(Test-Path $tempZipFilePath){
			Write-Output "Downloaded the file! Unzipping..."
			Expand-Archive $tempZipFilePath -DestinationPath $projectLocation
			Set-Location -Path $projectLocation
			## Init git repository and do initial commit
			git init
			git add .
			git commit -m "Initial commit"
		}
	}
}