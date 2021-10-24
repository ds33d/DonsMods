
function Get-EmailAddress($UserName){
    Write-Host "Email Addresses:"
    Write-Host "-----------------------"
    $userAccount = Get-ADUser -LDAPFilter "(SamAccountName=$UserName)" -Properties proxyAddresses
    foreach($account in $userAccount.proxyAddresses){
        $account = $account -replace "smtp:"
        if ($account -like "*500*"){$null}
        else{Write-Host $account}
        
    }
}
