@echo off

chcp 65001 >nul

call :setESC

set TARGET=slide

set flag=%1
if %flag%x == x (
	set flag=slide
)

if %flag%x == slidex (
	call :cleanall
	call :slide	
	if ERRORLEVEL 1 (
		echo.
		echo %ESC%[31mError! Please check the %ESC%[7m'%TARGET%.log'%ESC%[0;31m for more details . . .%ESC%[0m
		pause
	) else (
		call :clean
		echo %ESC%[32mFinished!%ESC%[0m
		pause
	)
	goto :EOF
)

if %flag%x == thesisx (
	call :cleanall
	call :slide	
	if ERRORLEVEL 1 (
		echo.
		echo %ESC%[31mError! Please check the %ESC%[7m'%TARGET%.log'%ESC%[0;31m for more details . . .%ESC%[0m
		pause
	) else (
		call :clean
		echo %ESC%[32mFinished!%ESC%[0m
		pause
	)
	goto :EOF
)

if %flag%x == cleanx (
	call :clean
	goto :EOF
)

if %flag%x == cleanallx (
	call :cleanall
	goto :EOF
)

:help
	echo %ESC%[33mThis is the compile batch script for SWUFE Beamer Theme.
	echo Usage:
	echo     Compile.bat [option]
	echo options:
	echo   slide     Compile the slide (default)
	echo   clean     Clean all work files
	echo   cleanall  Clean all work files and slide.pdf
	echo   help      Print this help message%ESC%[0m
goto :EOF

:slide
	echo %ESC%[33mCompile . . .%ESC%[0m
	latexmk -xelatex -quiet -file-line-error -halt-on-error -interaction=nonstopmode %TARGET% 2>nul
	if ERRORLEVEL 1 (
		echo %ESC%[33mRetrying with xelatex . . .%ESC%[0m
		xelatex -interaction=nonstopmode -file-line-error %TARGET%.tex
		bibtex %TARGET% >nul 2>nul
		xelatex -interaction=nonstopmode -file-line-error %TARGET%.tex >nul 2>nul
		xelatex -interaction=nonstopmode -file-line-error %TARGET%.tex
	)
goto :EOF

:clean
	echo %ESC%[33mClean files . . .%ESC%[0m
	latexmk -quiet -c %TARGET% 2>nul
	del /q /f *.aux *.bbl *.blg *.fdb_latexmk *.fls *.log *.nav *.out *.snm *.synctex.gz *.toc *.vrb *.xdv *.bcf *.run.xml 2>nul
goto :EOF

:cleanall
	echo %ESC%[33mClean files . . .%ESC%[0m
	latexmk -quiet -C %TARGET% 2>nul
	del /q /f *.aux *.bbl *.blg *.fdb_latexmk *.fls *.log *.nav *.out *.snm *.synctex.gz *.toc *.vrb *.xdv *.bcf *.run.xml 2>nul
	if exist %TARGET%.pdf (
		del /q /f %TARGET%.pdf 2>nul
	)
	if exist %TARGET%.pdf (
		echo %ESC%[31mClose the file: %ESC%[7m'%TARGET%.pdf'%ESC%[0;31m!%ESC%[0m
		pause
		call :cleanall
	)
goto :EOF

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
	set ESC=%%b
	exit /B 0
)
exit /B 0
