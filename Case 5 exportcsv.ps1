$Server  = "10.101.190.204"
$Cred    = Get-Credential "Administrator"
$CSVPath = "C:\NewUsers.csv"
$Report  = "C:\UserImport_Report.csv"

$Users   = Import-Csv $CSVPath
$Results = @()

foreach ($User in $Users) {
    $Result = Invoke-Command -ComputerName $Server -Credential $Cred -ArgumentList $User -ScriptBlock {
        param($U)
        Import-Module ActiveDirectory
        $OU = "OU=TestUsers,DC=Mathias,DC=local"

        if (Get-ADUser -Filter "SamAccountName -eq '$($U.SamAccountName)'" -ErrorAction SilentlyContinue) {
            [PSCustomObject]@{ UserName = $U.SamAccountName; Status = "Findes allerede" }
        }
        else {
            New-ADUser -Name "$($U.GivenName) $($U.Surname)" `
                       -GivenName $U.GivenName `
                       -Surname $U.Surname `
                       -SamAccountName $U.SamAccountName `
                       -EmailAddress $U.Email `
                       -Path $OU `
                       -AccountPassword (ConvertTo-SecureString $U.TempPassword -AsPlainText -Force) `
                       -Enabled $true `
                       -ChangePasswordAtLogon $true
            [PSCustomObject]@{ UserName = $U.SamAccountName; Status = "Oprettet" }
        }
    }
    $Results += $Result
}

$Results | Export-Csv -Path $Report -NoTypeInformation -Encoding UTF8
Write-Host "Rapport gemt ved: $Report"
