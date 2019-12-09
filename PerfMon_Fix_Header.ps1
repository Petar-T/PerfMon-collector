$FileName =$PSScriptRoot + "\SQLPerfMon-Server_201912021442.csv"
$NewFileName =$PSScriptRoot + "\PerfMon_SourceData.csv"
$BackupFileName =$PSScriptRoot + "\TsvCopy.zip"
$FirsColValue="Date_Time"


if (-not (test-path $BackupFileName))
  {$opts = @{'Path' = $FileName; 'DestinationPath' = $BackupFileName }}
else
  {$opts = @{'Path' = $FileName; 'DestinationPath' = $BackupFileName; 'Confirm'=$true ; 'Update'=$true  }}


 Compress-Archive @opts


$HeaderRow = Get-Content $FileName -First 1
$Split1=$HeaderRow|%{$_.split('"')[1]}
$Split2=$HeaderRow|%{$_.split('"')[3]}
$Split3=$Split2|%{$_.split('\\')[2]}

#$Split1


#$NewFile=(Get-Content $FileName).Replace( $Split1 , '(PDH-TSV 4.0) (Coordinated Universal Time)(0)').Replace($Split3, 'SQL2019') 
$NewFile=(Get-Content $FileName).Replace( $Split1 , $FirsColValue)
#Set-Content -Path $FileName -Value  $NewFile -Force
Set-Content -Path $NewFileName -Value  $NewFile -Force
