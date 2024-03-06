$keyPath = "HKCU:\SOFTWARE\Microsoft\OneDrive\Accounts\Business1"
$propertyName = "Timerautomount" # Name of QWord that we are looking for

try {
    # Gets current value of Timerautomount registry key property, silently continue to allow creation of key if it does not exist instead of erroring out
    $registry = Get-ItemProperty -Path $keyPath -Name $propertyName -ErrorAction SilentlyContinue

    # Checks if registry key property already exists
    if($registry.Timerautomount -eq 1) {
        Write-Host "Timerautomount already set to 1"
    } elseif($registry.Timerautomount -eq 0) {
        # If the registry key property exists but is set to 0 then set it to 1
        Write-Host "Timerautomount exists but is set to 0, setting it to 1..."
        Set-ItemProperty -Path $keyPath -Name "Timerautomount" -Value 1
    }
    else {
        # If the registry key property does not exist, create it and set it to 1
        Write-Host "Timerautomount does not exist, creating it now..."
        New-ItemProperty -Path $keyPath -Name "Timerautomount" -Value 1 -PropertyType QWord
    }
} catch {
    # Throw error
    $_
}