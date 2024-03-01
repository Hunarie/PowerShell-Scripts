Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn # Exchange management shell

$userChoice = Read-Host -Prompt "Edit ContentFilterConfig (1) or SenderIDConfig (2)?";

try {
    if ($userChoice -eq 1) {
        $domainArray = (Get-ContentFilterConfig).BypassedSenderDomains.Domain # Create array of current domains and conver to list
        $domainList = New-Object System.Collections.Generic.List[System.Object]
        foreach ($domain in $domainArray) {
            $domainList.Add($domain)
        }

        $userStillAddingDomain = $true 
        while ($userStillAddingDomain) {
            $domainName = Read-Host -Prompt "(Hit enter when done) Domain name: "

            $doesDomainNameExist = $false # Set to false until domain is proven to exist
            try {
                Resolve-DnsName -Type mx -Name $domainName -ErrorAction Stop # ErrorAction set to stop to force catch if domain does not resolve an MX record
                $doesDomainNameExist = $true
            } catch {
                $doesDomainNameExist = $false
            }

            if ($domainList.Contains($domainName)) {
                "Domain name already in list"
            } elseif ($domainName -and $doesDomainNameExist -eq $true) {
                $domainList.Add($domainName)
            } elseif ($domainName -and $doesDomainNameExist -eq $false) {
                "Invalid domain name"
            } elseif ($domainList.Contains($domainName)) {
                "Domain name already in list"
            } else {
                $userStillAddingDomain = $false
            }
        }
        $domainList | out-file -filepath C:\contentfilterconfigNEW.txt
        Set-ContentFilterConfig -BypassedSenderDomains $domainList
        (Get-ContentFilterConfig).BypassedSenderDomains.Domain
    }
    if ($userChoice -eq 2) {
        $domainArray = (Get-SenderIDConfig).BypassedSenderDomains.Domain # Create array of current domains and conver to list
        $domainList = New-Object System.Collections.Generic.List[System.Object]
        foreach ($domain in $domainArray) {
            $domainList.Add($domain)
        }

        $userStillAddingDomain = $true 
        while ($userStillAddingDomain) {
            $domainName = Read-Host -Prompt "(Hit enter when done) Domain name: "

            $doesDomainNameExist = $false # Set to false until domain is proven to exist
            try {
                Resolve-DnsName -Type mx -Name $domainName -ErrorAction Stop # ErrorAction set to stop to force catch if domain does not resolve an MX record
                $doesDomainNameExist = $true
            } catch {
                $doesDomainNameExist = $false
            }

            if ($domainList.Contains($domainName)) {
                "Domain name already in list"
            } elseif ($domainName -and $doesDomainNameExist -eq $true) {
                $domainList.Add($domainName)
            } elseif ($domainName -and $doesDomainNameExist -eq $false) {
                "Invalid domain name"
            } elseif ($domainList.Contains($domainName)) {
                "Domain name already in list"
            } else {
                $userStillAddingDomain = $false
            }
        }
        $domainList | out-file -filepath C:\senderidconfigNEW.txt
        Set-SenderIDConfig -BypassedSenderDomains $domainList
        (Get-SenderIDConfig).BypassedSenderDomains.Domain
    }
} catch {
    "An error occured that could not be resolved"
    Write-Output $_
}

Read-Host "Hit enter to exit..."