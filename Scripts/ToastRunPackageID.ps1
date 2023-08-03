$RegistryPath = "HKCU:\SOFTWARE\ToastNotificationScript"
$PackageID = (Get-ItemProperty -Path $RegistryPath -Name "RunPackageID").RunPackageID
$TestPackageID = Get-WmiObject -Namespace ROOT\ccm\ClientSDK -Query "SELECT * FROM CCM_Program where PackageID = '$PackageID'"
if (-NOT[string]::IsNullOrEmpty($TestPackageID)) {
    $ProgramID = $TestPackageID.ProgramID
    ([wmiclass]'ROOT\ccm\ClientSDK:CCM_ProgramsManager').ExecuteProgram($ProgramID,$PackageID)
    #if (Test-Path -Path "$env:windir\CCM\ClientUX\SCClient.exe") { Start-Process -FilePath "$env:windir\CCM\ClientUX\SCClient.exe" -ArgumentList "SoftwareCenter:Page=OSD" -WindowStyle Maximized }
}
exit 0
