$Server  = "10.101.190.204"
$Cred    = Get-Credential "Administrator"
$CSVPath = "C:\Users\Mathias\Powershell\NewUsers.csv"
$Users   = Import-Csv $CSVPath

foreach ($User in $Users) {
    Invoke-Command -ComputerName $Server -Credential $Cred -ArgumentList $User -ScriptBlock {
        param($U)

        Import-Module ActiveDirectory
        $OU = "OU=TestUsers,DC=Mathias,DC=local"

        # Tjek om brugeren findes
        if (-not (Get-ADUser -Filter "SamAccountName -eq '$($U.SamAccountName)'" -ErrorAction SilentlyContinue)) {

            # Opret bruger
            New-ADUser -Name "$($U.GivenName) $($U.Surname)" `
                       -GivenName $U.GivenName `
                       -Surname $U.Surname `
                       -SamAccountName $U.SamAccountName `
                       -EmailAddress $U.Email `
                       -Path $OU `
                       -AccountPassword (ConvertTo-SecureString $U.TempPassword -AsPlainText -Force) `
                       -Enabled $true `
                       -ChangePasswordAtLogon $true

            Write-Host "Oprettet: $($U.SamAccountName)"
        }
        else {
            Write-Host "Findes allerede: $($U.SamAccountName)"
        }
    }
}
