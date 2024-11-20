@Echo Off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "ver=0.2"
TITLE GPT-no-restrictions / %ver% ver.

color 3
echo ### https://github.com/InsaneLuv/ChatGPT-no-restrictions
echo ### Обход региональных блокировок AI
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Для работы требуются права администратора.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

set "HOSTS_PATH=%SystemRoot%\System32\drivers\etc\hosts"
set "IP=204.12.192.219"
set "HOSTNAMES=chatgpt.com edgeservices.bing.com ab.chatgpt.com auth.openai.com auth0.openai.com platform.openai.com cdn.oaistatic.com files.oaiusercontent.com cdn.auth0.com tcr9i.chat.openai.com webrtc.chatgpt.com gemini.google.com aistudio.google.com generativelanguage.googleapis.com alkalimakersuite-pa.clients6.google.com copilot.microsoft.com sydney.bing.com claude.ai"


if not exist "%HOSTS_PATH%.bak" (
    copy "%HOSTS_PATH%" "%HOSTS_PATH%.bak"
    echo Резервная копия hosts создана: hosts.bak
)


set "changes_made=false"
set "TEMP_FILE=%TEMP%\hosts_new.txt"


copy "%HOSTS_PATH%" "%TEMP_FILE%" >nul


findstr /i "### GPT-no-restrictions" "%HOSTS_PATH%" >nul
if errorlevel 1 (
    echo ### GPT-no-restrictions>>"%TEMP_FILE%"
    echo ### https://github.com/InsaneLuv/ChatGPT-no-restrictions>>"%TEMP_FILE%"
    echo.>>"%TEMP_FILE%"
)


for %%H in (%HOSTNAMES%) do (
    findstr /i /c:"%IP% %%H" "%HOSTS_PATH%" >nul
    if errorlevel 1 (
        set "changes_made=true"
        echo %IP% %%H>>"%TEMP_FILE%"
        echo + Добавлена запись: %IP% %%H
    )
)


if "!changes_made!"=="false" (
    color 6
    echo Программа уже была запущена на этом ПК. Повторных запусков не требуется.
    echo.
    pause
    del "%TEMP_FILE%"
    exit /b
)


move /Y "%TEMP_FILE%" "%HOSTS_PATH%" >nul
if errorlevel 1 (
    echo Ошибка записи в файл hosts. Проверьте права доступа.
    pause
    exit /b
)

cls
color 2
echo ### https://github.com/InsaneLuv/ChatGPT-no-restrictions
echo ### Обход региональных блокировок AI
echo.
echo Готово!
echo Закройте программу и перезагрузите браузер.
echo.
chcp 866 >nul
pause
endlocal
