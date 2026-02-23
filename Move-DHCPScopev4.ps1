<#
.SYNOPSIS
  Migrates a DHCP scope from a source server to a destination server, including options and reservations.

.DESCRIPTION
  This function moves a complete DHCPv4 scope configuration from one server to another.
  It copies the scope definition, all scope options, and all reservations.
  It also allows for explicitly setting the DNS servers (Option 6) on the new scope during migration.

.PARAMETER SourceDHCPServer
  The IP address or hostname of the source DHCP server.

.PARAMETER DestinationDHCPServer
  The IP address or hostname of the destination DHCP server.

.PARAMETER ScopeID
  The Scope ID of the DHCP scope to migrate (e.g., "192.168.1.0").

.PARAMETER DNS
  An array of strings representing the new DNS server IP addresses to set for the migrated scope.

.EXAMPLE
  Move-DHCPScopev4 -SourceDHCPServer '10.0.0.1' -DestinationDHCPServer '10.0.1.1' -ScopeID '192.168.100.0' -DNS '10.0.1.5', '8.8.8.8' -Verbose
#>
function Move-DHCPScopev4 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourceDHCPServer,

        [Parameter(Mandatory = $true)]
        [string]$DestinationDHCPServer,

        [Parameter(Mandatory = $true)]
        [string]$ScopeID,

        [Parameter(Mandatory = $true)]
        [string[]]$DNS
    )

    # Get the dhcp scope from the old server and create it on the new server
    Write-Verbose "Migrating Scope $ScopeID from $SourceDHCPServer to $DestinationDHCPServer"
    Get-DhcpServerv4Scope -ScopeId $ScopeID -ComputerName $SourceDHCPServer | Add-DhcpServerv4Scope -ComputerName $DestinationDHCPServer -Verbose

    # Loop through the scope options and copy them
    Write-Verbose "Copying Scope Options..."
    $dhcpOptions = Get-DhcpServerv4OptionValue -ComputerName $SourceDHCPServer -ScopeId $ScopeID
    foreach ($option in $dhcpOptions) {
        Set-DhcpServerv4OptionValue -ComputerName $DestinationDHCPServer -OptionId ($option).OptionId -Value ($option).Value -ScopeId $ScopeID -Verbose
    }

    # Set the new DNS Servers (Option 6), overwriting whatever was copied
    Write-Verbose "Updating DNS Servers to: $($DNS -join ', ')"
    Set-DhcpServerv4OptionValue -OptionId 6 -ScopeId $ScopeID -ComputerName $DestinationDHCPServer -Value $DNS -Verbose

    # Copy Reservations
    Write-Verbose "Copying Reservations..."
    Get-DhcpServerv4Reservation -ComputerName $SourceDHCPServer -ScopeId $ScopeID | ForEach-Object {
        Add-DhcpServerv4Reservation -ComputerName $DestinationDHCPServer -IPAddress $_.IPAddress -Description $_.Description -Name $_.Name -ClientId $_.ClientId -ScopeId $_.ScopeId -Verbose
    }
}
