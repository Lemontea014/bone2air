@echo off

set BAT_DIR=%~dp0
set CONFIG_PATH=%BAT_DIR%..\..\settings\setting.config
for %%F in ("%CONFIG_PATH%") do set CONFIG_PATH=%%~fF

for /f "tokens=2 delims==" %%A in ('findstr /R "^MATLAB_CMD=" "%CONFIG_PATH%"') do set MATLAB_CMD=%%A
echo CONFIG_PATH=%CONFIG_PATH%
echo MATLAB_CMD=%MATLAB_CMD%
:: example run.bat
if "%1"=="" (
    echo Running load_dataset and synthesis scripts...
    %MATLAB_CMD% -nosplash -nodesktop -r "try, load_dataset; synthesis_knn; disp('Press any key to exit...'); pause; catch ME, disp(ME.message); end; exit"
    echo ok.
    pause
    exit /b 0
)
:: example run.bat 1
if "%1"=="1" (
    echo Running load_dataset.m...
    %MATLAB_CMD% -nosplash -nodesktop -r "try, load_dataset; disp('Press any key to exit...'); pause; catch ME, disp(ME.message); end; exit"
    echo ok.
    pause
    exit /b 0
)
:: example run.bat 2
if "%1"=="2" (
    echo Running synthesis.m...
    %MATLAB_CMD% -nosplash -nodesktop -r "try, synthesis_knn; disp('Press any key to exit...'); pause; catch ME, disp(ME.message); end; exit"
    echo ok.
    pause
    exit /b 0
)


:: 無効な引数の場合
echo Error: Invalid argument. Use 1, 2.
pause
exit /b 1
