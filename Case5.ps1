$Server   = "10.101.190.204"
$Cred     = Get-Credential "Administrator"
$CSVPath  = "C:\Users\Mathias\Powershell\NewUsers.csv"
$Users = Import-Csv -Path $CSVPath

foreach ($U in $Users) {
    Write-Host "== $($U.SamAccountName) ==" 

    Invoke-Command -ComputerName $Server -Credential $Cred -ScriptBlock {
        param($U)

        Import-Module ActiveDirectory
        $ErrorActionPreference = 'Stop'
        $OUPath = "OU=TestUsers,DC=Mathias,DC=local"

        # Dette tjekker om brugeren findes
        $exists = Get-ADUser -Filter "SamAccountName -eq '$($U.SamAccountName)'" -ErrorAction SilentlyContinue
        if ($exists) {
            Write-Output "EXISTS: $($exists.DistinguishedName)"
            return
        }

        # Dette opretter brugeren
        New-ADUser `
            -Name "$($U.GivenName) $($U.Surname)" `
            -GivenName $U.GivenName `
            -Surname $U.Surname `
            -SamAccountName $U.SamAccountName `
            -EmailAddress $U.Email `
            -Path $OUPath `
            -AccountPassword (ConvertTo-SecureString $U.TempPassword -AsPlainText -Force) `
            -Enabled $true `
            -ChangePasswordAtLogon $true

        # Dette beskræfter oprettelsen
        $new = Get-ADUser -Identity $U.SamAccountName -ErrorAction Stop
        Write-Output "CREATED: $($new.DistinguishedName)"

    } -ArgumentList $U
}
