function global:Get-LastLogon($User,$Format,$Server) {

    #set variables

    <#
        .SYNOPSIS
            List Last Logon of User defined.
        .LINK
            
    #>

    Write-Host -ForegroundColor Yellow "Getting last logon information for: "$User
    Write-Host $Server
    If ($Format -eq "YES"){$Format = $True}
    Write-Host $Format
    
    if($Format){$results = Get-ADUser $User -Properties LastLogonDate | fl LastLogonDate}
    elseif($Server){$results = Get-ADUser $User -Server $Server -Properties LastLogonDate}
    else{$results = Get-ADUser $User -Properties * | fl LastLogonDate}
    $results
}
function global:Get-PasswordLastSet($User,$Format) {
Import-Module ActiveDirectory

    #set variables

    <#
        .SYNOPSIS
            List Last time password was set for User defined.
        .LINK
            
    #>

    Write-Host -ForegroundColor Yellow "Looking for username: "$User
    Write-Host $Server
    If ($Format -eq "YES"){$Format = $True}
    try{
    
        $results = Get-ADUser $User -Properties PasswordLastSet,PasswordExpired
        if($Format){$results = Get-ADUser $User -Properties PasswordLastSet,PasswordExpired | fl PasswordLastSet,PasswordExpired}
        else{$results = Get-ADUser $User -Properties PasswordLastSet,PasswordExpired}
        $results    
    }
    catch{Write-Host -ForegroundColor Red "Failed to find user:" $User}
    
    
}
function global:Get-EmployeeID($User) {
    Import-Module ActiveDirectory
    Write-Host -ForegroundColor Yellow "Looking up information that matches User:"$User
    Get-ADUser -LDAPFilter "(SamAccountName=$User)" -Properties GivenName,Surname,EmployeeID | FL GivenName,Surname,EmployeeID

}
function global:Get-UserStatus($EmployeeID,$Unlock) {
    Import-Module ActiveDirectory
    Write-Host -ForegroundColor Yellow "Looking up information that matches ID#:"$EmployeeID

    $userAccount = Get-ADUser -LDAPFilter "(EmployeeID=$EmployeeID)" -Properties SamAccountName,GivenName,Surname,EmployeeID,LockedOut
    
    foreach($user in $userAccount){Write-Host -ForegroundColor Yellow "Found: " $user.SamAccountName}
   
    If($Unlock -eq "yes"){
        Write-Host -ForegroundColor Yellow "Attempting unlock on: " $userAccount[0].GivenName $userAccount[0].Surname
        Get-ADUser -LDAPFilter "(EmployeeID=$EmployeeID)" -Properties SamAccountName,GivenName,Surname,EmployeeID,LockedOut | Unlock-ADAccount
        if($userAccount[0].LockedOut -eq $false) {
            
            Write-Host -ForegroundColor Yellow $userAccount[0].SamAccountName "is unlocked"
        }
        
    }
    else{
    
        foreach($user in $userAccount){
            If($user.LockedOut -eq $false){$lockedStatus = "No"}
            else {$lockedStatus = "Yes"}
        
            Write-Host "-------------------------------------------------------"
            Write-Host -ForegroundColor Green "Username: " $user.SamAccountName
            Write-Host -ForegroundColor Green "Firstname: " $user.GivenName
            Write-Host -ForegroundColor Green "Lastname: " $user.Surname
            Write-Host -ForegroundColor Green "EmployeeID#: " $user.EmployeeID
            Write-Host -ForegroundColor Green "Is the account locked out?:" $lockedStatus
            
        }
        
    }
}
function global:Get-LAPSPassword($ComputerName){
    Import-Module ActiveDirectory
    Write-Host -ForegroundColor Yellow "Getting LAPS password for computer #:" $ComputerName
    $computer = Get-ADComputer -LDAPFilter "(Name=$ComputerName)" -Properties Name,ms-Mcs-AdmPwd,Enabled
    
    write-host -ForegroundColor Cyan "Computer Name:" $computer.Name
    Write-host -ForegroundColor Cyan "Is it enabled?" $computer.Enabled
    Write-host -ForegroundColor Green "LAPS Password is:" $computer.'ms-Mcs-AdmPwd'
}
function global:Reset-PasswordTime($UserName){
    try{
        Write-Host -ForegroundColor Yellow "Looking for username:" $UserName
        
        Set-ADUser -Identity $UserName -ChangePasswordAtLogon $true
        Write-Host -ForegroundColor Cyan "Change Password At Logon set to true..."

        Set-ADUser -Identity $UserName -ChangePasswordAtLogon $false
        Write-Host -ForegroundColor Cyan "Change Password At Logon set to false..."
        $passwordSet = Get-ADUser -Identity $UserName -Properties PasswordLastSet
        Write-Host "Password last set changed to:" $passwordSet.PasswordLastSet
    }
    catch{
        Write-Host -BackgroundColor Black -ForegroundColor Red "!!!-WARNING-!!!"
        Write-Host -BackgroundColor Black -ForegroundColor Red "Unable to find:" $UserName
        Write-Host -BackgroundColor Black -ForegroundColor Red "Did you even type it correctly?"
    }

}
Export-ModuleMember -Function Get-UserStatus
Export-ModuleMember -Function Get-EmployeeID
Export-ModuleMember -Function Get-PasswordLastSet
Export-ModuleMember -Function Get-LastLogon
Export-ModuleMember -Function Get-LAPSPassword
Export-ModuleMember -Function Reset-PasswordTime