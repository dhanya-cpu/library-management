@echo off
echo ============================================
echo  MySQL Root Password Reset Tool
echo ============================================
echo.
echo This will reset your MySQL root password to: library123
echo.
echo Step 1: Stopping MySQL service...
net stop MySQL80

echo.
echo Step 2: Starting MySQL in skip-grant-tables mode...
start "" "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe" --skip-grant-tables --skip-networking

echo Waiting 5 seconds for MySQL to start...
timeout /t 5 /nobreak

echo.
echo Step 3: Resetting password...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root --connect-expired-password -e "FLUSH PRIVILEGES; ALTER USER 'root'@'localhost' IDENTIFIED BY 'library123';"

echo.
echo Step 4: Stopping skip-grant instance...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqladmin.exe" -u root shutdown

echo.
echo Step 5: Starting MySQL normally...
net start MySQL80

echo.
echo Done! New password is: library123
echo.
pause
