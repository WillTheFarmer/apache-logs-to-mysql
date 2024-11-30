- version 1.0.0 - 10/31/2024
- version 1.1.0 - 11/18/2024 - major changes
- version 1.1.1 - 11/20/2024 - keyword replacement
- version 2.0.0 - 11/30/2024 - backward incompatible
- [1.0.1] apache_logs.error_systemCodeID corrected line - INTO logsystemCode to INTO logsystemCodeID
- [1.0.1] remove debugging - SELECT statement from apache_logs.process_access_import, process_error_import & normalize_useragent.
- [1.0.1] remove whitespace and commented out old code on all stored programs
- [1.0.1] set all table AUTO_INCREMENT=1. All future version releases will be the same - AUTO_INCREMENT=1.
- [1.1.0] rename LOAD DATA TABLES, normalized access_log_useragent TABLE into 11 TABLES, added 13 VIEWS.
- [1.1.0] resize LOAD DATA COLUMNS, added req_query COLUMN and seperated query strings from req_uri COLUMN.
- [1.1.0] add access_log_reqquery TABLE, renamed access_log_session TABLE to access_log_cookie.
- [1.1.0] add UPDATE TRIM statements for apachemessage COLUMNS.
- [1.1.1] change word 'extended' to 'csv2mysql'
- [2.0.0] fix the double backslash requirement on Windows platform for file paths. 
- [2.0.0] move all stage table parsing from Python to MySQL Stored Procedures - process_access_parse & process_error_parse
- [2.0.0] process_access_parse, process_access_import, process_error_parse, process_error_import have importloadid parameter.
- [2.0.0] revamp parse & import processes and now provide 2 processing methods - by process_status and new importloadid.
- [2.0.0] relate and control each client load, parsing and importing separately. Enable multiple upload clients simultaneously.  
- [2.0.0] add or rename of COLUMNS in import_load, import_process, import_file. populate import_load and import_process with meaningful information.
- [2.0.0] add compound indexes LOAD TABLES importfileid and process_status to improve Stored Procedures execution times when over 700,000 records.
- [2.0.0] add SET importfileid COLUMN to LOAD DATA statement and remove UPDATE importfileid statement in Python. 
- [2.0.0] create ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i , %v" to add %v-canonical ServerName.
- [2.0.0] add ServerName & ServerPort on import Combined & Error logs stage tables. Option allow adding domains to logs.
- [2.0.0] add ERROR_SERVERNAME,ERROR_SERVERPORT,COMBINED_SERVERNAME & COMBINED_SERVERPORT variables to settings.env. 
- [2.0.0] add SET servername & serverport COLUMN values to LOAD DATA statements.
- [2.0.0] create log_referer, log_remotehost, log_servername, log_serverport TABLES to assoicate Access and Error logs.
- [2.0.0] add server_name & server_port COLUMNS to import_file TABLE. Provides second option to update Apache logs without %v. 
- [2.0.0] modify process_access_import & process_error_import to populate empty server_name & server_port with ServerName & ServerPort from import_file TABLE. 
- [2.0.0] add WATCH_LOG to setting Log Level in watch4logs.py. 0=no messages, 1=message when files found, 2=message when checking for files & files found
- [2.0.0] add class bcolors to place RED BACKGROUND on all ERROR - messsages
- [2.0.0] add file - mysql_user_and_grants.sql - MySQL USER and GRANTS file for CREATE USER apache_upload for Python module
- [2.0.0] add Start and End DATETIME to processLogs Function. Already had duration times.
- [2.0.0] add file - call_processes.sql - description and CALL command lines for 5 Stored Procedures
- [2.0.0] add file - CHANGLOG.md - for single place to list all code and database changes