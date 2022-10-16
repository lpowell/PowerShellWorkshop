param($Interface, [Switch]$help)
# Set up our parameters


# Global Error Handling
function GlobalOptions(){
    $global:ErrorActionPreference="SilentlyContinue"
}


# Main Function
function AdapterEnum(){

    # If interface is specified, only use that adapter
    if($interface){
        $Adapter = Get-CimInstance Win32_NetworkAdapterConfiguration | ? Description -match $interface
    }else{
        $Adapter = Get-CimInstance Win32_NetworkAdapterConfiguration
    }

    # For every adapter in the list
    foreach($x in $Adapter){
        Write-Host "<-----$x----->"

        # Format-Table with all the properties listed
        ft -InputObject $x -Property Description, IPAddress, IPSubnet, DefaultIPGatway, DNSHostNAme, DNSServerSearchOrder -AutoSize 
        Write-Host "<-----Writing Connections----->"

        # Try the connection
        try{

            # Set a connection variable and format the output
            $Connections = Get-NetTCPConnection -LocalAddress $x.IPAddress[0]
            ft -InputObject $Connections -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess -AutoSize

        # If there are no connections
        }catch{
            Write-Host "No Connections on $x"
            Write-Host
        }
    }
}

# Help Function
function HelpMenu(){
    Write-Host "NetworkExplorer by Liam Powell"
    Write-Host "A simple script to display connections on each adapter"
    Write-Host "USE:"
    Write-Host "    -Help"
    Write-Host "        Displays this menu"
    Write-Host "    -Interface"
    Write-Host "        Only list connections on specififed adapter"
    Write-Host
}

# Start script
if($help){
    HelpMenu
    exit
}
AdapterEnum