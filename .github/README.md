## Apache Log Parser and Data Normalization Application
### Python handles File Processing & MySQL handles Data Processing
ApacheLogs2MySQL consists of two Python Modules & one MySQL Schema ***apache_logs*** to automate importing Access & Error files 
and normalizing data into database designed for reports & data analysis.

Imports Access Logs in LogFormats - ***common***, ***combined*** and ***vhost_combined*** & additional ***csv2mysql*** 
LogFormat defined :point_down: 

Imports Error Logs in ***default*** ErrorLogFormat & ***additional*** ErrorLogFormat defined below performing data harmonization 
on Apache Codes & Messages, System Codes & Messages, and Log Messages to create a unified, standardized dataset. Error Log view images :point_down:

All processing stages are encapsulated within one "Import Load" that captures process metrics, notifications and errors into MySQL import tables. 
Every log data record is traceable back to the computer, folder, file, load process, parse process and import process it came from.

Multiple Access and Error logs and formats can be loaded, parsed and imported along with User Agent parsing and IP Address Geolocation retrieval in a single execution. 
A single execution can also be configured to only load logs to Server.
#### Process Messages in Console - 4 LogFormats, 2 ErrorLogFormats & 6 MySQL Stored Procedures
![Processing Messages Console](./assets/processing_messages_console.png)
ApacheLogs2MySQL has [MaxMind GeoIP2](https://github.com/maxmind/GeoIP2-python) Python API integration with 6 MySQL tables for IP Geolocation data normalization. 
Two DB-IP Lite databases are required - `IP to City` and `IP to ASN`. Free DB-IP Lite databases can be found at [DB-IP](https://db-ip.com/db/lite.php)

Database Schema ***apache_logs*** designed to accommodate unlimited servers & domains. Step-by-step guide for easy installation :point_down:

A visualization tool for the MySQL Schema ***apache_logs*** is [MySQL2ApacheECharts](https://github.com/willthefarmer/mysql-to-apache-echarts) and currently under development. 
The Web interface consists of [Express](https://github.com/expressjs/express) web application frameworks with Drill Down Capability 
& [Apache ECharts](https://github.com/apache/echarts) frameworks for Data Visualization.
### Entity Relationship Diagram of apache_logs schema tables
![Entity Relationship Diagram](./assets/entity_relationship_diagram.png)
Diagram created with open-source database diagrams editor [chartdb/chartdb](https://github.com/chartdb/chartdb)
### Application runs on Windows, Linux and MacOS
This is a fast, reliable processing application with detailed logging and two stages of data parsing. 
First stage is performed in `LOAD DATA LOCAL INFILE` statements. 
Second stage is performed in `process_access_parse` and `process_error_parse` Stored Procedures.

Python handles polling of log file folders and executing MySQL Database LOAD DATA, Stored Procedures, Stored Functions and SQL Statements. 
Python drives the application but MySQL does all Data Manipulation & Processing.

Log files can be left in folders imported from for later reference. Application determines what files have been processed using `apache_logs.import_file` TABLE. 
Each imported file has record with name, path, size, created, modified attributes inserted during `processLogs`. Application runs with no need for user interaction. 

Log-level variables can be set to display info messages in console or inserted into PM2 logs for every process step. 
All import errors in Python `processLogs` (client) and MySQL Stored Procedures (server) are inserted into `apache_logs.import_error` TABLE.
This is the only schema table that uses ENGINE=MYISAM to avoid TRANSACTION ROLLBACKS.

Logging functionality, database design and table relationship constraints produce both physical and logical integrity. 
This enables a complete audit trail providing ability to determine when, where and what file each record originated from.

All folder paths, filename patterns, logging, processing, MySQL connection setting variables are in .env file for easy installation and maintenance.

Two Python Client modules can run in PM2 daemon process manager for 24/7 online processing on multiple web servers feeding a single Server module simultaneous.

Application is developed with Python 3.12, MySQL and 5 Python modules. Modules are listed with Python Package Index link, 
install command for each platform & GitHub Repository link.
### Four Supported Access Log Formats
Apache uses same Standard Access LogFormats (***common***, ***combined***, ***vhost_combined***) on all 3 platforms. Each LogFormat adds 2 Format Strings to the prior. 
Format String descriptions are listed below each LogFormat. Information from: https://httpd.apache.org/docs/2.4/mod/mod_log_config.html#logformat 
```
LogFormat "%h %l %u %t \"%r\" %>s %O" common
```
|Format String|Description|
|-------------|-----------|
|%h|Remote hostname. Will log IP address if HostnameLookups is set to Off, which is default. If it logs hostname for only a few hosts, you probably have access control directives mentioning them by name.|
|%l|Remote logname. Returns dash unless "mod_ident" is present and IdentityCheck is set On. This can cause serious latency problems accessing server since every request requires a lookup be performed.| 
|%u|Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).|
|%t|Time the request was received, in the format [18/Sep/2011:19:18:28 -0400]. The last number indicates the timezone offset from GMT|
|%r|First line of request. Contains 4 format strings (%m - The request method, %U - The URL path requested not including any query string, %q - The query string, %H - The request protocol)|
|%s|Status. For requests that have been internally redirected, this is the status of the original request. Use %>s for the final status.|
|%O|Bytes sent, including headers. May be zero in rare cases such as when a request is aborted before a response is sent. You need to enable mod_logio to use this.|
```
LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
```
|Format String|Description - additional format strings|
|-------------|-----------|
|"%{Referer}i|The "Referer" (sic) HTTP request header. This gives the site that the client reports having been referred from.|
|%{User-Agent}i|The User-Agent HTTP request header. This is the identifying information that the client browser reports about itself.|
```
LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
```
|Format String|Description - additional format strings|
|-------------|-----------|
|%v|The canonical ServerName of the server serving the request.|
|%p|The canonical port of the server serving the request.|

Application is designed to use the ***csv2mysql*** LogFormat. LogFormat has comma-separated values and adds 8 Format Strings. A complete list of Format Strings
with descriptions indicating added Format Strings below.
```
LogFormat "%v,%p,%h,%l,%u,%t,%I,%O,%S,%B,%{ms}T,%D,%^FB,%>s,\"%H\",\"%m\",\"%U\",\"%q\",\"%{Referer}i\",\"%{User-Agent}i\",\"%{VARNAME}C\",%L" csv2mysql
```
|Format String|Description|
|-------------|-----------|
|%v|The canonical ServerName of the server serving the request.|
|%p|The canonical port of the server serving the request.|
|%h|Remote hostname. Will log the IP address if HostnameLookups is set to Off, which is the default.|
|%l|Remote logname. Returns dash unless "mod_ident" is present and IdentityCheck is set On. This can cause serious latency problems accessing server since every request requires a lookup be performed.| 
|%u|Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).|
|%t|Time the request was received, in the format [18/Sep/2011:19:18:28 -0400]. The last number indicates the timezone offset from GMT|
|%I|ADDED - Bytes received, including request and headers. Enable "mod_logio" to use this.|
|%O|Bytes sent, including headers. The %O format provided by mod_logio will log the actual number of bytes sent over the network. Enable "mod_logio" to use this.|
|%S|ADDED - Bytes transferred (received and sent), including request and headers, cannot be zero. This is the combination of %I and %O. Enable "mod_logio" to use this.|
|%B|ADDED - Size of response in bytes, excluding HTTP headers. Does not represent number of bytes sent to client, but size in bytes of HTTP response (will differ, if connection is aborted, or if SSL is used).|
|%{ms}T|ADDED - The time taken to serve the request, in milliseconds. Combining %T with a unit is available in 2.4.13 and later.|
|%D|ADDED - The time taken to serve the request, in microseconds.|
|%^FB|ADDED - Delay in microseconds between when the request arrived and the first byte of the response headers are written. Only available if LogIOTrackTTFB is set to ON. Available in Apache 2.4.13 and later.|
|%s|Status. For requests that have been internally redirected, this is the status of the original request.|
|%H|The request protocol. Included in %r - First line of request.|
|%m|The request method. Included in %r - First line of request.|
|%U|The URL path requested, not including any query string. Included in %r - First line of request.|
|%q|The query string (prepended with a ? if a query string exists, otherwise an empty string). Included in %r - First line of request.|
|%{Referer}i|The "Referer" (sic) HTTP request header. This gives the site that the client reports having been referred from.|
|%{User-Agent}i|The User-Agent HTTP request header. This is the identifying information that the client browser reports about itself.|
|%{VARNAME}C|ADDED - The contents of cookie VARNAME in request sent to server. Only version 0 cookies are fully supported. Format String is optional.|
|%L|ADDED - The request log ID from the error log (or '-' if nothing has been logged to the error log for this request). Look for the matching error log line to see what request| caused what error.
### Two supported Error Log Formats
Application processes Error Logs with ***default format*** for threaded MPMs (Multi-Processing Modules). If running Apache 2.4 on any platform 
and ErrorLogFormat is not defined in config files this is the Error Log format.
Information from: https://httpd.apache.org/docs/2.4/mod/core.html#errorlogformat
```
ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i"
```
|Format String|Description|
|-------------|-----------|
|%{u}t|The current time including micro-seconds|
|%m|Name of the module logging the message|
|%l|Loglevel of the message|
|%P|Process ID of current process|
|%T|Thread ID of current thread|
|%F|Source file name and line number of the log call. %7F - the 7 means only display when LogLevel=debug|
|%E|APR/OS error status code and string|
|%a|Client IP address and port of the request|
|%M|The actual log message|
|%{Referer}i|The "Referer" (sic) HTTP request header. This gives the site that the client reports having been referred from.| 

Application also processes Error Logs with ***additional format*** which adds:
 1) `%v - The canonical ServerName` - This is easiest way to identify error logs for each domain is add `%v` to ErrorLogFormat. 
 2) `%L - Log ID of the request` - This is easiest way to associate Access record that created an Error record. 
 Apache mod_unique_id.generate_log_id() only called when error occurs and will not cause performance degradation under error-free operations. 

***Important:*** `Space` required on left-side of `Commas` as defined below:
```
ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i ,%v ,%L"
```
To use this format place `ErrorLogFormat` before `ErrorLog` in `apache2.conf` to set error log format for ***Server*** and ***VitualHosts*** on Server.
|Format String|Description - `Space` required on left-side of `Commas` to parse data properly|
|-------------|-----------|
|%v|The canonical ServerName of the server serving the request.|
|%L|Log ID of the request. A %L format string is also available in `mod_log_config` to allow to correlate access log entries with error log lines. If [mod_unique_id](https://httpd.apache.org/docs/current/mod/mod_unique_id.html) is loaded, its unique id will be used as log ID for requests.|

### Three options to associate ServerName & ServerPort to Access & Error logs
Apache LogFormats - ***common***, ***combined*** and Apache ErrorLogFormat - ***default*** do not contain `%v - canonical ServerName` and `%p - canonical ServerPort`.

In order to consolidate logs from multiple domains `%v - canonical ServerName` is required and `%p - canonical ServerPort` is optional. 

Listed are different methods to associate ServerName and ServerPort to all Access and Error logs.

1) Set `ERRORLOG_SERVERNAME`, `ERRORLOG_SERVERPORT`, `COMBINED_SERVERNAME`, `COMBINED_SERVERPORT` variables in .env file and uncomment `os.getenv` 
lines at top of `logs2mysql.py`. By default, variables are defined and set to an empty string. 
Below is screenshot of `logs2mysql.py` with commented `os.getenv` code. `server_name` and `server_port` COLUMNS of `load_error_default` and `load_access_combined` 
TABLES will be SET during Python `LOAD DATA LOCAL INFILE` execution.

![load_settings_variables.png](./assets/load_settings_variables.png)

2) Manually ***UPDATE*** `server_name` and `server_port` COLUMNS of `load_error_default` and `load_access_combined` TABLES after STORED PROCEDURES `process_access_parse` 
and `process_error_parse` and before `process_access_import` and `process_error_import`. 
If `%v` or `%p` Format Strings exist parsing into `server_name` and `server_port` COLUMNS is performed in parse processes. 
Data Normalization is performed in import processes. 

3) Populate `server_name` and `server_port` COLUMNS in `import_file` TABLE before import processes. This will populate all records associated with file.
This option only updates records with NULL values in ***load_tables*** `server_name` and `server_port` COLUMNS while executing 
STORED PROCEDURES `process_access_import` and `process_error_import`. 

