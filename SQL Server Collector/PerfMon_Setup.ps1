
Param(
[string]$Server = $env:ComputerName, #default to the current server. Can be a remote server.
[string]$InstanceName,               #Use if named instance is targeted.
[bool]$DCS_Update=0,                 #the Data Collectors Set will be Removed if exists, and new one will be created 
[bool]$Start=1 ,                     #the Data Collectors Set will be started 
[string]$DCSName = "SQLPerfMon"      #Name of Data Collector Set.
)



## Script starts here ##
Write-Host "Starting to create Perfmon-Collector to create / update Perfmon Data Collector Set $DCSName on $Server" -ForegroundColor Green

# DataCollectorSet Check and Creation
$DCS = New-Object -COM Pla.DataCollectorSet
 
# DataCollectorSet Check and Creation
$DCS = New-Object -COM Pla.DataCollectorSet

 
try # Check to see if the Data Collector Set exists
{
    $DCS.Query($DCSName,$Server)
   
    if ($DCS_Update -eq 1 ) #DCS is found 
    {
        if ($DCS.Status -ne 0)
        {
            $DCS.Stop($true)
            Write-Host 'Data Collector stopped' -ForegroundColor Yellow
        }
        $DCS.Delete()
        Write-Host "Data Collector set was found and removed" -ForegroundColor Yellow
    }
    else
    {
        Write-Host "Data Collector set was found on machine $Server. Update is NOT enabled from parameter list. Script exiting." -ForegroundColor Yellow
        return
    }
}
catch [System.Management.Automation.MethodInvocationException],[System.Runtime.InteropServices.COMException]
{
    Write-Host "Creating the $DCSName Data Collector Set" -ForegroundColor Green
    $DCS.DisplayName = $DCSName
    $DCS.Duration= 86400; # 1 day overall duration
    #$DCS.Segment = $true;
    $DCS.SegmentMaxDuration = 86400; # 1 day duration
    $DCS.SegmentMaxSize= 1024 # 1GB Size
    $DCS.SubdirectoryFormat = 1; # empty pattern, but use the $SubDir
    #$DCS.RootPath = $SubDir;
    $DCS.RootPath = "%systemdrive%\PerfLogs\Admin\SQL_Perfmon"
 
    try #Commit changes
    {
     #   CommitChanges $DCS $DCSName 0x0003
     #   $DCS.Query($DCSName,$Server) #refresh with updates.
    }
    catch
    {
        Write-Host "Exception caught: " $_.Exception -ForegroundColor Red
        return
    }
}



#DataCollector
$DCName = "$DCSName-Server";
$PathToCfg = ("\\" + $env:ComputerName + "\" + $PSScriptRoot + "\CounterList.xml") -replace ,":","$"
 
        Write-Host "Creating the $DCName Data Collector in the $DCSName Data Collector Set" -ForeGroundColor Green
        #CreateCollectorInstance $DCS $DCName $ReplaceString


     if ($InstanceName -ne '')
        {$ReplStr="MSSQL$" + $InstanceName + ":"
        $XML = (Get-Content $PathToCfg) -replace "SQLServer:", $ReplStr }
     else
       {$XML = (Get-Content $PathToCfg) 
     }

     $DC = $DCS.DataCollectors.CreateDataCollector(0)
     $DC.Name = "DataCollector01"
     $DC.FileName = $DCName + "_";
     $DC.FileNameFormat = 0x0001;
     $DC.FileNameFormatPattern = "yyyyMMddHHmm";
     $DC.SampleInterval = 10;
     $DC.LogFileFormat = 0x0001;
     $DC.SetXML($XML);
     $DCS.DataCollectors.Add($DC)


     #Let's commit everything together

     $DCS.Commit($DCSName,$Server,0x0003) | Out-Null
     $DCS.Query($DCSName,$Server) #refresh with updates.

     # Start the data collector set.
try {
     
    If (($DCS.Status -eq 0) -and ($Start -eq 1)) {
        $DCS.Start($true)
        Write-Host "Successfully created $DCSName  and started the collectors." -ForeGroundColor Green
        }
}
catch {
    Write-Host "Exception caught: " $_.Exception -ForegroundColor Red
    return
}



