# Copyright 2022 SahiDemon|SahinduGayanuka. 


# Check if the current PowerShell session has administrative privileges

param (
    [string] $version
)

$PSMinVersion = 3

if ($version) { # Fix: Corrected variable name from $v to $version
        $version = $version
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


$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host "This script is running with administrative privileges. Please grant the permissions if prompted."
# If not running as administrator, relaunch the script with elevated privileges
if (-not $isAdmin) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        Exit
}

# Code requiring admin privileges goes here


if ($PSVersionTable.PSVersion.Major -gt $PSMinVersion) {
    $ErrorActionPreference = "Stop"

    # Enable TLS 1.2 since it is required for connections to GitHub.
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12



    # Create ~\proxy directory if it doesn't already exist
    $sp_dir = "${HOME}\ProxyManager\Netch"
    if (-not (Test-Path $sp_dir)) {
        Write-Part "MAKING FOLDER  "; Write-Emphasized $sp_dir
        New-Item -Path $sp_dir -ItemType Directory | Out-Null
        Write-Done
    }




    # Download release.
    $zip_file = "${sp_dir}\Netch.zip"
    $download_uri = "https://raw.githubusercontent.com/SahiDemon/netch/main/Netch.zip"
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


    Write-Done "`n Netch files download successful."
    Write-Part "Process Will "; Write-Emphasized "Automatically"; Write-Host "Started.`n"


    Write-Part "Close this window and continue the installation in ProxyManager"
    Start-Sleep -Seconds 2
    Write-Part "Script By"; Write-Emphasized " SahiDemon SahinduGayanuka"; Write-Host "  ProxyManager.`n"
    Start-Sleep -Seconds 8

}
else {
    Write-Part "`nYour Powershell version is lesser than "; Write-Emphasized "$PSMinVersion";
    Write-Part "`nPlease, update your Powershell downloading the "; Write-Emphasized "'Windows Management Framework'"; Write-Part " greater than "; Write-Emphasized "$PSMinVersion"
}

 