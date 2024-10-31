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
### 4. Required Python Modules
Python module links & install command lines for each platform. I had to email PyMySQL author for correct macOS command line. The normal command line did not work & I could not find the proper one posted anywhere. Yes, the single quotes are required. The simplest option is run the command line under '5. Python Steps'. If that works you are all set. The `requirements.txt` file is included in repository.
|Python Package|Windows 10 & 11|Ubuntu 24.04|macOS 15.0.1 Darwin 24.0.0|GitHub Repository|
|--------------|---------------|------------|--------------------------|-----------------|
|[PyMySQL](https://pypi.org/project/PyMySQL/)|python -m pip install PyMySQL[rsa]|sudo apt-get install python3-pymysql|python3 -m pip install 'PyMySQL[rsa]'|[PyMySQL/PyMySQL](https://github.com/PyMySQL/PyMySQL)|
|[user-agents](https://pypi.org/project/user-agents/)|pip install pyyaml ua-parser user-agents|sudo apt-get install python3-user-agents|python3 -m pip install user-agents|[selwin/python-user-agents](https://github.com/selwin/python-user-agents)|
|[watchdog](https://pypi.org/project/watchdog/)|pip install watchdog|sudo apt-get install python3-watchdog|python3 -m pip install watchdog|[gorakhargosh/watchdog](https://github.com/gorakhargosh/watchdog/tree/master)|
|[python-dotenv](https://pypi.org/project/python-dotenv/)|pip install python-dotenv|sudo apt-get install python3-dotenv|python3 -m pip install python-dotenv|[theskumar/python-dotenv](https://github.com/theskumar/python-dotenv)|
### 5. Python Steps
Install all modules:
```
pip install -r requirements.txt
```
macOS platform may require installation of pip.
```
xcode-select --install
python3 -m ensurepip --upgrade 
```
### 6. Run Application
If MySQL steps completed successfully, renamed file `settings.env` to `.env`, updated variables for MySQL server connection and log folders and successfully installed Python modules it is time to run application. If you have log files in the folders already run the apacheLogs2MySQL.py directly. It will process all the logs in all the folders. If you have empty folders and want to drop files into folders run the watch4logs.py. Once you get all logs processed & get a better understanding of application use PM2 to run application 24/7 waiting to process files on arrival.

Run import process directly:
```
python apacheLogs2MySQL.py
```
Run polling module:
```
python watch4logs.py
```
Run polling module from PM2:
```
pm2 start watch4logs.py
```