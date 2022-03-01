function global:New-SharedMailbox($MailboxName,$User,$Identity,$List,$Domain,$Lastname){
    #Install-Module ExchangeOnlineManagement
    Import-Module ExchangeOnlineManagement

    $MailboxName = "$MailboxName$Domain"
    Write-Host "Script will create $MailboxName"
    Write-Host "------------------------"

    if ($Identity -eq $null){}
    else{Connect-ExchangeOnline -UserPrincipalName $Identity}

    Write-Host "Creating Mailbox..."
    New-Mailbox -DisplayName "$Lastname, $MailboxName" -LastName "CP" -FirstName $MailboxName -MicrosoftOnlineServicesID $MailboxName -Name $MailboxName -Verbose
    Write-Host "Mailbox Created..."
    Write-Host "------------------------"

    Write-Host "Gettting Mailbox..."

    Get-Mailbox -Identity $MailboxName -Verbose
    Write-Host "------------------------"

    timeout /t 3

    Write-Host "Setting to Shared..."

    Set-Mailbox -Identity $MailboxName -Type Shared -Verbose
    Write-Host "------------------------"

    Write-Host "Setting mailbox variable..."

    $mailbox = Get-Mailbox $MailboxName -Verbose
    Write-Host "------------------------"

    if($List -ne $Null){
        foreach ($person in $List){
        Add-MailboxPermission $MailboxName -User $person -AccessRights FullAccess
        Add-RecipientPermission $MailboxName -AccessRights SendAs -Trustee $person

        Write-Host "$person has been given FullAcess to $MailboxName" -ForegroundColor Green
        }
    }
    else
    {
        Write-Host " "
        Write-Host "Setting user permission on mailbox..."
        Add-MailboxPermission $MailboxName -User $User -AccessRights FullAccess
        Write-Host "------------------------"
    }

    Write-Host "Mailbox created: " $mailbox.Name
    if($mailbox.IsShared -eq "True"){
    Write-Host "Mailbox Type: Shared"

    }
}