UPDATE commands to populate both Access and Error Logs if ***"Log File Names"*** are related to VirtualHost similar to:
```
 ErrorLog ${APACHE_LOG_DIR}/farmfreshsoftware.error.log
 CustomLog ${APACHE_LOG_DIR}/farmfreshsoftware.access.log csv2mysql
```
Log file naming conventions enable the use of UPDATE statements:
```
UPDATE apache_logs.import_file SET server_name='farmfreshsoftware.com', server_port=443 WHERE server_name IS NULL AND name LIKE '%farmfreshsoftware%';
UPDATE apache_logs.import_file SET server_name='farmwork.app', server_port=443 WHERE server_name IS NULL AND name LIKE '%farmwork%';
UPDATE apache_logs.import_file SET server_name='ip255-255-255-255.us-east.com', server_port=443 WHERE server_name IS NULL AND name LIKE '%error%';
```
## Required Python Modules
Python module links & install command lines for each platform. Single quotes around module name are required on macOS. The simplest installation option is run the 
command line under '2. Python Steps' below. If that works you are all set.
|Python Package|Windows 10 & 11|Ubuntu 24.04|macOS 15.0.1 Darwin 24.0.0|GitHub Repository|
|--------------|---------------|------------|--------------------------|-----------------|
|[PyMySQL](https://pypi.org/project/PyMySQL/)|python -m pip install PyMySQL[rsa]|sudo apt-get install python3-pymysql|python3 -m pip install 'PyMySQL[rsa]'|[PyMySQL/PyMySQL](https://github.com/PyMySQL/PyMySQL)|
|[user-agents](https://pypi.org/project/user-agents/)|pip install pyyaml ua-parser user-agents|sudo apt-get install python3-user-agents|python3 -m pip install user-agents|[selwin/python-user-agents](https://github.com/selwin/python-user-agents)|
|[watchdog](https://pypi.org/project/watchdog/)|pip install watchdog|sudo apt-get install python3-watchdog|python3 -m pip install watchdog|[gorakhargosh/watchdog](https://github.com/gorakhargosh/watchdog/tree/master)|
|[python-dotenv](https://pypi.org/project/python-dotenv/)|pip install python-dotenv|sudo apt-get install python3-dotenv|python3 -m pip install python-dotenv|[theskumar/python-dotenv](https://github.com/theskumar/python-dotenv)|
|[geoip2](https://pypi.org/project/geoip2/)|pip install geoip2|sudo apt-get install python3-geoip2|python3 -m pip install python-geoip2|[maxmind/GeoIP2-python](https://github.com/maxmind/GeoIP2-python)|

## Installation Instructions
Steps make installation quick and straightforward. Application will be ready to import Apache logs on completion.

### 1. MySQL Steps
Before running `apache_logs_schema.sql` if User Account `root`@`localhost` does not exist on installation server open 
file and perform a ***Find and Replace*** using a User Account with DBA Role on installation server. Copy below:
```
root`@`localhost`
```
Rename above <sup>user</sup> to a <sup>user</sup> on your server. For example - `root`@`localhost` to `dbadmin`@`localhost`

The easiest way to install is use MySQL Command Line Client. Login as User with DBA Role and execute the following:
```
source yourpath/apache_logs_schema.sql
```
MySQL server must be configured in `my.ini`, `mysqld.cnf` or `my.cnf` depending on platform with following: 
```
[mysqld]
local-infile=1
```
After these 3 steps MySQL server is ready to go.

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
If issues with ***pip install*** occur use individual install commands included above.

### 3. Create MySQL USER and GRANTS
To minimize data exposure and breach risks create a MySQL USER for Python module with GRANTS to only schema objects and privileges 
required to execute import processes. (`mysql_user_and_grants.sql` in repository)
![mysql_user_and_grants.sql in repository](./assets/mysql_user_and_grants.png)
### 4. Settings.env Variables
settings.env with default settings for Windows. Make sure correct logFormats are in correct logFormat folders. Application does not
detect logFormats. Data will not import properly if folder settings are not correct. (`settings.env` in repository)
![settings.env in repository](./assets/settings.png)
### 5. Rename settings.env file to .env
By default, load_dotenv() looks for standard setting file name `.env`. The file is loaded in both `logs2mysql.py` and `watch4files.py` with following line:
```
load_dotenv() # Loads variables from .env into the environment
```
### 6. Run Application
If MySQL steps are complete, Python modules are installed, MySQL server connection and log folder variables are updated, 
and file `settings.env` is renamed to `.env` application is ready to go.

If log files exist in folders run `logs2mysql.py` and all files in all folders will be processed. Run `watch4logs.py` and 
drop a file or files into folder and `logs2mysql.py` will be executed. 
If folders are empty or contain files when a file is drop into folder any unprocessed files in folders will be processed.

Run import process directly:
```
python logs2mysql.py
```
Run polling module:
```
python watch4logs.py
```
Once existing logs are processed & a better understanding of application is acquired use PM2 to run application 24/7 watching for files to process.
Run polling module from PM2:
```
pm2 start watch4logs.py
```
## Execute Stored Procedures using Command Line
Set environment variables `ERROR_PROCESS`,`COMBINED_PROCESS`, `VHOST_PROCESS`, `CSV2MYSQL_PROCESS` and `USERAGENT_PROCESS`= 0:

no Stored Procedures are executed by Python Client module. Only LOAD DATA statements are executed inserting raw log data into LOAD TABLES.

Set environment variables `ERROR_PROCESS`,`COMBINED_PROCESS`, `VHOST_PROCESS`, `CSV2MYSQL_PROCESS` and `USERAGENT_PROCESS`= 2: 

5 Stored Procedures are executed by Python Client module passing the `importloadid` value to process 
ONLY files & records processed by current `processLogs function` execution. 

MySQL Stored Procedures can be run from Command Line Client or GUI Database Tool separately.
Execute Stored Procedures with second parameter 'ALL' processes files & records based on `process_status` value. Files & records 
can contain multiple `importloadid` values.
```
COLUMN process_status in LOAD DATA tables - load_access_combined, load_access_csv2mysql, load_access_vhost, load_error_default
process_status=0 - LOAD DATA tables loaded with raw log data
process_status=1 - process_error_parse or process_access_parse executed on record
process_status=2 - process_error_import or process_access_import executed on record
```
Execute Stored Procedures with second parameter `importloadid` value as a STRING processes ONLY files & records related to that `importloadid`.

Second parameter enables Python Client modules to run on multiple servers simultaneously uploading to a single MySQL Server `apache_logs` schema.

`call_processes.sql` contains execution commands for each stored procedure. Comment area has helpful functionality explanation.
![call_processes.sql in repository](./assets/call_processes.png)
(`call_processes.sql` in repository)
## Verify ServerNames using Command Line
`check_domain_columns.sql` contains SQL SELECT and UPDATE statements to check, validate and update Domain data.
Log files imported from multiple domains require a ServerName value to properly filter and report data.
![check_domain_columns.sql in repository](./assets/check_domain_columns.png)
(`check_domain_columns.sql` in repository)
## Database Normalization
Database normalization is the process of organizing data in a relational database to improve data integrity and reduce redundancy. 
Normalization ensures that data is organized in a way that makes sense for the data model and attributes, and that the database functions efficiently.

MySQL `apache_logs` schema currently has 55 Tables, 908 Columns, 188 Indexes, 72 Views, 8 Stored Procedures and 90 Functions to process Apache Access log in 4 formats 
& Apache Error log in 2 formats. Database normalization at work!

Database normalization is a critical process in database design with objectives of optimizing data storage, improving data integrity, and reducing data anomalies.
Organizing data into normalized tables greatly enhances efficiency and maintainability of a database system.
### MySQL Access Log View by Browser - 1 of 72 schema views
Current schema views are Access and Error primary attribute tables created in normalization process with simple aggregate values. 
These are primitive data presentations of the log data warehouse. ApacheLogs2MySQL is the 'EL' of the 'ELK' Stack. The Web interface 
[MySQL2ApacheECharts](https://github.com/willthefarmer/mysql-to-apache-echarts) in development is the 'K' of the 'ELK' Stack.

MySQL View - apache_logs.access_ua_browser_family_list - data from LogFormat: combined & csv2mysql
![view-access_ua_browser_family_list.png](./assets/access_ua_browser_list.png)
### MySQL Access Log View by URI
MySQL View - apache_logs.access_requri_list - data from LogFormat: combined & csv2mysql
![view-access_requri_list](./assets/access_requri_list.png)
### MySQL Error Log Views
Application imports and normalizes error log data. Some of the Error Log schema views below. Error log attribute is name of first column or first and second column.
Each attribute has an associated table in ***apache_logs*** schema. Using these views it is quick and easy to identify the origin of errors.
![error_log_apache_message_list](./assets/error_log_apache_message_list.png)
![error_log_system_message](./assets/error_log_system_message.png)
![error_log_message_list](./assets/error_log_message_list.png)
![error_processID_threadID_list](./assets/error_processID_threadID_list.png)
![error_log_apache_code_list](./assets/error_log_apache_code_list.png)
![error_log_client_list](./assets/error_log_client_list.png)
![error_log_system_code_list](./assets/error_log_system_code_list.png)
![error_log_module_list](./assets/error_log_module_list.png)
![error_log_level_list](./assets/error_log_level_list.png)
