/* 5 Store Procedures process Apache Access & Error Log LOAD DATA tables. LOAD DATA tables contain raw log data.
process_error_parse -  Parsing into proper columns. Apache, system and log messages are different formats.
process_error_import - normalization of parsed LOAD DATA table into 10 access tables & 3 comon log tables shared with error logs.
process_access_parse - Parsing into proper columns. Apache Access formats use %r - First line of request - Contains 4 format strings.
process_access_import - normalization of parsed LOAD DATA table into 9 error tables & 3 comon log tables shared with error logs.
normalize_useragent - normalized Python parsed userAgent TABLE into 11 tables
Each Stored Procudure has 2 parameters. 
- IN in_processName VARCHAR(100) - This indicates the LogFormat to process. 
NOTE: For normalize_useragent parameter can be any string >= 8 characters
- IN in_importLoadID VARCHAR(20) - This indicates to importloadid to process. Valid values 'ALL' or a value converted to INTEGER=importloadid   
NOTE: if in_importLoadID='ALL' ONLY importloadID records with import_load TABLE "completed" COLUMN NOT NULL will be processed. This is to avoid
interfering with Python client modules uploading files at same time as server STORED PROCEDURES executing.

import_file TABLE - record of every access & error log file processed by Python processFiles function. Each LOAD DATA table has importfileid COLUMN.
import_load TABLE  - record for every execution of Python process. Each record contains information on LogFormat log files processed. 
import_process TABLE - Each execution of each inserts a record into import_process TABLE with paremeters and process details.
import_process TABLE completed COLUMN - is NULL an error occured. Refer to the import_error TABLE for error details.
import_error TABLE - only table using ENGINE=MYISAM due to disregarding TRANSACTION ROLLBACK. Any errors in Python or MySQL is recorded in table. 

Based on settings.env values of ERROR_PROCESS,COMBINED_PROCESS,VHOST_PROCESS,CSV2MYSQL_PROCESS and USERAGENT_PROCESS variables all 5 can be executed
by Python apacheLogs2MySQL.py processLogs function Or only LOAD DATA can be executed by processLogs function and Stored Procedures executed at Server.

LOAD DATA stage tables - load_access_combined, load_access_csv2mysql, load_access_vhost, load_error_default have a process_status COLUMN.
process_status=0 - LOAD DATA tables loaded with raw log data
process_status=1 - process_error_parse or process_access_parse executed on record
process_status=2 - process_error_import or process_access_import executed on record

If importing multiple domains check before executing process_error_import or process_access_import STORED PROCEDURES. 
In order to filter and report data properly this SELECT statement should return NO RECORDS. 
 - SELECT * FROM apache_logs.import_file WHERE server_name IS NULL;

import_file TABLE UPDATES should execute after _parse STORED PROCEDURES if importing multiple formats with servername (%v). Parsing will fill-in columns.
if not using environment variables to SET ServerName and ServerPort in Python and no formats contain %v Format String UPDATES can be executed before Parsing.
import_file TABLE UPDATES must be executed before _import STORED PROCEDURES. Below are examples of possible UPDATE STATEMENTS based on imported log file name.
 - UPDATE apache_logs.import_file SET server_name='farmfreshsoftware.com', server_port=443 WHERE server_name IS NULL AND name LIKE '%farmfreshsoftware%';
 - UPDATE apache_logs.import_file SET server_name='farmwork.app', server_port=443 WHERE server_name IS NULL AND name LIKE '%farmwork%';
 - UPDATE apache_logs.import_file SET server_name='ip255-255-255-255.us-east.com', server_port=443 WHERE server_name IS NULL AND name LIKE '%error%';

Commands below execute each Stored Procudure and process ALL importloadid based on process_status. Each VPS creates importloadid each time executed.
*/
USE apache_logs;

CALL process_error_parse('default','ALL'); 
CALL process_error_import('default','ALL'); 

CALL process_access_parse('combined','ALL'); 
CALL process_access_import('combined','ALL'); 

CALL process_access_parse('vhost','ALL'); 
CALL process_access_import('vhost','ALL'); 

CALL process_access_parse('csv2mysql','ALL'); 
CALL process_access_import('csv2mysql','ALL'); 

CALL normalize_useragent('Any Process Name','ALL');