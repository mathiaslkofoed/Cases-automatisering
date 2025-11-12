$Cred = Get-Credential "Administrator"
Invoke-Command -ComputerName 10.101.190.204 -Credential $Cred -ScriptBlock {
    Import-Module ActiveDirectory
    New-ADUser -Name "Math" -SamAccountName "Math" -Path "OU=TestUsers,DC=Mathias,DC=local" -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) -Enabled $true
}

#