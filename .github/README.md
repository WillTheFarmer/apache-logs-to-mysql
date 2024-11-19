# Apache Log Parser and Data Normalization Application
ApacheLogs2MySQL consists of two Python Modules & one MySQL Schema designed to automate importing Apache Access & Error Log files into a normalized database schema for reporting & data analysis.

Runs on Windows, Linux and MacOS & tested with MySQL versions 8.0.39, 8.4.3, 9.0.0 & 9.1.0.

Imports Access Logs in Apache Logformats - ***common***, ***combined*** and ***vhost_combined***. Plus the ***extended*** LogFormat below.

Imports Error Logs in default Logformat and separates Apache & System errors. See Error Log views below.

Follow `INSTALL.md` for easy MySQL database installation. Python executes all MySQL from command prompt or PM2.

## MySQL Access Log View by Browser - 1 of 50 schema views
MySQL View - apache_logs.access_log_browser_list - data from LogFormat: combined & extended
![view-access_useragent_browser_list](https://github.com/user-attachments/assets/1550daf7-e591-47c4-a70a-cb4fc5fdefd9)
## Application Description
This is a fast, reliable processing application with detailed event-logging and two-staged data conversation. Data manipulation can be fine tuned in second conversion stage if required for customizing LogFormats. Log-levels can be set to capture every process step, info messages and errors of the import process from log file to schema import_log table.

The logging functionality, database design and table relationship contraints produce both physical integrity and logical integrity. This enables a complete audit trail providing the ability to determine when, where and what file each record originated from.

There is no need to move log files either. Log files can be left in the folder they were imported from for later referencing. The application knows what files have been processed. This application will run with no need for user interaction.

All folder pathnames, filename patterns, logging, MySQL connection settings are in .env file for easy installation and maintenance. The folder polling Python module runs great in PM2 daemon process manager for 24/7 online processing.

Python handles polling of log file folders and executing MySQL Database LOAD DATA statements, Stored Procedures & Functions and SQL Statements. Python drives the application but MySQL does all Data Manipulation & Processing.

For Auditability logging of messages, events and errors of processes on client and server is extremely important. This application has both a client and server module. The client module can be run on multiple computers in different locations feeding a single server module.

Application is developed with Python 3.12, MySQL and 4 Python modules. Modules are listed with Python Package Index link, install command for each platform & GitHub Repository link.
## Required Python Modules
Python module links & install command lines for each platform. Single quotes around module name are required on macOS. The simplest option is run the command line under '2. Python Steps'. If that works you are all set. The `requirements.txt` is included in repository.
|Python Package|Windows 10 & 11|Ubuntu 24.04|macOS 15.0.1 Darwin 24.0.0|GitHub Repository|
|--------------|---------------|------------|--------------------------|-----------------|
|[PyMySQL](https://pypi.org/project/PyMySQL/)|python -m pip install PyMySQL[rsa]|sudo apt-get install python3-pymysql|python3 -m pip install 'PyMySQL[rsa]'|[PyMySQL/PyMySQL](https://github.com/PyMySQL/PyMySQL)|
|[user-agents](https://pypi.org/project/user-agents/)|pip install pyyaml ua-parser user-agents|sudo apt-get install python3-user-agents|python3 -m pip install user-agents|[selwin/python-user-agents](https://github.com/selwin/python-user-agents)|
|[watchdog](https://pypi.org/project/watchdog/)|pip install watchdog|sudo apt-get install python3-watchdog|python3 -m pip install watchdog|[gorakhargosh/watchdog](https://github.com/gorakhargosh/watchdog/tree/master)|
|[python-dotenv](https://pypi.org/project/python-dotenv/)|pip install python-dotenv|sudo apt-get install python3-dotenv|python3 -m pip install python-dotenv|[theskumar/python-dotenv](https://github.com/theskumar/python-dotenv)|
## Four Supported Access Log Formats
Apache uses same Standard Access LogFormats (***common***, ***combined***, ***vhost_combined***) on all 3 platforms.
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

Application is designed to use ***extended*** LogFormat below of 6 added to and 2 deleted (%l and %u) from vhost_combined.
```
LogFormat "%v,%p,%h,%t,%I,%O,%S,%B,%{ms}T,%D,%^FB,%>s,\"%H\",\"%m\",\"%U\",\"%q\",\"%{Referer}i\",\"%{User-Agent}i\",\"%{farmwork.app}C\"" extended
```
|Format String|Description|
|-------------|-----------|
|%v|The canonical ServerName of the server serving the request.|
|%p|The canonical port of the server serving the request.|
|%h|Remote hostname. Will log the IP address if HostnameLookups is set to Off, which is the default.|
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
|%q|The query string (prepended with a ? if a query string exists, otherwise an empty string).  Included in %r - First line of request.|
|%{Referer}i|The "Referer" (sic) HTTP request header. This gives the site that the client reports having been referred from. (This should be the page that links to or includes /apache_pb.gif).|
|%{User-Agent}i|The User-Agent HTTP request header. This is the identifying information that the client browser reports about itself.|
|%{VARNAME}C|ADDED - The contents of cookie VARNAME in request sent to server. Only version 0 cookies are fully supported. ie - session ID to relate with login tables on server.|
## Supported Error Log Format
The application processes Error Logs with default format for threaded MPMs (Multi-Processing Modules). If you're running Apache 2.4 on any platform and ErrorLogFormat is not defined in config files this is the Error Log format.
```
ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i"
```
## Installation Instructions
The steps are very important to make installation painless. Please follow in the order instructions are listed.

### 1. MySQL Steps
Before running `apachLogs2MySQL.sql` open file in your favorite editor and do a ***Find and Replace*** of the following User Account with a User Account with DBA Role on server you are installing on. This will make everything much easier. Copy below:
```
root`@`%`
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
If any issues with ***pip install*** occur use individual install commands included above.

### 3. Settings.env steps
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
### 4. Settings.env Variables
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
ERROR_LOG=2
ERROR_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\**/*error*.*
ERROR_RECURSIVE=1
ERROR_PROCESS=1
COMBINED=1
COMBINED_LOG=2
COMBINED_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\combined\\**/*access*.*
COMBINED_RECURSIVE=1
COMBINED_PROCESS=1
VHOST=1
VHOST_LOG=2
VHOST_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\vhost\\**/*access*.*
VHOST_RECURSIVE=1
VHOST_PROCESS=1
EXTENDED=1
EXTENDED_LOG=2
EXTENDED_PATH=C:\\Users\\farmf\\Documents\\apacheLogs\\extended\\**/*access*.*
EXTENDED_RECURSIVE=1
EXTENDED_PROCESS=1
USERAGENT=1
USERAGENT_LOG=2
USERAGENT_PROCESS=1
```
### 5. Run Application
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
## Database Normalization
Database normalization is the process of organizing data in a relational database to improve data integrity and reduce redundancy. Normalization ensures that data is organized in a way that makes sense for the data model and attributes, and that the database functions efficiently.

Below are View Data and Schema Object images. There are currently 47 tables, 724 columns, 110 indexes, 50 views, 5 stored procedures and 42 functions in ***apache_logs*** schema. Database normalization at work!
## MySQL Access Log View by URI
MySQL View - apache_logs.access_log_requri_list - data from LogFormat: combined & extended
![view-access_requri_list](https://github.com/user-attachments/assets/7cf9ff89-a1d7-4e93-ae93-deeca87175f9)
## MySQL Error Log Views
MySQL Error Log Views - The application imports and normalizes error log data as well. Here are some of the schema views. Error log attribute is name of first column. Each attribute has associated table in apache_logs Schema.
![Screenshot 2024-10-26 164911](https://github.com/user-attachments/assets/11094e41-9897-44ab-8c23-e8b75cb5916f)
![Screenshot 2024-10-26 164842](https://github.com/user-attachments/assets/c1fcfb1a-2c45-4525-80ce-11702b0c609a)
![Screenshot 2024-10-26 164449](https://github.com/user-attachments/assets/9bcf7ffe-c72f-43cb-8011-2cdf2978934a)
![Screenshot 2024-10-26 164517](https://github.com/user-attachments/assets/b624d139-3d9f-4184-a63c-b3c70df6d53c)
![Screenshot 2024-10-26 164645](https://github.com/user-attachments/assets/ec15619a-900d-4036-a7b4-fe610777d65d)
![Screenshot 2024-10-26 164714](https://github.com/user-attachments/assets/caaac761-730e-4ccf-8a43-0ef40be7b164)
![Screenshot 2024-10-26 164741](https://github.com/user-attachments/assets/7ab48d24-1d24-4733-ab57-e76654a28e14)
![Screenshot 2024-10-26 164805](https://github.com/user-attachments/assets/d8fae147-69f2-4995-b800-f8c8bf14308e)
![Screenshot 2024-10-26 164828](https://github.com/user-attachments/assets/485d24ea-2c34-4c01-8452-bd43e0993aab)

## MySQL Schema Objects - Tables, Stored Procedures, Functions and Views
Images of the apache_logs schema objects. Access and Error log attributes are normalized into separate entity tables. Each table is populated with unique values of the attribute. Entity Relationship Diagram will be posted soon.

![apache_logs.tables](<Screenshot 2024-11-18 025434.png>) ![apache_logs.stored_programs](<Screenshot 2024-11-18 025629.png>) ![apache_logs.views](<Screenshot 2024-11-18 025758.png>)
