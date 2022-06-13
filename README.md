# C3-Windows-Audit-Policy

This repository contains the tools used to generate Audit Policy fixlets and analyses for Windows Vista+ BigFix clients.

To download the generated Fixlets see the releases section here: https://github.com/strawgate/C3-Windows-Audit-Policy/releases

For every audit policy available four fixlets are generated:
* A fixlet that enables auditing of failure
* A fixlet that enables auditing of success
* A fixlet that disables auditing of failure
* A fixlet that disables auditing of success

For every audit policy available two analysis properties are generated:
* A property that checks whether success auditing is enabled
* A property that checks whether failure auditing is enabled

In addition, there are several other fixlets that manage things outside of the Advanced Audit Policy Configuration including:
* Clearing the Audit Policy
* Enabling Command Line Auditing for Process Creation Events
* Disabling legacy Audit Policy settings

# STIG Compliance

The following audit policies should be enabled on member servers to meet STIG auditing requirements (Server 2019):

## Server 2022, 2019, and Server 2016

The following audit policies should be enabled on Server 2022, 2019, and Server 2016 systems for STIG compliance

* Config - Audit Policy Enable failure auditing for Account Logon Credential Validation - Windows
* Config - Audit Policy Enable failure auditing for Account Management User Account Management - Windows
* Config - Audit Policy Enable failure auditing for DS Access Directory Service Access - Windows
* Config - Audit Policy Enable failure auditing for DS Access Directory Service Changes - Windows
* Config - Audit Policy Enable failure auditing for Logon/Logoff Account Lockout - Windows
* Config - Audit Policy Enable failure auditing for Logon/Logoff Logon - Windows
* Config - Audit Policy Enable failure auditing for Object Access Other Object Access Events - Windows
* Config - Audit Policy Enable failure auditing for Object Access Removable Storage - Windows
* Config - Audit Policy Enable failure auditing for Policy Change Audit Policy Change - Windows
* Config - Audit Policy Enable failure auditing for Privilege Use Sensitive Privilege Use - Windows
* Config - Audit Policy Enable failure auditing for System IPsec Driver - Windows
* Config - Audit Policy Enable failure auditing for System Other System Events - Windows
* Config - Audit Policy Enable failure auditing for System System Integrity - Windows
* Config - Audit Policy Enable success auditing for Account Logon Credential Validation Windows
* Config - Audit Policy Enable success auditing for Account Management Computer Account Management - Windows
* Config - Audit Policy Enable success auditing for Account Management Other Account Management Events - Windows
* Config - Audit Policy Enable success auditing for Account Management Security Group Management - Windows
* Config - Audit Policy Enable success auditing for Account Management User Account Management - Windows
* Config - Audit Policy Enable success auditing for DS Access Directory Service Access - Windows
* Config - Audit Policy Enable success auditing for DS Access Directory Service Changes - Windows
* Config - Audit Policy Enable success auditing for Detailed Tracking Plug and Play Events - Windows
* Config - Audit Policy Enable success auditing for Detailed Tracking Process Creation - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Account Lockout - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Group Membership - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Logoff - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Logon - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Special Logon - Windows
* Config - Audit Policy Enable success auditing for Object Access Other Object Access Events - Windows
* Config - Audit Policy Enable success auditing for Object Access Removable Storage - Windows
* Config - Audit Policy Enable success auditing for Policy Change Audit Policy Change - Windows
* Config - Audit Policy Enable success auditing for Policy Change Authentication Policy Change - Windows
* Config - Audit Policy Enable success auditing for Policy Change Authorization Policy Change - Windows
* Config - Audit Policy Enable success auditing for Privilege Use Sensitive Privilege Use - Windows
* Config - Audit Policy Enable success auditing for System IPsec Driver - Windows
* Config - Audit Policy Enable success auditing for System Other System Events - Windows
* Config - Audit Policy Enable success auditing for System Security State Change - Windows
* Config - Audit Policy Enable success auditing for System Security System Extension - Windows
* Config - Audit Policy Enable success auditing for System System Integrity - Windows

## Server 2012r2 and 2012

The following audit policies should be enabled on Server 2012r2 and 2012 systems for STIG compliance

