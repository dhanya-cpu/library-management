@echo off
title Library Management System - Setup
color 0A
echo.
echo ================================================
echo   Library Management System - Auto Setup
echo ================================================
echo.

:: Check admin
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ERROR: Please RIGHT-CLICK this file and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo [1/4] Stopping MySQL service...
net stop MySQL80 >nul 2>&1
timeout /t 2 /nobreak >nul

echo [2/4] Resetting MySQL root password to 'library123'...
:: Start mysqld with skip-grant-tables temporarily
start /B "" "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe" --skip-grant-tables --skip-networking=0 --port=3307 --pid-file="C:\Users\user\kiro1\temp_mysql.pid"
timeout /t 6 /nobreak >nul

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot --host=127.0.0.1 --port=3307 -e "FLUSH PRIVILEGES; ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'library123'; FLUSH PRIVILEGES;" 2>nul

:: Kill temp mysqld
taskkill /f /im mysqld.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo [3/4] Starting MySQL service normally...
net start MySQL80
timeout /t 4 /nobreak >nul

echo [4/4] Setting up library database...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -plibrary123 < "C:\Users\user\kiro1\library-management\database\schema.sql"

if %errorLevel% EQU 0 (
    echo.
    echo ================================================
    echo   SUCCESS! Database is ready.
    echo.
    echo   Open your browser and go to:
    echo   http://localhost:8080/library-management
    echo.
    echo   Admin Login:
    echo   Username: admin
    echo   Password: admin123
    echo ================================================
) else (
    echo.
    echo Database setup failed. Check MySQL connection.
)
echo.
pause
