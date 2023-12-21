$installerUrl = "https://go.microsoft.com/fwlink/?linkid=2251836"
$installerPath = "$env:USERPROFILE\Downloads\ADS-Setup.exe"  # Save to Downloads folder
$logPath = "$env:USERPROFILE\Downloads\ADS-Install-Log.txt"
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, 'Desktop', 'ADS-Shortcut.lnk')
$adspath = "$env:USERPROFILE\AppData\Local\Programs\Azure Data Studio\azuredatastudio.exe"

# Download the installer
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Start the installation
Start-Process -FilePath $installerPath -Args "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=$logPath" -NoNewWindow

# Wait for the installation to complete (adjust the timeout as needed)
Start-Sleep -Seconds 60  # Wait for 60 seconds, you can adjust this based on the installation time

# Create a desktop shortcut
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($desktopPath)
$shortcut.TargetPath = $adspath
$shortcut.IconLocation = $adspath  # You can set the icon location if needed
$shortcut.Save()

# Get the process ID of Azure Data Studio
$adsProcess = Get-Process -Name "azuredatastudio" -ErrorAction SilentlyContinue

# Check if Azure Data Studio is running
if ($adsProcess -ne $null) {
    # Close Azure Data Studio
    Stop-Process -Id $adsProcess.Id -Force
}
