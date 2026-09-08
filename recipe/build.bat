@echo off
call npm install --global --prefix "%PREFIX%" --ignore-scripts --omit=dev --install-links .
if errorlevel 1 exit /b 1

set PNPM_CONFIG_PM_ON_FAIL=ignore
call pnpm install --prod --ignore-scripts
if errorlevel 1 exit /b 1
call pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt
if errorlevel 1 exit /b 1
