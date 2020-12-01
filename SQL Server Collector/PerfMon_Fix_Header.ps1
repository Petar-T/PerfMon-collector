$fldr=$PSScriptRoot
$FirstColValue="Date_Time"
$DefInst="SQLServer"
$MakeFileZip=1
$DeleteSourceCopy=1

$FileName =$fldr + "\SQLPerfMon-Server_202011301406.tsv"
$NewFileName =$fldr + "\PerfMon_SourceData.csv"
$BackupFileName =$fldr + "\TsvCopy.zip"

if ($MakeFileZip -eq 1)
  {
  if (-not (test-path $BackupFileName))
    {$opts = @{'Path' = $FileName; 'DestinationPath' = $BackupFileName }}
  else
    {$opts = @{'Path' = $FileName; 'DestinationPath' = $BackupFileName; 'Confirm'=$true ; 'Update'=$true  }}

    Compress-Archive @opts
   }
    

$HeaderRow = Get-Content $FileName -First 1
$Split1=$HeaderRow|%{$_.split('"')[1]}
$Split2=$HeaderRow|%{$_.split('"')[3]}
$Split3=$Split2|%{$_.split('\\')[2]}
$Split4=$Split2.Substring($Split3.Length+3).Split(':')[0]


Write-Host  'Changing column name' [$Split1] 'to' [$FirstColValue] -ForegroundColor Green
$NewFile=(Get-Content $FileName).Replace( $Split1 , $FirstColValue)

if ($Split4 -ne $DefInst)
{
    $NewFile=$NewFile.Replace( $Split4 , $DefInst)
    Write-Host 'Named instance found: ' $Split4 -ForegroundColor Green
    Write-Host  'standardizing column name' $Split2 -ForegroundColor Green
}
else
{
    Write-Host 'Default instance found: ' $Split4 -ForegroundColor Green
}

Set-Content -Path $NewFileName -Value  $NewFile -Force
if ($DeleteSourceCopy -eq 1) 
    {
        Remove-Item –path $FileName 
        Write-Host 'Original file deleted' -ForegroundColor Green
    }
