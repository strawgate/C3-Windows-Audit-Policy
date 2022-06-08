
Function Get-isWindowsRelevance {
    return "Windows of Operating System"
}

Function Get-AuditPolicyExistsRelevance {
    return "exists Audit Policy"
}

Function Get-AuditPolicyCategoryExistsRelevance {
    param (
        [string] $Category
    )
    return "exists categories whose (name of it = ""$Category"") of audit policy"
}

Function Get-AuditPolicySubCategoryExistsRelevance {
    param (
        [string] $SubCategory
    )
    return "exists subcategories whose (name of it = ""$Subcategory"") of categories of audit policy"
}

Function Get-AuditPolicySubCategoryCheckRelevance {
    param (
        [string] $Category,
        [string] $Subcategory,
        [string] $Type
    )
    return "audit $($Type.ToLowerInvariant()) of system policy of subcategories whose (name of it = ""$SubCategory"") of categories whose (name of it = ""$Category"") of audit policy"
}
