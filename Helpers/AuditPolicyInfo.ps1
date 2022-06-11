
$AuditCategoriesToDescriptions = [ordered] @{
    "Account Logon"      = "Account Logon audit policy settings help you document attempts to authenticate account data on a domain controller or on a local Security Accounts Manager (SAM). Unlike Logon and Logoff policy settings and events, Account Logon settings and events focus on the account database that is used. "
    "Account Management" = "Account Management audit policy settings can be used to monitor changes to user and computer accounts and groups."
    "DS Access"          = "DS Access or Domain Services Access audit policy settings provide a detailed audit trail of attempts to access and modify objects in Active Directory Domain Services (AD DS). These audit events are logged only on domain controllers."
    "Detailed Tracking"  = "Detailed Tracking audit policy settings help you monitor the activities of individual applications and users on a computer in order to understand how the computer is being used."
    "Logon/Logoff"       = "Logon/Logoff audit policy settings allow you to track attempts to log on to a computer interactively or over a network. These events are particularly useful for tracking user activity and identifying potential attacks on network resources."
    "Object Access"      = "Object Access audit policy settings allow you to track attempts to access specific objects or types of objects on a network or computer. To audit attempts to access a file, directory, registry key, or any other object, enable the appropriate Object Access auditing subcategory for success and/or failure events. For example, the file system subcategory needs to be enabled to audit file operations; the Registry subcategory needs to be enabled to audit registry accesses. Proving that these audit policies are in effect to an external auditor is more difficult. There is no easy way to verify that the proper SACLs are set on all inherited objects. "
    "Policy Change"      = "Policy Change audit policy settings allow you to track changes to important security policies on a local system or network. Because policies are typically established by administrators to help secure network resources, tracking changes (or its attempts) to these policies is an important aspect of security management for a network."
    "Privilege Use"      = "Privilege Use audit policy settings allow you to track the use of certain permissions on one or more systems."
    "System"             = "System audit policy settings allow you to track changes not included in other categories that may have potential security implications."
}  

