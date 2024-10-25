# ApacheLogs2MySQL - first release is scheduled for 10/29/2024 - I've been working non-stop, around the clock on this project.  

ApacheLogs2MySQL consists of two Python Modules & one MySQL Schema designed to automate importing Apache Access & Error Log files into a normalized database for reporting & data analysis.

![view-access_requri_list](https://github.com/user-attachments/assets/7cf9ff89-a1d7-4e93-ae93-deeca87175f9)

ApacheLogs2MySQL processes the 3 standard Apache Access Logformats - vhost_combined, combined and common

This is a fast, reliable processing application with detailed event-logging and two-staged data conversation. Data manipulation can be fine tuned in second conversion stage if required for customizing LogFormats. Log-levels can be set to capture every process step, info messages and errors of the import process from log file to schema import_log table.

The logging functionality, database design and table relationship contraints produce both physical integrity and logical integrity. This enables a complete audit trail providing the ability to determine when, where and what file each record originated from.

There is no need to move log files either. Log files can be left in the folder they were imported from for later referencing. The application knows what files have been processed. This application will run with no need for user interaction.

All folder pathnames, filename patterns, logging, MySQL connection settings are in .env file for easy installation and maintenance. The folder polling Python module runs great in PM2 daemon process manager for 24/7 online processing.

Application is developed with Python 3.12, common Python modules and MySQL. Python handles polling of log file folders and executing MySQL Database LOAD DATA statements, Stored Procedures & Functions and SQL Statements. Python drives the application but MySQL does all Data Manipulation & Processing.

Application runs on Windows, Linux and MacOS. It has been tested with MySQL versions 8.0.39, 8.4.3, 9.0.0 & 9.1.0.

The processing and polling has been heavily tested on three platforms. This weekend my plan is finalizing import_log functionality. This is logging of messages, events and errors of process. I do not want to release until table structures are certain. 

Please visit https://farmfreshsoftware.com/ApacheLogs2MySQL.html for more information.

MySQL database must be configured with - local-infile=1 - add line in mysqld.cnf under [mysqld]

Apache uses the same Standard Access log formats on all 3 platforms.

LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined

LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined

LogFormat "%h %l %u %t \"%r\" %>s %O" common

Application is designed to use an Extended format in Apache configuration to get even more information from your servers.

LogFormat "\"%h\",%t,%I,%O,%S,%B,%{ms}T,%D,%^FB,%>s,\"%H\",\"%m\",\"%U\",\"%{Referer}i\",\"%{User-Agent}i\",\"%{farmwork.app}C\",%v" extended

The application also processes Error Logs with default format for threaded MPMs (Multi-Processing Modules). If you're running Apache 2.4 on any platform and ErrorLogFormat is not defined in config files this is the Error Log format.

ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i"

Database normalization is the process of organizing data in a relational database to improve data integrity and reduce redundancy. Normalization ensures that data is organized in a way that makes sense for the data model and attributes, and that the database functions efficiently.

View Data images are from 2 views in the apache_logs schema. Database normalization at work. There are 35 more schema views.

![view-access_useragent_browser_list](https://github.com/user-attachments/assets/1550daf7-e591-47c4-a70a-cb4fc5fdefd9)
