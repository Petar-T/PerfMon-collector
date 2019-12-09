# PerfMon-collector
PowerShell script to create and collect configurable list of performance counters, extract it and PowerBI report to show collected data

![](https://github.com/Petar-T/PerfMon-collector/blob/master/Docs/CaptureMain.JPG)
## Usage

```python
run PerfMon_Setup.ps1
  #to create performance collector
run PerfMon_Fix_Header.ps1
  #to standardize header of file  
Open Perfmon_Dashboard.pbix and load file 
  #to analyze data
  
```

## Process description
```flow
st=>start: create collector 

op=>operation: collect data (few hrs)
cond=>condition: Successful Yes or No?
op2=>operation: extract file  
op3=>operation: adjust header  
e=>end: import  .pbix to PowerBI desktop and reload

st->op->cond
cond(yes)->op2
op2->op3
cond(no)->op
op3->e
```
## Detailed HowTo
Use the step by step instructions file  [instruction](https://github.com/Petar-T/PerfMon-collector/blob/master/Docs/User_Manual.docx) 

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.
