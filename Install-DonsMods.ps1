function global:Install-DonsMods{
    cd $psscriptroot
    Remove-Item -Path "C:\Program Files\WindowsPowerShell\Modules\DonsMods\DonsMods.psm1"
    Copy-Item -Force ".\DonsMods.psm1" -Destination "C:\Program Files\WindowsPowerShell\Modules\DonsMods\"

}

Install-DonsMods
cd C:\