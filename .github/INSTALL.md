## Installation Instructions
The steps are very important in making this installation painless. Please follow in the order the instructions are listed.

### 1. MySQL Steps
Before running the apachLogs2MySQL.sql file open it in your favorite editor and do a Find and Replace the following with a MySQL User account with dba rights on the server you are installing on. This will make installation much easier. Copy below:
```
root`@`%`
```
The easiest way to install is using the MySQL Command Line Client. Login as user with DBA rights and execute the following:
```
source yourpath/apacheLogs2MySQL.sql
```
MySQL server must be configured in my.ini, mysqld.cnf or my.cnf file depending on platform: 
```
[mysqld]
local-infile=1
```
After those 3 steps the server should be good to go.

### 2. Settings.env steps
First rename the settings.env file to .env

By default the load_dotenv() is looking for a file name .env which is standard name for setting files. The file is loaded in both the apacheLogs2MySQL.py and watch4files.py with the following line of code:
```
load_dotenv()  # Loads variables from .env into the environment
```
Windows requires double backslash:
```
C:\\Users\\farmf\\Documents\\apacheLogs\\
```
Lunix & macOS require single frontslash:
```
/home/will/apacheLogs/
```
Below is settings.env with default settings for running on my Windows 11 Pro workstation.
### 3. Settings.env Variables
```
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=password
MYSQL_SCHEMA=apache_logs
WATCH_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\
WATCH_RECURSIVE=1
WATCH_INTERVAL=15
ERROR=1
ERROR_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\**/*error*.*
ERROR_RECURSIVE=1
ERROR_LOG=1
COMBINED=1
COMBINED_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\combined\\**/*access*.*
COMBINED_RECURSIVE=1
COMBINED_LOG=1
VHOST=1
VHOST_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\vhost\\**/*access*.*
VHOST_RECURSIVE=1
VHOST_LOG=1
EXTENDED=1
EXTENDED_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\extended\\**/*access*.*
EXTENDED_RECURSIVE=1
EXTENDED_LOG=1
USERAGENT=1
USERAGENT_LOG=1
```
### 4. Python Steps
Running from command line
```
python watch4logs.py
```
Running from PM2
```
pm2 start watch4logs.py
```
