## Installation Instructions
The steps are important to make installation painless.

### 1. MySQL Steps
Before running `apache_logs_schema.sql` if `root`@`localhost` does not exist open file and do a ***Find and Replace*** of User Account with a User Account with DBA Role on installation server. Copy below:
```
`root`@`localhost`
```
Rename above <sup>user</sup> to a <sup>user</sup> on your server. For example - `root`@`localhost` to `dbadmin`@`localhost`

The easiest way to install is MySQL Command Line Client. Login as User with DBA Role and execute the following:
```
source yourpath/apache_logs_schema.sql
```
MySQL server must be configured in `my.ini`, `mysqld.cnf` or `my.cnf` depending on platform with following: 
```
[mysqld]
local-infile=1
```
After these 3 steps MySQL server should be good to go.

### 2. Python Steps
Install all modules (`requirements.txt` in repository):
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
Python module links & install command lines for each platform. Single quotes around module name are required on macOS.
|Python Package|Windows 10 & 11|Ubuntu 24.04|macOS 15.0.1 Darwin 24.0.0|GitHub Repository|
|--------------|---------------|------------|--------------------------|-----------------|
|[PyMySQL](https://pypi.org/project/PyMySQL/)|python -m pip install PyMySQL[rsa]|sudo apt-get install python3-pymysql|python3 -m pip install 'PyMySQL[rsa]'|[PyMySQL/PyMySQL](https://github.com/PyMySQL/PyMySQL)|
|[user-agents](https://pypi.org/project/user-agents/)|pip install pyyaml ua-parser user-agents|sudo apt-get install python3-user-agents|python3 -m pip install user-agents|[selwin/python-user-agents](https://github.com/selwin/python-user-agents)|
|[watchdog](https://pypi.org/project/watchdog/)|pip install watchdog|sudo apt-get install python3-watchdog|python3 -m pip install watchdog|[gorakhargosh/watchdog](https://github.com/gorakhargosh/watchdog/tree/master)|
|[python-dotenv](https://pypi.org/project/python-dotenv/)|pip install python-dotenv|sudo apt-get install python3-dotenv|python3 -m pip install python-dotenv|[theskumar/python-dotenv](https://github.com/theskumar/python-dotenv)|
|[geoip2](https://pypi.org/project/geoip2/)|pip install geoip2|sudo apt-get install python3-geoip2|python3 -m pip install python-geoip2|[maxmind/GeoIP2-python](https://github.com/maxmind/GeoIP2-python)|

### 4. Settings.env steps
First rename the settings.env file to .env

By default the load_dotenv() is looking for a file name .env which is standard name for setting files. The file is loaded in both the logs2mysql.py and watch4files.py with the following line of code:
```
load_dotenv() # Loads variables from .env into the environment
```
Below is settings.env with default settings for running on Windows 11 Pro workstation. Make sure the correct logFormats are in correct logFormat folders. The application does not currently detect logFormats. Data will not be imported properly if folder settings are not correct.
### 5. Settings.env Variables
```
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=apache_upload
MYSQL_PASSWORD=password
MYSQL_SCHEMA=apache_logs
WATCH_PATH=C:\Users\farmf\Documents\apacheLogs\
WATCH_RECURSIVE=1
WATCH_INTERVAL=15
WATCH_LOG=2
ERROR=1
ERROR_LOG=2
ERROR_PATH=C:\Users\farmf\Documents\apacheLogs\**/*error*.*
ERROR_RECURSIVE=1
ERROR_PROCESS=2
ERROR_SERVER=errordomain.com
ERROR_SERVERPORT=911
COMBINED=1
COMBINED_LOG=2
COMBINED_PATH=C:\Users\farmf\Documents\apacheLogs\combined\**/*access*.*
COMBINED_RECURSIVE=1
COMBINED_PROCESS=2
COMBINED_SERVER=combodomain.com
COMBINED_SERVERPORT=311
VHOST=1
VHOST_LOG=2
VHOST_PATH=C:\Users\farmf\Documents\apacheLogs\vhost\**/*access*.*
VHOST_RECURSIVE=1
VHOST_PROCESS=2
CSV2MYSQL=1
CSV2MYSQL_LOG=2
CSV2MYSQL_PATH=C:\Users\farmf\Documents\apacheLogs\csv2mysql\**/*access*.*
CSV2MYSQL_RECURSIVE=1
CSV2MYSQL_PROCESS=2
USERAGENT=1
USERAGENT_LOG=2
USERAGENT_PROCESS=1
GEOIP2=1
GEOIP2_LOG=2
GEOIP2_CITY=C:\Users\farmf\Downloads\ip_databases\dbip-city-lite-2025-01.mmdb
GEOIP2_ASN=C:\Users\farmf\Downloads\ip_databases\dbip-asn-lite-2025-01.mmdb
GEOIP2_PROCESS=1
```
### 6. Run Application
If MySQL steps completed successfully, successfully installed Python modules, renamed file `settings.env` to `.env`, and updated MySQL server connection and log folder variables it is time to run application.

If you have log files in the folders already run the logs2mysql.py directly. It will process all the logs in all the folders. If you have empty folders and want to drop files into folders run the watch4logs.py.

Run import process directly:
```
python logs2mysql.py
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
