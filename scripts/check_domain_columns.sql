/* Important SQL UPDATE information to properly import, filter and report on HTTP log data imported from multiple domains.  
If importing multiple domains to filter & report data ALL records MUST BE associated with Server regardless of LogFormat or ErrorLogFormat. 
Use environment variables in Python to SET server_name & server_port COLUMNS during LOAD DATA for Common, Combined and Error formats.  

Process_error_parse & process_access_parse STORED PROCEDURES UPDATE server_name & server_port COLUMNs for formats that contain %v Format String.
After process_error_parse & process_access_parse execute AND Environment Variables in Python were used both SQL statements should return NO RECORDS.
*/
SELECT l.server_name AS load_server_name,
       l.server_port AS load_server_port
  FROM load_access_combined l 
 WHERE l.server_name IS NULL; 

SELECT l.server_name AS load_server_name,
       l.server_port AS load_server_port
  FROM load_error_apache l 
 WHERE l.server_name IS NULL; 

/* If SQL statements above return records.
UPDATES on import_file TABLE can be used after process_error_parse and process_access_parse STORED PROCEDURES.
UPDATES must be executed before process_error_import or process_access_import STORED PROCEDURES. Below are examples based on imported log file name.
*/
-- UPDATE import_file SET server_name='farmfreshsoftware.com', server_port=443 WHERE server_name IS NULL AND name LIKE '%farmfreshsoftware%';
-- UPDATE import_file SET server_name='farmwork.app', server_port=443 WHERE server_name IS NULL AND name LIKE '%farmwork%';
-- UPDATE import_file SET server_name='ip255-255-255-255.us-east.com', server_port=443 WHERE server_name IS NULL AND name LIKE '%error%';
/*
Before executing process_error_import or process_access_import STORED PROCEDURES both SQL statements should return NO RECORDS.
*/
     SELECT l.server_name AS load_server_name,
            l.server_port AS load_server_port,
            f.server_name AS file_server_name, 
            f.server_port AS file_server_port
       FROM load_access_combined l 
 INNER JOIN import_file f 
         ON l.importfileid=f.id 
      WHERE l.server_name IS NULL 
        AND f.server_name IS NULL; 

     SELECT l.server_name AS load_server_name,
            l.server_port AS load_server_port,
            f.server_name AS file_server_name, 
            f.server_port AS file_server_port
       FROM load_error_apache l 
 INNER JOIN import_file f 
         ON l.importfileid=f.id 
      WHERE l.server_name IS NULL 
        AND f.server_name IS NULL; 
/* 
After executing process_error_import and process_access_import STORED PROCEDURES both SELECT statements should return NO RECORDS. 
*/
     SELECT f.name,a.* 
       FROM access_log a
 INNER JOIN import_file f 
         ON a.importfileid=f.id 
      WHERE a.serverid IS NULL;

     SELECT f.name,e.* 
       FROM error_log e
 INNER JOIN import_file f 
         ON e.importfileid=f.id 
      WHERE e.serverid IS NULL;
