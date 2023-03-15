# Copyright 2022 SahiDemon|SahinduGayanuka. 

param (
  [string] $version
)

$PSMinVersion = 3

if ($v) {
    $version = $v
}

# Helper functions for pretty terminal output.
function Write-Part ([string] $Text) {
  Write-Host $Text -NoNewline
}

function Write-Emphasized ([string] $Text) {
  Write-Host $Text -NoNewLine -ForegroundColor "Cyan"
}

function Write-Done {
  Write-Host " > " -NoNewline
  Write-Host "OK" -ForegroundColor "Green"
}

if ($PSVersionTable.PSVersion.Major -gt $PSMinVersion) {
  $ErrorActionPreference = "Stop"

  # Enable TLS 1.2 since it is required for connections to GitHub.
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12



  # Create ~\proxy directory if it doesn't already exist
  $sp_dir = "${HOME}\ProxyManager\v2rayN"
  if (-not (Test-Path $sp_dir)) {
    Write-Part "MAKING FOLDER  "; Write-Emphasized $sp_dir
    New-Item -Path $sp_dir -ItemType Directory | Out-Null
    Write-Done
  }

  # Download release.
  $zip_file = "${sp_dir}\v2rayN.zip"
  $download_uri = "https://github.com/SahiDemon/ProxyManager/blob/main/v2rayN-Core.rar"
  Write-Part "DOWNLOADING    "; Write-Emphasized $download_uri
  Invoke-WebRequest -Uri $download_uri -UseBasicParsing -OutFile $zip_file
  Write-Done

  
  # Extract zip and assets from .zip file.
  Write-Part "EXTRACTING     "; Write-Emphasized $zip_file
  Write-Part " into "; Write-Emphasized ${sp_dir};
  # Using -Force to overwrite spicetify.exe and assets if it already exists
  Expand-Archive -Path $zip_file -DestinationPath $sp_dir -Force
  Write-Done

    # Remove .zip file.
  Write-Part "REMOVING       "; Write-Emphasized $zip_file
  Remove-Item -Path $zip_file
  Write-Done


  Write-Done "`n v2ray files download sucessfull."
  Write-Part "Run "; Write-Emphasized "ProxyManager.bat"; Write-Host " to get started.`n"

  $Folder = 'C:\Program Files (x86)\Proxifier\Proxifier.exe'
  if (Test-Path -Path $Folder) {
      "Proxifier Detected"
      Invoke-Item "${HOME}\ProxyManager\proxydata-main\newProxy.ppx"
      "Press 'OK' In the following prompt to load pre-built config into proxifier"
      Start-Sleep -Seconds 3
      Invoke-Item "${HOME}\ProxyManager\proxydata-main\proxydev.bat"
      "Close this window and continue the intallation in ProxyManager"
      Start-Sleep -Seconds 2
      Write-Part "Script By "; Write-Emphasized "SahiDemon|SahinduGayanuka "; Write-Host "| ProxyManager.`n"

  } else {
      "Proxifier doesn't exist."
      "Auto Setup Proxifier In Progess"
      Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
      choco install proxifier -y
      Write-Part "ProxyManager "; Write-Emphasized "By SahiDemon|SahinduGayanuka"; Write-Host " Run ProxyManager.Bat.`n"
      Invoke-Item "${HOME}\ProxyManager\proxydata-main\newProxy.ppx"
      "Press 'OK' In the following prompt to load pre-built config into proxifier"
      Start-Sleep -Seconds 3
      Invoke-Item "${HOME}\ProxyManager\proxydata-main\proxydev.bat"
      "Close this window and continue the intallation in ProxyManager"
      Start-Sleep -Seconds 2
      Write-Part "Script By"; Write-Emphasized " SahiDemon|SahinduGayanuka"; Write-Host " | ProxyManager.`n"
  }

}
else {
  Write-Part "`nYour Powershell version is lesser than "; Write-Emphasized "$PSMinVersion";
  Write-Part "`nPlease, update your Powershell downloading the "; Write-Emphasized "'Windows Management Framework'"; Write-Part " greater than "; Write-Emphasized "$PSMinVersion"
}

 