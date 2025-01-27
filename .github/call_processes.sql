/* 6 Store Procedures process Apache Access & Error Log LOAD DATA tables. LOAD DATA tables contain raw log data.
process_error_parse -  Parsing LOAD DATA into proper columns. Apache, system and log codes & messages are different formats.
process_error_import - PARSED DATA normalization into 9 error attribute tables & 6 common log attribute shared with access logs.
process_access_parse - Parsing LOAD DATA into proper columns. Access formats use %r - First line request - Contains 4 format strings.
process_access_import - PARSED DATA normalization into 9 access attribute tables & 6 common log attribute tables shared with error logs.
normalize_useragent - normalize Python parsed User Agent Data stored in access_log_userAgent TABLE into 11 userAgent attribute tables.
normalize_client - normalize Python retrieved IP Address Information stored in log_client TABLE into 6 client IP attribute tables.

Each Stored Procedure has 2 parameters. First is Access & Error LogFormats. Second parameter is importLoadID and important for processing.
- IN in_processName VARCHAR(100) - LogFormat to process.
NOTE: For normalize_useragent parameter can be any string >= 8 characters. It is for reference use only
- IN in_importLoadID VARCHAR(20) - importLoadID to process. Valid values 'ALL' or a value converted to INTEGER=importLoadID   
NOTE: if in_importLoadID='ALL' ONLY importLoadID records with import_load TABLE "completed" COLUMN NOT NULL will be processed.
This avoids interfering with Python client modules uploading files at same time as server STORED PROCEDURES executing.
 
LOAD DATA stage tables - load_access_combined, load_access_csv2mysql, load_access_vhost, load_error_default have a process_status COLUMN.
process_status=0 - LOAD DATA tables loaded with raw log data
process_status=1 - process_error_parse or process_access_parse executed on record
process_status=2 - process_error_import or process_access_import executed on record

import_file TABLE - record for every Access & Error file processed by Python processFiles. LOAD DATA tables have FOREIGN KEY (importfileid).
import_load TABLE - record for every execution of Python process. Each record contains information on LogFormat log files processed. 
import_load TABLE "completed" COLUMN - is NULL an error occurred. Refer to the import_error TABLE for error details.
import_process TABLE - record for every STORED PROCEDURE execution. Each record contains parameters and process details.
import_process TABLE "completed" COLUMN - is NULL an error occurred. Refer to the import_error TABLE for error details.
import_error TABLE - only table using ENGINE=MYISAM due to disregarding TRANSACTION ROLLBACK. Any errors in Python or MySQL recorded in table. 

Based on settings.env values of ERROR_PROCESS,COMBINED_PROCESS,VHOST_PROCESS,CSV2MYSQL_PROCESS and USERAGENT_PROCESS all 5 can be executed
by Python logs2mysql.py processLogs function OR only LOAD DATA can be executed by processLogs function & Stored Procedures executed separate.

CALL Commands execute each Stored Procedure for each Import Format. 'ALL' processes any unprocessed importLoadID(s) based on process_status. 
NOTE: Each Python 'processLogs' function execution creates a new importLoadID. Every execution has a unique importLoadID value & record.
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

CALL normalize_client('Any Process Name','ALL');



