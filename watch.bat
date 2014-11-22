@Echo Off
Set _Delay=1
Set _Monitor=%CD%
Set _Base=%temp%\BaselineState.dir
Set _Chck=%temp%\ChkState.dir
Set _OS=6
Ver|Findstr /I /C:"Version 5">Nul
If %Errorlevel%==0 Set _OS=5 & Set /A _Delay=_Delay*1000
:_StartMon
Call :_SetBaseline "%_Base%" "%_Monitor%"
:_MonLoop
If %_OS%==5 (Ping 1.0.0.0 -n 1 -w %_Delay%>Nul) Else Timeout %_Delay%>Nul
Call :_SetBaseline "%_Chck%" "%_Monitor%"
FC /A /L "%_Base%" "%_Chck%">Nul
If %ErrorLevel%==0 Goto _MonLoop
::
:: Insert code to run when a change occurs
::
Echo.Change Detected
Goto :_StartMon
:::::::::::::::::::::::::::::::::::::::::::::::::::
:: Subroutine
:::::::::::::::::::::::::::::::::::::::::::::::::::
:_SetBaseline
If Exist "%temp%\tempfmstate.dir" Del "%temp%\tempfmstate.dir"
For /F "Tokens=* Delims=" %%I In ('Dir /S "%~2"') Do (
Set _Last=%%I
>>"%temp%\tempfmstate.dir" Echo.%%I
)
>"%~1" Findstr /V /C:"%_Last%" "%temp%\tempfmstate.dir"
Goto :EOF