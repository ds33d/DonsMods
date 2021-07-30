function Get-ComputerTemperature ($ComputerName){
    Write-Host "Testing if terminal can be pinged..." -ForegroundColor Yellow
    if(Test-Connection -ComputerName $ComputerName){
        Write-Host "$ComputerName is up" -ForegroundColor Green
    }

    $temperatures = ""
    $Fahrenheit = ""
    $temperatures = Get-WmiObject -ComputerName $ComputerName MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" | Select-Object -Property InstanceName,CurrentTemperature
    foreach ($temp in $temperatures){
        $Fahrenheit = [math]::round((9/5) * ($temp.CurrentTemperature / 10 - 273.15) + 32)
        $temp.InstanceName
        Write-host "Current Temperature: $Fahrenheit F"
        Write-Host "----------------------------------"
    }
}