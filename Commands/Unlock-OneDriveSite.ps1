<# 
.SYNOPSIS
    Checks a OneDrive site LockState and unlocks it if needed.

.DESCRIPTION
    This script connects to SharePoint Online, reviews a target OneDrive site,
    displays key properties, and optionally unlocks the site.

.NOTES
    Replace all placeholder values before use.

.HOW TO USE

    Run in Check Mode (No Changes)

.\Unlock-OneDriveSite.ps1 `
-AdminUrl "https://yourtenant-admin.sharepoint.com" `
-OneDriveUrl "https://yourtenant-my.sharepoint.com/personal/user_domain_com"

---
    Run in Fix Mode (Unlock)

.\Unlock-OneDriveSite.ps1 `
-AdminUrl "https://yourtenant-admin.sharepoint.com" `
-OneDriveUrl "https://yourtenant-my.sharepoint.com/personal/user_domain_com" `
-Unlock

#>

param(
    [Parameter(Mandatory = $true)]
    [string]$AdminUrl,

    [Parameter(Mandatory = $true)]
    [string]$OneDriveUrl,

    [switch]$Unlock
)

Write-Host "Connecting to SharePoint Online admin center..." -ForegroundColor Cyan
Connect-SPOService -Url $AdminUrl

Write-Host "Reviewing OneDrive site..." -ForegroundColor Cyan
$site = Get-SPOSite -Identity $OneDriveUrl | Select Owner, StorageUsageCurrent, StorageQuota, LockState
$site | Format-List

if ($Unlock) {
    if ($site.LockState -ne "Unlock") {
        Write-Host "Unlocking OneDrive site..." -ForegroundColor Yellow
        Set-SPOSite -Identity $OneDriveUrl -LockState Unlock

        Write-Host "Verifying updated LockState..." -ForegroundColor Cyan
        Get-SPOSite -Identity $OneDriveUrl | Select Owner, StorageUsageCurrent, StorageQuota, LockState | Format-List
    }
    else {
        Write-Host "The OneDrive site is already unlocked." -ForegroundColor Green
    }
}
else {
    Write-Host "No changes made. Re-run with -Unlock to change the LockState." -ForegroundColor DarkYellow
}
