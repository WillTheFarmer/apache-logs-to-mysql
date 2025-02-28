## Installation Instructions
The steps are important to make installation painless.

### 1. Python Steps
Install all modules (`requirements.txt` in repository):
```
pip install -r requirements.txt
```
### 2. Database Steps
Before running `apache_logs_schema.sql` if `root`@`localhost` does not exist open file and do a ***Find and Replace*** of User Account with a User Account with DBA Role on installation server. Copy below:
```
`root`@`localhost`
```
Rename above <sup>user</sup> to a <sup>user</sup> on your server. For example - `root`@`localhost` to `dbadmin`@`localhost`

The easiest way to install is MySQL Command Line Client. Login as User with DBA Role and execute the following:
```
source yourpath/apache_logs_schema.sql
```
Only MySQL server must be configured in `my.ini`, `mysqld.cnf` or `my.cnf` depending on platform with following: 
```
[mysqld]
local-infile=1
```
### 3. Create Database USER and GRANTS
To minimize data exposure and breach risks create a Database USER for Python module with GRANTS to only schema objects and privileges required to execute import processes. (`mysql_user_and_grants.sql` in repository)
### 4. Settings.env steps
settings.env with default settings for Windows. Use Back Slashes `\` on Windows due to subfolder searches return them in path results. Both back and front slashes work properly.
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
GEOIP_CITY=C:\Users\farmf\Downloads\maxmind\GeoLite2-City.mmdb
GEOIP_ASN=C:\Users\farmf\Downloads\maxmind\GeoLite2-ASN.mmdb
# GEOIP_CITY=C:\Users\farmf\Downloads\dbip\dbip-city-lite.mmdb
# GEOIP_ASN=C:\Users\farmf\Downloads\dbip\dbip-asn-lite.mmdb
GEOIP2_PROCESS=1
```
### 5. Rename settings.env file to .env
By default, load_dotenv() looks for standard setting file name `.env`.
### 6. Run Application
If you have log files in the folders already run the logs2mysql.py directly. It will process all the logs in all the folders. If you have empty folders and want to drop files into folders run the watch4logs.py.

Run import process directly:
```
python3 logs2mysql.py
```
Run polling module:
```
python3 watch4logs.py
```
