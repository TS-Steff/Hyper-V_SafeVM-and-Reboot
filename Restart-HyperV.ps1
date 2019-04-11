#https://4sysops.com/archives/trycatchfinally-blocks-in-powershell-for-better-error-handling/

###
# start config
###

$hosts = @("SRV008","SRV006","SRV-02","SRV-01","W10VM-01")
$waitSecondsForReboot = 30

###
# End Config
###

write-host "                             " -ForegroundColor white -BackgroundColor DarkGreen
write-host " ########################### " -ForegroundColor white -BackgroundColor DarkGreen
write-host " # VM Speichern vor reboot # " -ForegroundColor white -BackgroundColor DarkGreen
write-host " ########################### " -ForegroundColor white -BackgroundColor DarkGreen
write-host "                             " -ForegroundColor white -BackgroundColor DarkGreen
write-host ""


foreach ($hostname in $hosts){
    
    Try{
        ## Do stuff here
        write-host " Save VM: $hostname " -ForegroundColor White -BackgroundColor DarkGreen
        Save-VM -name $hostname -ErrorAction Stop
        

    } catch {
        write-host ""
        Write-Warning -Message "Faild to save VM: $hostname"
        exit
    }
}
write-host ""
write-host "                            " -ForegroundColor white -BackgroundColor DarkGray
write-host " ALL DONE - Ready to reboot " -ForegroundColor white -BackgroundColor DarkGray
write-host "                            " -ForegroundColor white -BackgroundColor DarkGray

$Start = Get-Date
$Duration = New-TimeSpan -Seconds $waitSecondsForReboot
$End = $Start + $Duration
Do{
    Start-Sleep -Seconds 1
    $DisplayTime = New-TimeSpan -Start $(Get-Date) -End $End
    $Time = "{0:D2}:{1:D2}" -f ($DisplayTime.Minutes),  ($DisplayTime.Seconds)
    Write-Progress -Activity "Wait for reboot" $Time 
}
While((Get-date) -lt $End)

Restart-computer
