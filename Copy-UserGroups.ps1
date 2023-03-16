# Define a PowerShell function called "Copy-UserGroups" that takes two parameters: $CopyUser and $DestinationUser.
function Copy-UserGroups($CopyUser,$DestinationUser){
    # Retrieve the group membership of the source user account using the Get-ADUser cmdlet.
    # The "-Properties MemberOf" parameter specifies that only the "MemberOf" property should be retrieved.
    $groups = Get-ADUser -Identity $CopyUser -Properties MemberOf
    
    # Extract the list of group names from the "MemberOf" property and save it in the $userGroups variable.
    $userGroups = $groups.MemberOf
    
    # Display a message to the console indicating the list of groups that will be copied.
    Write-Host "Groups to be copied"
    
    # Iterate through each group in $userGroups and add the destination user to that group.
    foreach($group in $userGroups){
        # Construct a search filter based on the distinguished name (DN) of the current group.
        $dn = '(distinguishedName=' + $group + ')'
        
        # Use the Get-ADGroup cmdlet to retrieve the group object that matches the search filter.
        # The "-LDAPFilter" parameter specifies that an LDAP query filter should be used instead of a simple string search.
        Get-ADGroup -LDAPFilter $dn | ForEach-Object {
            # Display the name of the group to the console.
            $_.name
            
            # Use the Add-ADGroupMember cmdlet to add the destination user to the current group.
            # The "-Identity" parameter specifies the group to add the user to, and the "-Members" parameter specifies the user to add.
            # The "-Verbose" parameter specifies that a detailed log of the operation should be displayed to the console.
            Add-ADGroupMember -Identity $_.name -Members $DestinationUser -Verbose
        }
    }
}