$AuditCategoriesToSubcategoriesToGuids = [ordered] @{
    "Account Logon"      = [ordered] @{
        "Credential Validation"              = "{0CCE923F-69AE-11D9-BED3-505054503030}"
        "Kerberos Authentication Service"    = "{0CCE9242-69AE-11D9-BED3-505054503030}"
        "Kerberos Service Ticket Operations" = "{0CCE9240-69AE-11D9-BED3-505054503030}"
        "Other Account Logon Events"         = "{0CCE9241-69AE-11D9-BED3-505054503030}"
    }
    "Account Management" = [ordered] @{
        "Application Group Management"    = "{0CCE9239-69AE-11D9-BED3-505054503030}"
        "Computer Account Management"     = "{0CCE9236-69AE-11D9-BED3-505054503030}"
        "Distribution Group Management"   = "{0CCE9238-69AE-11D9-BED3-505054503030}"
        "Other Account Management Events" = "{0CCE923A-69AE-11D9-BED3-505054503030}"
        "Security Group Management"       = "{0CCE9237-69AE-11D9-BED3-505054503030}"
        "User Account Management"         = "{0CCE9235-69AE-11D9-BED3-505054503030}"
    }
    "DS Access"          = [ordered] @{
        "Detailed Directory Service Replication" = "{0CCE923E-69AE-11D9-BED3-505054503030}"
        "Directory Service Access"               = "{0CCE923B-69AE-11D9-BED3-505054503030}"
        "Directory Service Changes"              = "{0CCE923C-69AE-11D9-BED3-505054503030}"
        "Directory Service Replication"          = "{0CCE923D-69AE-11D9-BED3-505054503030}"
    }
    "Detailed Tracking"  = [ordered] @{
        "DPAPI Activity"              = "{0CCE922D-69AE-11D9-BED3-505054503030}"
        "Plug and Play Events"        = "{0CCE9248-69AE-11D9-BED3-505054503030}"
        "Process Creation"            = "{0CCE922B-69AE-11D9-BED3-505054503030}"
        "Process Termination"         = "{0CCE922C-69AE-11D9-BED3-505054503030}"
        "RPC Events"                  = "{0CCE922E-69AE-11D9-BED3-505054503030}"
        "Token Right Adjusted Events" = "{0CCE924A-69AE-11D9-BED3-505054503030}"
    }
    "Logon/Logoff"       = [ordered] @{
        "Account Lockout"           = "{0CCE9217-69AE-11D9-BED3-505054503030}"
        "Group Membership"          = "{0CCE9249-69AE-11D9-BED3-505054503030}"
        "IPsec Extended Mode"       = "{0CCE921A-69AE-11D9-BED3-505054503030}"
        "IPsec Main Mode"           = "{0CCE9218-69AE-11D9-BED3-505054503030}"
        "IPsec Quick Mode"          = "{0CCE9219-69AE-11D9-BED3-505054503030}"
        "Logoff"                    = "{0CCE9216-69AE-11D9-BED3-505054503030}"
        "Logon"                     = "{0CCE9215-69AE-11D9-BED3-505054503030}"
        "Network Policy Server"     = "{0CCE9243-69AE-11D9-BED3-505054503030}"
        "Other Logon/Logoff Events" = "{0CCE921C-69AE-11D9-BED3-505054503030}"
        "Special Logon"             = "{0CCE921B-69AE-11D9-BED3-505054503030}"
        "User / Device Claims"      = "{0CCE9247-69AE-11D9-BED3-505054503030}"
    }
    "Object Access"      = [ordered] @{
        "Application Generated"          = "{0CCE9222-69AE-11D9-BED3-505054503030}"
        "Central Policy Staging"         = "{0CCE9246-69AE-11D9-BED3-505054503030}"
        "Certification Services"         = "{0CCE9221-69AE-11D9-BED3-505054503030}"
        "Detailed File Share"            = "{0CCE9244-69AE-11D9-BED3-505054503030}"
        "File Share"                     = "{0CCE9224-69AE-11D9-BED3-505054503030}"
        "File System"                    = "{0CCE921D-69AE-11D9-BED3-505054503030}"
        "Filtering Platform Connection"  = "{0CCE9226-69AE-11D9-BED3-505054503030}"
        "Filtering Platform Packet Drop" = "{0CCE9225-69AE-11D9-BED3-505054503030}"
        "Handle Manipulation"            = "{0CCE9223-69AE-11D9-BED3-505054503030}"
        "Kernel Object"                  = "{0CCE921F-69AE-11D9-BED3-505054503030}"
        "Other Object Access Events"     = "{0CCE9227-69AE-11D9-BED3-505054503030}"
        "Registry"                       = "{0CCE921E-69AE-11D9-BED3-505054503030}"
        "Removable Storage"              = "{0CCE9245-69AE-11D9-BED3-505054503030}"
        "SAM"                            = "{0CCE9220-69AE-11D9-BED3-505054503030}"
    }
    "Policy Change"      = [ordered] @{
        "Audit Policy Change"              = "{0CCE922F-69AE-11D9-BED3-505054503030}"
        "Authentication Policy Change"     = "{0CCE9230-69AE-11D9-BED3-505054503030}"
        "Authorization Policy Change"      = "{0CCE9231-69AE-11D9-BED3-505054503030}"
        "Filtering Platform Policy Change" = "{0CCE9233-69AE-11D9-BED3-505054503030}"
        "MPSSVC Rule-Level Policy Change"  = "{0CCE9232-69AE-11D9-BED3-505054503030}"
        "Other Policy Change Events"       = "{0CCE9234-69AE-11D9-BED3-505054503030}"
    }
    "Privilege Use"      = [ordered] @{
        "Non Sensitive Privilege Use" = "{0CCE9229-69AE-11D9-BED3-505054503030}"
        "Other Privilege Use Events"  = "{0CCE922A-69AE-11D9-BED3-505054503030}"
        "Sensitive Privilege Use"     = "{0CCE9228-69AE-11D9-BED3-505054503030}"
    }
    "System"             = [ordered] @{
        "IPsec Driver"              = "{0CCE9213-69AE-11D9-BED3-505054503030}"
        "Other System Events"       = "{0CCE9214-69AE-11D9-BED3-505054503030}"
        "Security State Change"     = "{0CCE9210-69AE-11D9-BED3-505054503030}"
        "Security System Extension" = "{0CCE9211-69AE-11D9-BED3-505054503030}"
        "System Integrity"          = "{0CCE9212-69AE-11D9-BED3-505054503030}"
    }
}  

Function Get-AuditPolicyCategoryDescription {
    param (
        [string] $Category
    )

    return $AuditCategoriesToDescriptions[$Category]
}

Function Get-AuditPolicyCategory {
    return $AuditCategoriesToSubcategoriesToGuids.Keys | % {$_.ToString()}
}

Function Get-AuditPolicySubCategory {
    param (
        [string] $Category
    )

    return $AuditCategoriesToSubcategoriesToGuids[$Category].Keys | % {$_.ToString()}
}

Function Get-AuditPolicySubCategoryGuid {
    param (
        [string] $Category,
        [string] $Subcategory
    )
    return $AuditCategoriesToSubcategoriesToGuids[$Category][$Subcategory].Value
}