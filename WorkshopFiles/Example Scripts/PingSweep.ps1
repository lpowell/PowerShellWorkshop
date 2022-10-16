# PingSweep is a simple script that will accept an address and ping sweep the subnet

# Accept an address and a switch for a help menu
param($Address, [switch]$Help)

# Global Options function
function GlobalOptions(){
    $global:ErrorActionPreference="SilentlyContinue"
}

# Main function to conduct the sweep
function PingSweep(){
    # Try to run the script using Get-Subnet
    try{
        $Subnet = Get-Subnet $Address
        Write-Host "Address     ResponseTime"

        # Loop through each HostAddress and write the results
        foreach($x in $Subnet.HostAddresses){
            Write-Progress -Activity "Scanning $x"
            $Result = Test-Connection $x -count 1 
            if($Result){
                Write-Host $Result.Address"    "$Result.ResponseTime
            }
        }
    # If Get-Subnet is not installed, install it and relaunch the script
    }catch{
        Write-Host "Installing Dependencies"
        Install-Module Subnet -Scope CurrentUser
        & $PSCommandPath -Address $Address
        exit
    }

}

# Help Menu
function HelpMenu(){
    Write-Host "PingSweep by Liam Powell"
    Write-Host "A simple script to scan a network"
    Write-Host "USE:"
    Write-Host "    -Help"
    Write-Host "        Displays this menu"
    Write-Host "    -Address"
    Write-Host "        PingSweep will guess your subnet if you do not use CIDR notation"
    Write-Host
    Write-Host "Special thanks to the author of the Subnet Module for making this very easy"
}

# Start PingSweep function
if($help){
    HelpMenu
    exit
}
# GlobalOptions
PingSweep