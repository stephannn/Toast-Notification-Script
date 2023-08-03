function Remove-ToastNotificationSnoozed() {
	$Load = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
	$Load = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

	$toastNotifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app)
	Write-Host "Deleting (existing) Toast Notifier for app $App"
	$toastNotifier.RemoveFromSchedule | Out-Null
	
	# Single object cannot be put into an array
	$scheduled = @($toastNotifier.getScheduledToastNotifications())

	if([bool](@($scheduled).Length -eq 0)){
		Write-Host "No existing hidden Toast Notifications have been found"
	} elseif([bool](@($scheduled).Length -ge 1)){
		
		Write-Log -Message "$(@($scheduled).Length) hidden Toast Notification(s) has been found"
		for ([int]$i = @($scheduled).Length -1; $i -ge 0 ; $i--) {
			$toastNotifier.removeFromSchedule($scheduled[$i]);
			Write-Host "Number $($i+1) of $(@($scheduled).Length) the Toast Notifications has been removed"
		}
	}
	
}

$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings"
$Apps =  @("{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe", "Toast.Custom.App")
$CounterName = "ToastCounter"

foreach($App in $Apps){
	Remove-ToastNotificationSnoozed
	Remove-ItemProperty -Path ("$RegPath\$App") -Name $CounterName -Force -ErrorAction SilentlyContinue
}

#Write-Host -NoNewLine 'Press any key to continue...';
#$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

$timeReboot = 60
#Start-Sleep -Seconds 30
Write-Host "Waiting $timeReboot seconds to reboot the system"
& shutdown /r /t $timeReboot /d p:0:0 /c "Waiting $timeReboot seconds to reboot the system"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Exit 0
