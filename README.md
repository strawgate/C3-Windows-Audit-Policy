# C3-Windows-Audit-Policy

This repository contains the tools used to generate Audit Policy fixlets and analyses for Windows BigFix clients.

To download the generated Fixlets see the releases section here: https://github.com/strawgate/C3-Windows-Audit-Policy/releases

For every audit policy available four fixlets are generated:
* A fixlet that enables auditing of success
* A fixlet that disables auditing of success
* A fixlet that enables auditing of failure
* A fixlet that disables auditing of failure

For every audit policy available two analysis properties are generated:
* A property that checks whether success auditing is enabled
* A property that checks whether failure auditing is enabled
