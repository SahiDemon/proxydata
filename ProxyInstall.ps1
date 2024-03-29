# Copyright 2023 SahiDemon|SahinduGayanuka. 

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

Write-Host "Copyright 2023 SahiDemon - Script By SahinduGayanuka. "
# Check if running with admin privileges
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$url = "https://raw.githubusercontent.com/SahiDemon/proxydata/main/ProxyInstall.ps1"
$arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"& { iwr -useb $url | iex }`""

if (-not $isAdmin) {
    # Not running as admin, prompt the user to run with elevated privileges
    Write-Host "This script requires administrative privileges. Please Grant Access to proceed."
    # Restart the script from the specified URL as an administrator
    Start-Process -FilePath "powershell.exe" -Verb RunAs -ArgumentList $arguments

    # Exit the current script
    exit
}

# Code to be executed with administrative privileges goes here
Write-Host "Running with administrative privileges!"

Write-Host "Password for Controlled Execution: Authorizes secure script access "
function Get-Password {
  param (
      [string]$Prompt = "Enter the password to continue the script"
  )

  $securePassword = Read-Host -Prompt $Prompt -AsSecureString
  return $securePassword
}

$correctPassword = "sahiproxy321"

# Ask for the password
$enteredPassword = Get-Password

# Convert the entered password to plain text
$enteredPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($enteredPassword))

# Check if the entered password matches the correct password
if ($enteredPasswordPlain -eq $correctPassword) {



$folderPath = "$env:USERPROFILE\AppData\Roaming\Ookla\Speedtest CLI"
$filePath = "$folderPath\speedtest-cli.ini"
$content = @"
[Settings]
LicenseAccepted=604ec27f828456331ebf441826292c49276bd3c1bee1a2f65a6452f505c4061c
"@

# Create the folder if it does not exist
if (-not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

$encoding = [System.Text.Encoding]::UTF8
$bytes = $encoding.GetBytes($content)
Set-Content -Path $filePath -Value $bytes -Encoding Byte

if ($PSVersionTable.PSVersion.Major -gt $PSMinVersion) {
  $ErrorActionPreference = "Stop"

  # Enable TLS 1.2 since it is required for connections to GitHub.
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

  # Create ~\proxy directory if it doesn't already exist
  $sp_dir = "${HOME}\ProxyManager"
  if (-not (Test-Path $sp_dir)) {
    Write-Part "MAKING FOLDER  "; Write-Emphasized $sp_dir
    New-Item -Path $sp_dir -ItemType Directory | Out-Null
    Write-Done
  }


  # Download release.
  $zip_file = "${sp_dir}\v2rayN.zip"
  $download_uri = "https://github.com/SahiDemon/v2ray/releases/download/1.0v/v2rayN-Core.zip"
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

  # Download release.
  $zip_file = "${sp_dir}\proxymain.zip"
  $download_uri = "https://github.com/SahiDemon/proxydata/archive/refs/heads/main.zip"
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

  Write-Done "`nProxy Manager files downloaded successfully."
  Write-Part "Run "; Write-Emphasized "ProxyManager By SahiDemon"; Write-Host " to get started.`n"

  $proxifierFolder = 'C:\Program Files (x86)\Proxifier\Proxifier.exe'
  if (Test-Path -Path $proxifierFolder) {
      Write-Host "Proxifier Detected"
      Invoke-Item "${HOME}\ProxyManager\proxydata-main\newProxy.ppx"
      Write-Host "Press 'OK' in the following prompt to load the pre-built config into Proxifier"
      Start-Sleep -Seconds 3
      Set-ItemProperty -Path 'HKCU:\Environment' -Name 'Path' -Value "$($env:Path);$($env:USERPROFILE)\ProxyManager\proxydata-main\httping.exe"
      Invoke-Item "${HOME}\ProxyManager\proxydata-main\Proxy Manager.bat"
      Write-Host "Close this window and continue the installation in Proxy Manager"
      Start-Sleep -Seconds 2
      Write-Part "Script By "; Write-Emphasized "SahiDemon SahinduGayanuka"; Write-Host " ProxyManager.`n"
      Start-Sleep -Seconds 8
  } else {
      Write-Host "Proxifier doesn't exist."
      Write-Host "Auto Setup Proxifier In Progress"
      Set-ExecutionPolicy Bypass -Scope Process -Force
      [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
      iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
      choco install proxifier -y
      Write-Part "ProxyManager "; Write-Emphasized "By SahiDemon SahinduGayanuka"; Write-Host " Run ProxyManager.Bat.`n"
      Invoke-Item "${HOME}\ProxyManager\proxydata-main\newProxy.ppx"
      Write-Host "Press 'OK' in the following prompt to load the pre-built config into Proxifier"
      Start-Sleep -Seconds 3
      Set-ItemProperty -Path 'HKCU:\Environment' -Name 'Path' -Value "$($env:Path);$($env:USERPROFILE)\ProxyManager\proxydata-main\httping.exe"
      Invoke-Item "${HOME}\ProxyManager\proxydata-main\Proxy Manager.bat"
      Write-Host "Close this window and continue the installation in ProxyManager"
      Start-Sleep -Seconds 2
      Write-Part "Script By"; Write-Emphasized " SahiDemon SahinduGayanuka"; Write-Host " ProxyManager.`n"
      Start-Sleep -Seconds 8
  }

}
else {
  Write-Part "`nYour PowerShell version is lower than "; Write-Emphasized "$PSMinVersion";
  Write-Part "`nPlease update your PowerShell by downloading the "; Write-Emphasized "'Windows Management Framework'"; Write-Part " greater than "; Write-Emphasized "$PSMinVersion"
}


} else {
  # If the password is incorrect, display an error message
  Write-Host "Incorrect password. Script execution aborted."
}








