function global:Install-DonsMods{
    $Path = "$PSScriptRoot\DonsMods.psm1"
    $env:USERPROFILE
    Write-Host "Path entered:" $path
    $pathTest = Test-Path -Path $path
    If ($pathTest -eq $false){
        Write-Host "Unable to fnd DonsMods.psm1"
        break    
    }

    Write-Host $path
    $modPath = Test-Path -Path "C:\Program Files\WindowsPowerShell\Modules\DonsMods"
    If(Test-Path -Path "C:\Program Files\WindowsPowerShell\Modules\DonsMods\DonsMods.psm1"){
        Remove-Item -Path "C:\Program Files\WindowsPowerShell\Modules\DonsMods\DonsMods.psm1" -Verbose
    }
    
    if((Test-Path -Path "C:\Program Files\WindowsPowerShell\Modules\DonsMods") -eq $false){
        New-Item -ItemType Directory -Path "C:\Program Files\WindowsPowerShell\Modules\DonsModss\DonsMods" -Force
        Copy-Item -Force $path -Destination "C:\Program Files\WindowsPowerShell\Modules\DonsMods\DonsMods.psm1" -Verbose
    }
    else{Copy-Item -Force $path -Destination "C:\Program Files\WindowsPowerShell\Modules\DonsMods\DonsMods.psm1" -Verbose}

    if((Test-Path -Path "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\DonsMods") -eq $false){
        New-Item -ItemType Directory -Path "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\DonsMods" -Force
        Copy-Item -Force $path -Destination "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\DonMods\DonsMods.psm1" -Verbose
    }
    else{Copy-Item -Force $path -Destination "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\DonMods" -Verbose}

    if((Test-Path -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\DonsMods") -eq $false){
        New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\DonsMods" -Force
        Copy-Item -Force $path -Destination "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\DonsMods\" -Verbose
    }
    else {Copy-Item -Force $path -Destination "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\DonsMods\" -Verbose}

    Get-Module -Name DonsMods -ListAvailable
}

Install-DonsMods
cd $PSScriptRoot
