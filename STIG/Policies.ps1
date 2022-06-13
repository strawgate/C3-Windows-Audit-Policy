$STIGs = @{
    "Windows Server 2012" = @{
        "Success Policies" = "Credential Validation", "Other Account Management Events", "Security Group Management", "User Account Management", "Directory Service Access", "Directory Service Changes", "Process Creation", "Account Lockout", "Logoff", "Logon", "Special Logon", "Removable Storage", "Audit Policy Change", "Authentication Policy Change", "Authorization Policy Change", "Sensitive Privilege Use", "IPsec Driver", "Other System Events", "Security State Change", "Security System Extension", "System Integrity"
        "Failure Policies" = "Account Lockout", "Audit Policy Change", "Credential Validation", "Directory Service Access", "Directory Service Changes", "IPsec Driver", "Logon", "Other System Events", "Removable Storage", "Sensitive Privilege Use", "System Integrity", "User Account Management"
        "Baseline"         = "Microsoft Windows Server 2012/2012 R2 Member Server Security Technical Implementation Guide Version: 3 Release: 2 Benchmark Date: 04 May 2021"
        "Relevance"        = "Name of Operating System = ""Win2012"""
    }
    "Windows Server 2012r2" = @{
        "Success Policies" = "Credential Validation", "Other Account Management Events", "Security Group Management", "User Account Management", "Directory Service Access", "Directory Service Changes", "Process Creation", "Account Lockout", "Logoff", "Logon", "Special Logon", "Removable Storage", "Audit Policy Change", "Authentication Policy Change", "Authorization Policy Change", "Sensitive Privilege Use", "IPsec Driver", "Other System Events", "Security State Change", "Security System Extension", "System Integrity"
        "Failure Policies" = "Account Lockout", "Audit Policy Change", "Credential Validation", "Directory Service Access", "Directory Service Changes", "IPsec Driver", "Logon", "Other System Events", "Removable Storage", "Sensitive Privilege Use", "System Integrity", "User Account Management"
        "Baseline"         = "Microsoft Windows Server 2012/2012 R2 Member Server Security Technical Implementation Guide Version: 3 Release: 2 Benchmark Date: 04 May 2021"
        "Relevance"        = "Name of Operating System = ""Win2012r2"""
    }
    "Windows Server 2016"   = @{
        "Success Policies" = "Credential Validation", "Computer Account Management", "Other Account Management Events", "Security Group Management", "User Account Management", "Directory Service Access", "Directory Service Changes", "Plug and Play Events", "Process Creation", "Account Lockout", "Group Membership", "Logoff", "Logon", "Special Logon", "Other Object Access Events", "Removable Storage", "Audit Policy Change", "Authentication Policy Change", "Authorization Policy Change", "Sensitive Privilege Use", "IPsec Driver", "Other System Events", "Security State Change", "Security System Extension", "System Integrity"
        "Failure Policies" = "Account Lockout", "Audit Policy Change", "Credential Validation", "Directory Service Access", "Directory Service Changes", "IPsec Driver", "Logon", "Other Object Access Events", "Other System Events", "Removable Storage", "Sensitive Privilege Use", "System Integrity", "User Account Management"
        "Baseline"         = "Microsoft Windows Server 2019 Security Technical Implementation Guide Version: 2 Release: 2 Benchmark Date: 04 May 2021"
        "Relevance"        = "Name of Operating System = ""Win2016"""
    }
    "Windows Server 2019"   = @{
        "Success Policies" = "Credential Validation", "Computer Account Management", "Other Account Management Events", "Security Group Management", "User Account Management", "Directory Service Access", "Directory Service Changes", "Plug and Play Events", "Process Creation", "Account Lockout", "Group Membership", "Logoff", "Logon", "Special Logon", "Other Object Access Events", "Removable Storage", "Audit Policy Change", "Authentication Policy Change", "Authorization Policy Change", "Sensitive Privilege Use", "IPsec Driver", "Other System Events", "Security State Change", "Security System Extension", "System Integrity"
        "Failure Policies" = "Account Lockout", "Audit Policy Change", "Credential Validation", "Directory Service Access", "Directory Service Changes", "IPsec Driver", "Logon", "Other Object Access Events", "Other System Events", "Removable Storage", "Sensitive Privilege Use", "System Integrity", "User Account Management"
        "Baseline"         = "Microsoft Windows Server 2019 Security Technical Implementation Guide Version: 2 Release: 2 Benchmark Date: 04 May 2021"
        "Relevance"        = "Name of Operating System = ""Win2019"""
    }
    "Windows Server 2022"   = @{
        "Success Policies" = "Credential Validation", "Computer Account Management", "Other Account Management Events", "Security Group Management", "User Account Management", "Directory Service Access", "Directory Service Changes", "Plug and Play Events", "Process Creation", "Account Lockout", "Group Membership", "Logoff", "Logon", "Special Logon", "Other Object Access Events", "Removable Storage", "Audit Policy Change", "Authentication Policy Change", "Authorization Policy Change", "Sensitive Privilege Use", "IPsec Driver", "Other System Events", "Security State Change", "Security System Extension", "System Integrity"
        "Failure Policies" = "Account Lockout", "Audit Policy Change", "Credential Validation", "Directory Service Access", "Directory Service Changes", "IPsec Driver", "Logon", "Other Object Access Events", "Other System Events", "Removable Storage", "Sensitive Privilege Use", "System Integrity", "User Account Management"
        "Baseline"         = "Microsoft Windows Server 2019 Security Technical Implementation Guide Version: 2 Release: 2 Benchmark Date: 04 May 2021"
        "Relevance"        = "Name of Operating System = ""Win2022"""
    }
    "Windows 10"            = @{
        "Failure Policies" = "Credential Validation", "User Account Management", "Account Lockout", "Logon", "File Share", "Other Object Access Events", "Removable Storage", "Sensitive Privilege Use", "IPsec Driver", "Other System Events", "System Integrity"
        "Success Policies" = "Credential Validation", "Computer Account Management", "Other Account Management Events", "Security Group Management", "User Account Management", "Process Creation", "Group Membership", "Logoff", "Logon", "Special Logon", "File Share", "Other Object Access Events", "Removable Storage", "Audit Policy Change", "Authentication Policy Change", "Authorization Policy Change", "Sensitive Privilege Use", "IPsec Driver", "Other System Events", "Security State Change", "Security System Extension", "System Integrity"
        "Baseline"         = "Windows 10 Security Technical Implementation Guide Version: 2 Release: 2 Benchmark Date: 04 May 2021"
        "Relevance"        = "Name of Operating System = ""Win10"""
    }
    "Windows 11"            = @{
        "Failure Policies" = "Credential Validation", "User Account Management", "Account Lockout", "Logon", "File Share", "Other Object Access Events", "Removable Storage", "Sensitive Privilege Use", "IPsec Driver", "Other System Events", "System Integrity"
        "Success Policies" = "Credential Validation", "Computer Account Management", "Other Account Management Events", "Security Group Management", "User Account Management", "Process Creation", "Group Membership", "Logoff", "Logon", "Special Logon", "File Share", "Other Object Access Events", "Removable Storage", "Audit Policy Change", "Authentication Policy Change", "Authorization Policy Change", "Sensitive Privilege Use", "IPsec Driver", "Other System Events", "Security State Change", "Security System Extension", "System Integrity"
        "Baseline"         = "Windows 10 Security Technical Implementation Guide Version: 2 Release: 2 Benchmark Date: 04 May 2021"
        "Relevance"        = "Name of Operating System = ""Win11"""
    }
}
