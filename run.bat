@Echo Off
chcp 65001 >nul

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Требуются права администратора. Перезапускаю скрипт с повышенными привилегиями...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
set "HOSTS_PATH=%SystemRoot%\System32\drivers\etc\hosts"
REM Заменить если ip сдохнет
set "IP=204.12.192.219"
set "HOSTNAMES=chatgpt.com edgeservices.bing.com ab.chatgpt.com auth.openai.com auth0.openai.com platform.openai.com cdn.oaistatic.com files.oaiusercontent.com cdn.auth0.com tcr9i.chat.openai.com webrtc.chatgpt.com gemini.google.com aistudio.google.com generativelanguage.googleapis.com alkalimakersuite-pa.clients6.google.com copilot.microsoft.com sydney.bing.com claude.ai"
if not exist "%HOSTS_PATH%.bak" (
    copy "%HOSTS_PATH%" "%HOSTS_PATH%.bak"
    echo Резервная копия hosts создана: hosts.bak
) else (
    echo Резервная копия hosts уже существует.
)

echo.>>"%HOSTS_PATH%"
echo.

for %%H in (%HOSTNAMES%) do (
    findstr /i "\<%%H\>" "%HOSTS_PATH%" >nul
    if errorlevel 1 (
        echo %IP% %%H>>"%HOSTS_PATH%"
        echo + / %IP% %%H
    ) else (
        echo - / %%H
    )
)

echo.
echo Успешно, перезапустите браузер (закройте все браузеры и запустите снова).
echo.
chcp 866 >nul

pause
