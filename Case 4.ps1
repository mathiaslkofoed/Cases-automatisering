$Server = "10.101.190.204"
$Cred   = Get-Credential "Administrator"

Invoke-Command -ComputerName $Server -Credential $Cred -ScriptBlock {
    $os  = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    $ram = Get-CimInstance Win32_ComputerSystem

    $rapport = [PSCustomObject]@{
        Server = $env:COMPUTERNAME
        OS     = $os.Caption
        CPU    = $cpu.Name
        RAM_GB = [math]::Round($ram.TotalPhysicalMemory / 1GB, 2)
    }

    $rapport
} | Export-Csv -Path "C:\SystemReport.csv" -NoTypeInformation

Write-Host "Rapport gemt på C:\SystemReport.csv"


