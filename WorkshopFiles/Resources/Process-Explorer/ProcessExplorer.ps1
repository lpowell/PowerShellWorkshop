param([switch]$Connect, $Name, [switch]$help)
# Create parameters for Network Connect and Process name

# Global error silencer
function GlobalOptions(){
    $global:ErrorActionPreference="SilentlyContinue"

}

# function to filter processes by name or network connection
function GetProcesses(){

    # Set ProcessList to all processes or the process specified 
    if($Name){
        $ProcessList = Get-Process | ? Name -eq $Name
    }else{
            $ProcessList = Get-Process
    }

    # Run the output and network functions for every function in the list
    foreach($x in $ProcessList){


        # If we're looking for network connections, we only want to print the processes that have connections
        if($Connect){
            $TestConn = Get-NetTCPConnection -OwningProcess $x.ID

            # Test to see if there is a connection
            if($TestConn){
                OutputProcesses($x)
                GetNetwork($x)
            }

            # If we aren't looking for a connection, we can print all the processes
        }else{
            OutputProcesses($x)
        }
    }
}

# Print the process information we're looking for 
function OutputProcesses($ProcessList){
    Write-Host "Name: " $ProcessList.Name
    Write-host "ID: " $ProcessList.ID
    Write-host "Path: " $ProcessList.Path
    Write-host "Start Time: " $ProcessList.StartTime
    Write-Host
}

# Get the network information for the process
function GetNetwork($ProcessList){

    # Try block to catch any unexpected errors
    try{
        $NetConnect = Get-NetTCPConnection | ? OwningProcess -eq $ProcessList.ID
        }catch{
            return
        }
        foreach($x in $NetConnect){
            OutputNetwork($X)
        }
}

# Print out the network information 
function OutputNetwork($NetworkList){
    Write-Host "State: " $NetworkList.State
    Write-Host "Local Address: " $NetworkList.LocalAddress
    Write-Host "Local Port: " $NetworkList.LocalPort
    Write-Host "Remote Address: " $NetworkList.RemoteAddress
    Write-Host "Remote Port: " $NetworkList.RemotePort
    Write-Host
}

# Help Menu
function HelpMenu(){
    Write-Host "ProcessExplorer by Liam Powell"
    Write-Host "A simple script to filter processes by name or network connection"
    Write-Host "USE:"
    Write-Host "    -Help"
    Write-Host "        Displays this menu"
    Write-Host "    -Name"
    Write-Host "        Specify a process name to search for"
    Write-Host "    -Connect"
    Write-Host "        List processes with network connections"
    Write-Host
}


# Start script

# If -help is used, display the help menu and quit
if($help){
    HelpMenu
    exit
}

# go to the GlobalOptions function and then go to the GetProcesses function
GlobalOptions
GetProcesses