/* 5 Store Procedures process Apache Access & Error Log LOAD DATA tables. LOAD DATA tables contain raw log data.
process_error_parse -  Parsing LOAD DATA into proper columns. Apache, system and log codes & messages are different formats.
process_error_import - PARSED DATA normalization into 9 error attribute tables & 6 common log attribute shared with access logs.
process_access_parse - Parsing LOAD DATA into proper columns. Access formats use %r - First line request - Contains 4 format strings.
process_access_import - PARSED DATA normalization into 9 access attribute tables & 6 common log attribute tables shared with error logs.
normalize_useragent - normalized Python parsed access_log_userAgent TABLE into 11 userAgent attribute tables.

Each Stored Procudure has 2 parameters. 
- IN in_processName VARCHAR(100) - indicates the LogFormat to process. 
NOTE: For normalize_useragent parameter can be any string >= 8 characters. It is for reference use only
- IN in_importLoadID VARCHAR(20) - indicates to importloadid to process. Valid values 'ALL' or a value converted to INTEGER=importloadid   
NOTE: if in_importLoadID='ALL' ONLY importloadID records with import_load TABLE "completed" COLUMN NOT NULL will be processed.
This avoids interfering with Python client modules uploading files at same time as server STORED PROCEDURES executing.
 
LOAD DATA stage tables - load_access_combined, load_access_csv2mysql, load_access_vhost, load_error_default have a process_status COLUMN.
process_status=0 - LOAD DATA tables loaded with raw log data
process_status=1 - process_error_parse or process_access_parse executed on record
process_status=2 - process_error_import or process_access_import executed on record

import_file TABLE - record for every Access & Error file processed by Python processFiles. LOAD DATA tables have FOREIGN KEY (importfileid).
import_load TABLE - record for every execution of Python process. Each record contains information on LogFormat log files processed. 
import_load TABLE "completed" COLUMN - is NULL an error occured. Refer to the import_error TABLE for error details.
import_process TABLE - record for every STORED PROCEDURE execution. Each record contains parameters and process details.
import_process TABLE "completed" COLUMN - is NULL an error occured. Refer to the import_error TABLE for error details.
import_error TABLE - only table using ENGINE=MYISAM due to disregarding TRANSACTION ROLLBACK. Any errors in Python or MySQL recorded in table. 

Based on settings.env values of ERROR_PROCESS,COMBINED_PROCESS,VHOST_PROCESS,CSV2MYSQL_PROCESS and USERAGENT_PROCESS all 5 can be executed
by Python apacheLogs2MySQL.py processLogs function OR only LOAD DATA can be executed by processLogs function & Stored Procedures executed separate.

Commands execute each Stored Procedure & process ALL importloadid based on process_status. Each processLogs function executed creates importloadid.
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

/* Important SQL UPDATE information to properly import, filter and report on Apache log data imported from multiple domains.  
If importing multiple domains to properly filter & report data ALL records MUST BE associated with ServerName regardless of LogFormat or ErrorLogFormat. 
Use environment variables in Python to SET server_name & server_port COLUMNS during LOAD DATA for Common, Combined and Error formats.  

Process_error_parse and process_access_parse STORED PROCEDURES will UPDATE server_name & server_port COLUMNs for formats that contain %v Format String.
After process_error_parse and process_access_parse execute and Environment Variables in Python were used both SQL statements should return NO RECORDS.
     SELECT l.server_name AS load_server_name 
       FROM apache_logs.load_access_combined l 
      WHERE l.server_name IS NULL; 

     SELECT l.server_name AS load_server_name
       FROM apache_logs.load_error_default l 
      WHERE l.server_name IS NULL; 

If SQL statements above return records UPDATES on import_file TABLE can be used after process_error_parse and process_access_parse STORED PROCEDURES.

These UPDATES must be executed before process_error_import or process_access_import STORED PROCEDURES. Below are examples based on imported log file name.
    UPDATE apache_logs.import_file SET server_name='farmfreshsoftware.com', server_port=443 WHERE server_name IS NULL AND name LIKE '%farmfreshsoftware%';
    UPDATE apache_logs.import_file SET server_name='farmwork.app', server_port=443 WHERE server_name IS NULL AND name LIKE '%farmwork%';
    UPDATE apache_logs.import_file SET server_name='ip255-255-255-255.us-east.com', server_port=443 WHERE server_name IS NULL AND name LIKE '%error%';

Before executing process_error_import or process_access_import STORED PROCEDURES both SQL statements should return NO RECORDS.
     SELECT l.server_name AS load_server_name,
            f.server_name AS file_server_name 
       FROM apache_logs.load_access_combined l 
 INNER JOIN apache_logs.import_file f 
         ON l.importfileid=f.id 
      WHERE l.server_name IS NULL 
        AND f.server_name IS NULL; 

     SELECT l.server_name AS load_server_name,
            f.server_name AS file_server_name 
       FROM apache_logs.load_error_default l 
 INNER JOIN apache_logs.import_file f 
         ON l.importfileid=f.id 
      WHERE l.server_name IS NULL 
        AND f.server_name IS NULL; 
 
After executing process_error_import and process_access_import STORED PROCEDURES both SELECT statements should return NO RECORDS. 
   SELECT * FROM apache_logs.access_log WHERE servernameid IS NULL;
   SELECT * FROM apache_logs.error_log WHERE servernameid IS NULL;
*/
