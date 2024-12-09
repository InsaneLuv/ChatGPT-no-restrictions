@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ==========================
::      Основные настройки
:: ==========================
set "VERSION=0.3"
title GPT-no-restrictions / %VERSION% ver.
color 3

echo ### https://github.com/InsaneLuv/ChatGPT-no-restrictions
echo ### Обход региональных блокировок AI
echo.

:: Запуск основной функции
call :Main
goto :EOF

:: ==========================
::          Main
:: ==========================
:Main
    call :CheckAdmin
    call :SetParameters
    call :BackupHosts
    call :ModifyHosts
    call :Finalize
    goto :EOF

:: ==========================
::    администратор?
:: ==========================
:CheckAdmin
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        echo Требуются права администратора. Кликните правой кнопкой мыши по файлу: "Запуск от имени администратора"
        powershell -Command "Start-Process '%~f0' -Verb RunAs"
        exit  ;; Изменено с exit /b на exit для закрытия окна
    )
    goto :EOF

:: ==========================
::       переменные
:: ==========================
:SetParameters
    set "HOSTS_PATH=%SystemRoot%\System32\drivers\etc\hosts"
    set "BACKUP_PATH=%HOSTS_PATH%.bak"
    set "IP=50.7.85.220"
    set "HOSTNAMES=chatgpt.com ab.chatgpt.com auth.openai.com auth0.openai.com platform.openai.com cdn.oaistatic.com files.oaiusercontent.com cdn.auth0.com tcr9i.chat.openai.com webrtc.chatgpt.com android.chat.openai.com gemini.google.com aistudio.google.com generativelanguage.googleapis.com alkalimakersuite-pa.clients6.google.com copilot.microsoft.com sydney.bing.com edgeservices.bing.com claude.ai aitestkitchen.withgoogle.com aisandbox-pa.googleapis.com o.pki.goog labs.google notebooklm.google notebooklm.google.com api.spotify.com xpui.app.spotify.com appresolve.spotify.com login5.spotify.com gew1-spclient.spotify.com spclient.wg.spotify.com api-partner.spotify.com aet.spotify.com www.spotify.com accounts.spotify.com www.notion.so"
    set "TEMP_FILE=%TEMP%\hosts_new.txt"
    set "SECTION=### GPT-no-restrictions"
    goto :EOF

:: ==========================
::      бэкап
:: ==========================
:BackupHosts
    if not exist "%BACKUP_PATH%" (
        copy "%HOSTS_PATH%" "%BACKUP_PATH%" >nul
        echo Резервная копия hosts создана: hosts.bak
    ) else (
        echo Резервная копия hosts уже существует: hosts.bak
    )
    goto :EOF

:: ==========================
::       изм. hosts
:: ==========================
:ModifyHosts
    :: Копирование текущего hosts во временный файл
    copy "%HOSTS_PATH%" "%TEMP_FILE%" >nul

    :: Добавление секции, если отсутствует
    call :AddSectionHeader

    :: Удаление существующих записей для указанных хостнеймов
    call :RemoveExistingEntries

    :: Добавление новых записей
    call :AddNewEntries

    :: Замена оригинального файла hosts новым
    move /Y "%TEMP_FILE%" "%HOSTS_PATH%" >nul
    if errorlevel 1 (
        echo Ошибка записи в файл hosts. Проверьте права доступа.
        pause
        exit /b
    )
    goto :EOF

:: --------------------------
::      хедер
:: --------------------------
:AddSectionHeader
    findstr /i "%SECTION%" "%TEMP_FILE%" >nul
    if errorlevel 1 (
        echo %SECTION%>>"%TEMP_FILE%"
        echo ### https://github.com/InsaneLuv/ChatGPT-no-restrictions>>"%TEMP_FILE%"
        echo.>>"%TEMP_FILE%"
        echo Секция добавлена: %SECTION%
    ) else (
        echo Секция уже существует: %SECTION%
    )
    goto :EOF

:: --------------------------
::   удалить существующие записи
:: --------------------------
:RemoveExistingEntries
    echo Удаление существующих записей для указанных хостнеймов...
    for %%H in (%HOSTNAMES%) do (
        findstr /i /v "%%H" "%TEMP_FILE%" > "%TEMP_FILE%.tmp"
        move /Y "%TEMP_FILE%.tmp" "%TEMP_FILE%" >nul
    )
    goto :EOF

:: --------------------------
::      новые записи
:: --------------------------
:AddNewEntries
    echo Добавление новых записей...
    for %%H in (%HOSTNAMES%) do (
        echo %IP% %%H>>"%TEMP_FILE%"
        echo + Добавлена/Обновлена запись: %IP% %%H
    )
    goto :EOF

:: ==========================
::        конец
:: ==========================
:Finalize
    cls
    color 2
    echo ### https://github.com/InsaneLuv/ChatGPT-no-restrictions
    echo ### Обход региональных блокировок AI
    echo.
    echo Готово! Закройте программу и перезагрузите браузер.
    echo.
    chcp 866 >nul
    pause
    endlocal
    goto :EOF
