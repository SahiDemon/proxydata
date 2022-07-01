#github url to download zip file
#Assign zip file url to local variable

$Url = "https://github.com/SahiDemon/proxydata/archive/refs/heads/main.zip"

$DownloadZipFile = "D:\ZipFile\" + $(Split-Path -Path $Url -Leaf)

$ExtractPath = "D:\UnZipFiles\"

Invoke-WebRequest -Uri $Url -OutFile $DownloadZipFile

$ExtractShell = New-Object -ComObject Shell.Application 

$ExtractFiles = $ExtractShell.Namespace($DownloadZipFile).Items() 

$ExtractShell.NameSpace($ExtractPath).CopyHere($ExtractFiles) 
Start-Process $ExtractPath


