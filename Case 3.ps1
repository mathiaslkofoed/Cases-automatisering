# Case 3
$Server     = "10.101.190.204"
$Cred       = Get-Credential "Administrator"
$SearchBase = "OU=TestUsers,DC=Mathias,DC=local"
$OutCsv     = "C:\ADUsers.csv"

Invoke-Command -ComputerName $Server -Credential $Cred -ScriptBlock {
    Import-Module ActiveDirectory
    Get-ADUser -SearchBase $using:SearchBase -Filter * -Properties GivenName,Surname,SamAccountName,WhenCreated,Enabled |
        Where-Object Enabled -eq $true |
        Select-Object GivenName,Surname,SamAccountName,WhenCreated |
        Sort-Object Surname,GivenName
} | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

Write-Host "Filen er gemt ved: $OutCsv"