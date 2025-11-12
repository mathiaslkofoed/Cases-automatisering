# Case 2
# Klient: 10.101.184.14
# Server: 10.101.190.204
# Stopper Spooler-service på serveren

Invoke-Command -ComputerName 10.101.190.204 -Credential Administrator -ScriptBlock {
    Stop-Service -Name "Spooler" -Force
}
