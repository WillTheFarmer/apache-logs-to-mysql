-- Python MySQL USER for all client module connections
CREATE USER 'apache_upload'@'localhost' IDENTIFIED BY 'password';
-- Python module CALLS 5 Stored Procedures for log processing & 1 Stored Procedure for error logging
GRANT EXECUTE ON PROCEDURE apache_logs.process_access_parse TO 'apache_upload'@'localhost';
GRANT EXECUTE ON PROCEDURE apache_logs.process_access_import TO 'apache_upload'@'localhost';
GRANT EXECUTE ON PROCEDURE apache_logs.process_error_parse TO 'apache_upload'@'localhost';
GRANT EXECUTE ON PROCEDURE apache_logs.process_error_import TO 'apache_upload'@'localhost';
GRANT EXECUTE ON PROCEDURE apache_logs.normalize_useragent TO 'apache_upload'@'localhost';
GRANT EXECUTE ON PROCEDURE apache_logs.errorLoad TO 'apache_upload'@'localhost';
-- Python module SELECTS 4 Stored Functions for log processing
GRANT EXECUTE ON FUNCTION apache_logs.importClientID TO 'apache_upload'@'localhost';
GRANT EXECUTE ON FUNCTION apache_logs.importLoadID TO 'apache_upload'@'localhost';
GRANT EXECUTE ON FUNCTION apache_logs.importFileExists TO 'apache_upload'@'localhost';
GRANT EXECUTE ON FUNCTION apache_logs.importFileID TO 'apache_upload'@'localhost';
-- Python module INSERTS into 4 TABLES executing LOAD DATA LOCAL INFILE for log processing
GRANT INSERT ON apache_logs.load_access_combined TO 'apache_upload'@'localhost';
GRANT INSERT ON apache_logs.load_access_csv2mysql TO 'apache_upload'@'localhost';
GRANT INSERT ON apache_logs.load_access_vhost TO 'apache_upload'@'localhost';
GRANT INSERT ON apache_logs.load_error_default TO 'apache_upload'@'localhost';
-- Python module issues SELECT and UPDATE statements on only 2 TABLES due to converting parameters.
-- Only reason TABLE direct eccess is number of parameters required for Stored Procedure.
GRANT SELECT,UPDATE ON apache_logs.access_log_useragent TO 'apache_upload'@'localhost';
GRANT SELECT,UPDATE ON apache_logs.import_load TO 'apache_upload'@'localhost';
