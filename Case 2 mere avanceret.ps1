# Case 2 - Flere Servere
# Klient: 10.101.184.14
# Servere: 10.101.190.204, 10.101.3.197
$Servers = @("10.101.190.204","10.101.3.197")
$ServiceName = "Spooler"
$Cred = Get-Credential -UserName "Administrator" -Message "Indtast dit kodeord"

foreach ($Server in $Servers) {
    Invoke-Command -ComputerName $Server -Credential $Cred -ScriptBlock {
        param($svc)
        Stop-Service -Name $svc -Force
    } -ArgumentList $ServiceName
}