* Config - Audit Policy Enable failure auditing for Account Logon Credential Validation - Windows
* Config - Audit Policy Enable failure auditing for Account Management User Account Management - Windows
* Config - Audit Policy Enable failure auditing for DS Access Directory Service Access - Windows
* Config - Audit Policy Enable failure auditing for DS Access Directory Service Changes - Windows
* Config - Audit Policy Enable failure auditing for Logon/Logoff Account Lockout - Windows
* Config - Audit Policy Enable failure auditing for Logon/Logoff Logon - Windows
* Config - Audit Policy Enable failure auditing for Object Access Removable Storage - Windows
* Config - Audit Policy Enable failure auditing for Policy Change Audit Policy Change - Windows
* Config - Audit Policy Enable failure auditing for Privilege Use Sensitive Privilege Use - Windows
* Config - Audit Policy Enable failure auditing for System IPsec Driver - Windows
* Config - Audit Policy Enable failure auditing for System Other System Events - Windows
* Config - Audit Policy Enable failure auditing for System System Integrity - Windows
* Config - Audit Policy Enable success auditing for Account Logon Credential Validation Windows
* Config - Audit Policy Enable success auditing for Account Management Other Account Management Events - Windows
* Config - Audit Policy Enable success auditing for Account Management Security Group Management - Windows
* Config - Audit Policy Enable success auditing for Account Management User Account Management - Windows
* Config - Audit Policy Enable success auditing for DS Access Directory Service Access - Windows
* Config - Audit Policy Enable success auditing for DS Access Directory Service Changes - Windows
* Config - Audit Policy Enable success auditing for Detailed Tracking Process Creation - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Account Lockout - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Logoff - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Logon - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Special Logon - Windows
* Config - Audit Policy Enable success auditing for Object Access Removable Storage - Windows
* Config - Audit Policy Enable success auditing for Policy Change Audit Policy Change - Windows
* Config - Audit Policy Enable success auditing for Policy Change Authentication Policy Change - Windows
* Config - Audit Policy Enable success auditing for Policy Change Authorization Policy Change - Windows
* Config - Audit Policy Enable success auditing for Privilege Use Sensitive Privilege Use - Windows
* Config - Audit Policy Enable success auditing for System IPsec Driver - Windows
* Config - Audit Policy Enable success auditing for System Other System Events - Windows
* Config - Audit Policy Enable success auditing for System Security State Change - Windows
* Config - Audit Policy Enable success auditing for System Security System Extension - Windows
* Config - Audit Policy Enable success auditing for System System Integrity - Windows

## Windows 10

The following audit policies should be enabled on Windows 10 systems for STIG compliance

* Config - Audit Policy Enable failure auditing for Account Logon Credential Validation - Windows
* Config - Audit Policy Enable failure auditing for Account Management User Account Management - Windows
* Config - Audit Policy Enable failure auditing for Logon/Logoff Account Lockout - Windows
* Config - Audit Policy Enable failure auditing for Logon/Logoff Logon - Windows
* Config - Audit Policy Enable failure auditing for Object Access File Share - Windows
* Config - Audit Policy Enable failure auditing for Object Access Other Object Access Events - Windows
* Config - Audit Policy Enable failure auditing for Object Access Removable Storage - Windows
* Config - Audit Policy Enable failure auditing for Privilege Use Sensitive Privilege Use - Windows
* Config - Audit Policy Enable failure auditing for System IPsec Driver - Windows
* Config - Audit Policy Enable failure auditing for System Other System Events - Windows
* Config - Audit Policy Enable failure auditing for System System Integrity - Windows
* Config - Audit Policy Enable success auditing for Account Logon Credential Validation Windows
* Config - Audit Policy Enable success auditing for Account Management Computer Account Management - Windows
* Config - Audit Policy Enable success auditing for Account Management Other Account Management Events - Windows
* Config - Audit Policy Enable success auditing for Account Management Security Group Management - Windows
* Config - Audit Policy Enable success auditing for Account Management User Account Management - Windows
* Config - Audit Policy Enable success auditing for Detailed Tracking Process Creation - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Group Membership - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Logoff - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Logon - Windows
* Config - Audit Policy Enable success auditing for Logon/Logoff Special Logon - Windows
* Config - Audit Policy Enable success auditing for Object Access File Share - Windows
* Config - Audit Policy Enable success auditing for Object Access Other Object Access Events - Windows
* Config - Audit Policy Enable success auditing for Object Access Removable Storage - Windows
* Config - Audit Policy Enable success auditing for Policy Change Audit Policy Change - Windows
* Config - Audit Policy Enable success auditing for Policy Change Authentication Policy Change - Windows
* Config - Audit Policy Enable success auditing for Policy Change Authorization Policy Change - Windows
* Config - Audit Policy Enable success auditing for Privilege Use Sensitive Privilege Use - Windows
* Config - Audit Policy Enable success auditing for System IPsec Driver - Windows
* Config - Audit Policy Enable success auditing for System Other System Events - Windows
* Config - Audit Policy Enable success auditing for System Security State Change - Windows
* Config - Audit Policy Enable success auditing for System Security System Extension - Windows
* Config - Audit Policy Enable success auditing for System System Integrity - Windows