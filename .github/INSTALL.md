## Installation Instructions
The steps are very important to make installation painless. Please follow instructions in order.

### 1. MySQL Steps
Before running `apachLogs2MySQL.sql` open file in your favorite editor and do a ***Find and Replace*** of the following User Account with a User Account with DBA Role on server you are installing on. This will make everything much easier. Copy below:
```
`root`@`%`
```
Rename above <sup>user</sup> to a <sup>user</sup> on your server. For example - `root`@`%` to `dbadmin`@`localhost`

The easiest way to install is use MySQL Command Line Client. Login as User with DBA Role and execute the following:
```
source yourpath/apacheLogs2MySQL.sql
```
MySQL server must be configured in `my.ini`, `mysqld.cnf` or `my.cnf` depending on platform with following: 
```
[mysqld]
local-infile=1
```
After these 3 steps MySQL server should be good to go.

### 2. Python Steps
Install all modules:
```
pip install -r requirements.txt
```
macOS platform may require installation of pip.
```
xcode-select --install
python3 -m ensurepip --upgrade 
```
If any issues with ***pip install*** occur use individual install commands below:

### 3. Required Python Modules
Python module links & install command lines for each platform. Single quotes around module name are required on macOS. The simplest option is run the command line under '5. Python Steps'. If that works you are all set. The `requirements.txt` file is included in repository.
|Python Package|Windows 10 & 11|Ubuntu 24.04|macOS 15.0.1 Darwin 24.0.0|GitHub Repository|
|--------------|---------------|------------|--------------------------|-----------------|
|[PyMySQL](https://pypi.org/project/PyMySQL/)|python -m pip install PyMySQL[rsa]|sudo apt-get install python3-pymysql|python3 -m pip install 'PyMySQL[rsa]'|[PyMySQL/PyMySQL](https://github.com/PyMySQL/PyMySQL)|
|[user-agents](https://pypi.org/project/user-agents/)|pip install pyyaml ua-parser user-agents|sudo apt-get install python3-user-agents|python3 -m pip install user-agents|[selwin/python-user-agents](https://github.com/selwin/python-user-agents)|
|[watchdog](https://pypi.org/project/watchdog/)|pip install watchdog|sudo apt-get install python3-watchdog|python3 -m pip install watchdog|[gorakhargosh/watchdog](https://github.com/gorakhargosh/watchdog/tree/master)|
|[python-dotenv](https://pypi.org/project/python-dotenv/)|pip install python-dotenv|sudo apt-get install python3-dotenv|python3 -m pip install python-dotenv|[theskumar/python-dotenv](https://github.com/theskumar/python-dotenv)|

### 4. Settings.env steps
First rename the settings.env file to .env

By default the load_dotenv() is looking for a file name .env which is standard name for setting files. The file is loaded in both the apacheLogs2MySQL.py and watch4files.py with the following line of code:
```
load_dotenv() # Loads variables from .env into the environment
```
Windows requires double backslash:
```
C:\\Users\\farmf\\Documents\\apacheLogs\\
```
Lunix & macOS require single frontslash:
```
/home/will/apacheLogs/
```
Below is settings.env with default settings for running on Windows 11 Pro workstation. Make sure the correct logFormats are in correct logFormat folders. The application does not currently detect logFormats. Data will not be imported properly if folder settings are not correct.
### 5. Settings.env Variables
```
MYSQL_HOST=localhost # MySQL server
MYSQL_PORT=3306 # MySQL server port
MYSQL_USER=root # MySQL server User 
MYSQL_PASSWORD=password # MySQL server User Password
MYSQL_SCHEMA=apache_logs # MySQL database schema ApacheLogs2MySQL will create
WATCH_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\  # watch folder for new files
WATCH_RECURSIVE=1 # watch all subfolders - 0=no 1=yes
WATCH_INTERVAL=15 # seconds between watching for new files
ERROR=1 # process error logs - 0=no 1=yes
ERROR_LOG=2 # display process error processing to console in python - 0=none 1=summary 2=summary & each file being processed
ERROR_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\**/*error*.* # process folder & file patterns for Error Log files - MUST BE Watch folder and can be Subfolders
ERROR_RECURSIVE=1 # watch all subfolders - 0=no 1=yes
ERROR_PROCESS=1 # execute MySQL Stored Procedure to import Error log staging table - 0=no 1=yes
COMBINED=1 # process Common and Combined Access logs - 0=no 1=yes
COMBINED_LOG=2 # display Common and Combined Access log processing to console in python - 0=none 1=summary 2=summary & each file being processed
COMBINED_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\combined\\**/*access*.* # process folder & file patterns for Common and Combined Access files - MUST BE Watch subfolder
COMBINED_RECURSIVE=1 # watch all subfolders - 0=no 1=yes
COMBINED_PROCESS=1 # execute MySQL Stored Procedure to import Common and Combined Access staging table - 0=no 1=yes
VHOST=1 # process Vhost Access logs - 0=no 1=yes
VHOST_LOG=2 # display Vhost Access log processing to console in python - 0=none 1=summary 2=summary & each file being processed
VHOST_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\vhost\\**/*access*.* # process folder & file patterns for Vhost Access files - MUST BE Watch subfolder
VHOST_RECURSIVE=1 # watch all subfolders - 0=no 1=yes
VHOST_PROCESS=1 # execute MySQL Stored Procedure to import Vhost Access log staging table - 0=no 1=yes
CSV2MYSQL=1 # process error logs - 0=no 1=yes
CSV2MYSQL_LOG=2 # display Csv2mysql Access log processing to console in python - 0=none 1=summary 2=summary & each file being processed
CSV2MYSQL_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\csv2mysql\\**/*access*.* # process folder & file patterns for Csv2mysql Access files - MUST BE Watch subfolder
CSV2MYSQL_RECURSIVE=1 # watch all subfolders - 0=no 1=yes
CSV2MYSQL_PROCESS=1 # execute MySQL Stored Procedure to import Csv2mysql Access log staging table - 0=no 1=yes
USERAGENT=1 # process csv2mysql Access logs - 0=no 1=yes
USERAGENT_LOG=2 # display userAgent processing to console in python - 0=none 1=summary 2=summary & each file being processed
USERAGENT_PROCESS=1 # execute MySQL Stored Procedure process userAgent parsed table into 14 normalized userAgent tables - 0=no 1=yes
```
### 6. Run Application
If MySQL steps completed successfully, successfully installed Python modules, renamed file `settings.env` to `.env`, and updated MySQL server connection and log folder variables it is time to run application.

If you have log files in the folders already run the apacheLogs2MySQL.py directly. It will process all the logs in all the folders. If you have empty folders and want to drop files into folders run the watch4logs.py.

Run import process directly:
```
python apacheLogs2MySQL.py
```
Run polling module:
```
python watch4logs.py
```
Once you get all logs processed & a better understanding of application use PM2 to run application 24/7 waiting to process files on arrival.
Run polling module from PM2:
```
pm2 start watch4logs.py
```
