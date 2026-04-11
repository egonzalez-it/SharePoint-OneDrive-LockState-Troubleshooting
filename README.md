![Microsoft 365](https://img.shields.io/badge/Microsoft%20365-Admin-blue)
![SharePoint Online](https://img.shields.io/badge/SharePoint-Online-green?logo=microsoftsharepoint)
![OneDrive](https://img.shields.io/badge/OneDrive-Business-0078D4?logo=microsoftonedrive)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey?logo=windows)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)
![Maintained](https://img.shields.io/badge/Maintained-Yes-success)


# SharePoint Online OneDrive LockState Troubleshooting

Resolve OneDrive access issues caused by a locked or read-only site in SharePoint Online.

This repository documents a real-world administrative scenario where a user's OneDrive could not be accessed or shared due to the site being in a **ReadOnly / Locked state**.

---

## 🚨 Problem Overview

An administrator was unable to:

- Open a user’s OneDrive
- Generate a sharing link
- Access files via admin portal

Investigation revealed that the OneDrive site had a **LockState ≠ Unlock**, preventing normal operations.

---

## 🔍 Why Does OneDrive Become Read-Only (Locked)?

A OneDrive site may enter a **ReadOnly or Locked state** for several reasons:

### 1. User Offboarding / License Removal
- When a user license is removed, OneDrive may:
  - Transition to a restricted state
  - Be scheduled for deletion
  - Become inaccessible for sharing

### 2. Retention Policies (Microsoft Purview)
- If retention policies are applied:
  - The site may be preserved
  - Modifications can be restricted
  - Admin access may behave inconsistently

### 3. Manual Administrative Action
- An admin may have set:
Set-SPOSite -LockState ReadOnly  
Set-SPOSite -LockState NoAccess  

### 4. Storage Quota Issues
- If the OneDrive exceeds quota:
  - It can become read-only
  - Uploads and sharing may fail

### 5. Account Deletion / Disabled Account
- When a user is:
  - Disabled in Entra ID
  - Deleted or soft-deleted
- OneDrive may remain but behave as locked

### 6. OneDrive Retention / Preservation Hold
- During offboarding:
  - OneDrive may be retained for X days
  - Ownership changes may occur
  - Access may be limited

---

## 🧠 Key Insight

Even if:
- The site exists  
- The URL resolves  
- Admin permissions are correct  

A non-Unlock LockState will silently block operations like sharing links.

---

## ⚙️ Requirements

- SharePoint Online Management Shell
- SharePoint Administrator role
- OneDrive personal site URL

Install module if needed:

Install-Module Microsoft.Online.SharePoint.PowerShell

---

## 🛠️ Troubleshooting Steps

### 1. Connect to SharePoint Online
```powershell
Connect-SPOService -Url https://<tenant>-admin.sharepoint.com
```
### 2. Check OneDrive Site Status
```powershell
Get-SPOSite -Identity https://<tenant>-my.sharepoint.com/personal/<user_identifier>  
| Select Owner, StorageUsageCurrent, StorageQuota, LockState
```
### 3. Unlock the Site
```powershell
Set-SPOSite -Identity https://<tenant>-my.sharepoint.com/personal/<user_identifier> -LockState Unlock
```
### 4. Validate
```powershell
Get-SPOSite -Identity https://<tenant>-my.sharepoint.com/personal/<user_identifier>  
| Select LockState
```
---

## ✅ Expected Result

- LockState = Unlock  
- OneDrive link generation works  
- Admin access restored  
- Files accessible again  

---

## ⚠️ Important Considerations

- Unlocking does NOT:
  - Restore a deleted user
  - Reassign licenses
  - Override retention policies

Always verify:
- User account status
- Licensing
- Retention policies
- Ownership permissions

---

## 🔎 Additional Checks (If Issue Persists)

Get-MsolUser -UserPrincipalName user@domain.com  

Get-SPOSite -IncludePersonalSite $true  

Get-SPOUser -Site <OneDriveURL>  

---

## 📁 Repository Structure
```cmd
SharePoint-OneDrive-LockState-Troubleshooting/  
├── README.md  
└── Commands/  
    └── Unlock-OneDriveSite.ps1  
```
---

## 💡 Use Cases

- User offboarding cleanup  
- Recovering access to inactive users' files  
- Fixing OneDrive sharing failures  
- Tenant audits and remediation  
- Service Desk / L2 troubleshooting scenarios  

---

## 🔐 Security Note

This repository uses sanitized examples:
- No real tenant names
- No user identifiers
- No internal URLs

---

## 📌 Summary

If you cannot:
- Open a OneDrive  
- Generate a sharing link  
- Access content as admin  

Always check LockState first.

---

## 📜 License

MIT
