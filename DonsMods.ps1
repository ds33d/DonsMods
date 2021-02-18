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
function global:Get-UserStatus($EmployeeID,$Unlock,$UserName,$ResetPasswordTime,$LastLogon,$PasswordLastSet) {
    Import-Module ActiveDirectory
    

    if($UserName){
        Write-Host "You entered:" -ForegroundColor Magenta $UserName
        Write-Host -ForegroundColor Yellow "Looking up information that matches Username:"$UserName
        $userAccount = Get-ADUser -LDAPFilter "(SamAccountName=$UserName)" -Properties SamAccountName,GivenName,Surname,EmployeeID,LockedOut,PasswordLastSet,PasswordExpired,LastLogonDate
        
        foreach($user in $userAccount){
            Write-Host -ForegroundColor Yellow "Found: " $user.SamAccountName
            Write-Host -ForegroundColor Yellow "With EmployeeID of:" $user.EmployeeID
            Write-Host "-------------------------------------------------------" 
        }
   
        if($PasswordLastSet -eq "yes"){
            Write-Host -ForegroundColor cyan "Password Last Set:" $userAccount.PasswordLastSet
            Write-Host -ForegroundColor cyan "Is Password Expired?:" $userAccount.PasswordExpired
            Write-Host "-------------------------------------------------------"
        }

        if($ResetPasswordTime -eq "yes"){
                Reset-PasswordTime -UserName $UserName
                Write-Host "-------------------------------------------------------"
         }

        if($LastLogon -eq "yes"){
            Write-Host -ForegroundColor cyan "Last Logon Date:" $userAccount.LastLogonDate
            Write-Host "-------------------------------------------------------"
        }
    
        if($Unlock -eq "yes"){
            Write-Host $userAccount
            Write-Host -ForegroundColor Yellow "Attempting unlock on: " $userAccount.GivenName $userAccount.Surname
            $userAccount | Unlock-ADAccount
            if($userAccount.LockedOut -eq $false) {
            
                Write-Host -ForegroundColor Yellow $userAccount.SamAccountName "is unlocked"
            }
            Write-Host "-------------------------------------------------------"
            continue
        
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
                continue
            }
        
        }


    
    
    }
    else{
        Write-Host $EmployeeID
        $userAccount = Get-ADUser -LDAPFilter "(EmployeeID=$EmployeeID)" -Properties SamAccountName,GivenName,Surname,EmployeeID,LockedOut
    
        foreach($user in $userAccount){Write-Host -ForegroundColor Yellow "Found: " $user.SamAccountName}
   
        If($Unlock -eq "yes"){
            foreach($user in $userAccount){
                Write-Host -ForegroundColor Yellow "Attempting unlock associate: " $user.GivenName $user.Surname
                Write-Host -ForegroundColor Yellow "Username:"$user.SamAccountName
                $userAccount | Unlock-ADAccount
                if($userAccount.LockedOut -eq $false) {
            
                    Write-Host -ForegroundColor Green $user.SamAccountName "is unlocked"
                }
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
}
function global:Get-LAPSPassword($ComputerName){
    Import-Module ActiveDirectory
    Write-Host -ForegroundColor Yellow "Getting LAPS password for computer #:" $ComputerName
    $computer = Get-ADComputer -LDAPFilter "(Name=$ComputerName)" -Properties Name,ms-Mcs-AdmPwd,Enabled
    
    write-host -ForegroundColor Cyan "Computer Name:" $computer.Name
    Write-host -ForegroundColor Cyan "Is it enabled?" $computer.Enabled
    Write-host -ForegroundColor Green "LAPS Password is:" $computer.'ms-Mcs-AdmPwd'
}
