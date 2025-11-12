# Case 1 – Diskpladsrapport

$Servers = "10.101.190.204","10.101.3.197"
$Cred = Get-Credential "Administrator"

Invoke-Command -ComputerName $Servers -Credential $Cred -ScriptBlock {
    Get-PSDrive -PSProvider FileSystem |
        Select-Object @{n='Server';e={$env:COMPUTERNAME}},
                      Name,
                      @{n='FreeGB';e={[math]::Round($_.Free/1GB,2)}}
} | Export-Csv -Path "C:\DiskReport.csv" -NoTypeInformation


