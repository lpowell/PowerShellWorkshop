# FindHash is a simple script that searches the computer for a file matching a hash

# Parameters
param($Directory='C:\', $Algorithm, $Hash, [switch]$Help)

# Function to find hashes
function FindHash(){

    # Set paramters if they aren't set
    # This can be done in the parameter declaration as well
    #  param($Directory='C:\')
    # if(!$Directory){
    #     $Directory = "C:\"
    # }
    # if(!$Algorithm){
    #     $Algorithm = 'SHA256'
    # }
    # if(!$Hash){
    #     Write-Host "No hash provided"
    #     exit
    # }
    Write-Progress -Activity "Building file list"
    $Files = Get-ChildItem -Path $Directory -r
    foreach($x in $Files){
        Write-Progress -Activity "Hashing $x"
        $Result = Get-FileHash $x.FullName -Algorithm $Algorithm
        if($Result.Hash -eq $Hash){
            Write-Host "Found a match!" -ForegroundColor Red
            Echo $Result | ft * -AutoSize
        }

    }
}

function HelpMenu(){
    Write-Host "FindHash by Liam Powell"
    Write-Host "A simple script to scan a device for a file hash"
    Write-Host "USE:"
    Write-Host "    -Help"
    Write-Host "        Displays this menu"
    Write-Host "    -Directory"
    Write-Host "        Directory to start recursive search"
    Write-Host "        Defaults to C:\"
    Write-Host "    -Algorithm"
    Write-Host "        Hashing algorithm to use"
    Write-Host "        Defaults to SHA256"
    Write-Host "    -Hash"
    Write-Host "        Hash to search for"
    Write-Host
}

if($Help){
    HelpMenu
    exit
}
FindHash