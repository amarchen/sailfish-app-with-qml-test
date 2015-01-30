@ECHO OFF
@rem Windows script for renaming harbour-helloworld-pro-sailfish into whatever you want you project to be
@rem Checks if input is correct.
@rem Replaces text and rename files in the same cycle.

@setlocal enableextensions enabledelayedexpansion

set toreplace=harbour-helloworld-pro-sailfish
set mypath=%~dp0

if "%~1"=="" (
  echo "Usage: %~nx0 harbour-my-cool-app-name"
  goto finish
)

set newname=%1
set prefix=harbour-

if "x!newname:%prefix%=!"=="x%newname%" (
	echo Your new app name MUST start with "%prefix%"
	goto finish
)

echo. 
echo Replacing "harbour-helloworld-pro-sailfish" with %newname%
echo. 
@rem First rename files
@rem set "FILEFULLNAME=%%~nxA"
@rem set "FILENAME=%%~nA"
@rem set "FILEEXT=%%~xA"
for /r %mypath% %%A in (*) do (
	if not "x!toreplace:%%~nA=!"=="x%toreplace%" (
		if not %%~xA == .gitignore (
			rename %%~dpA%%~nxA %newname%%%~xA
			echo Renamed %%~dpA%%~nxA to %newname%%%~xA
		)
	)
)

echo.
echo Do substitutions in non-binary files
echo.

set mypath=%~dp0
for /r %mypath% %%A in (*) do (
    @rem Ignore this particular file and everything inside .git dir
    if not %%~nA == rename-to-my-project (
		if not %%~dpA == .git (
			if not %%~xA == .rpm (
				@rem prints files whichs contain string to be replaced
				FINDSTR /m %toreplace% %%~dpA%%~nxA
				@rem findstr returns 0 if text found, 1 if not
				IF NOT ERRORLEVEL 1 (
					rename %%~dpA%%~nxA %%~nxA.old
					sed s/%toreplace%/%newname%/g %%~dpA%%~nxA.old > %%~dpA%%~nxA
					del %%~dpA%%~nxA.old
					echo Updated %%~dpA%%~nxA
				)
			)
		)
	)
)

endlocal

:finish