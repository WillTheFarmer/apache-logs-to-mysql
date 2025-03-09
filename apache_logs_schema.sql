-- # Licensed under the Apache License, Version 2.0 (the "License");
-- # you may not use this file except in compliance with the License.
-- # You may obtain a copy of the License at
-- #
-- #     http://www.apache.org/licenses/LICENSE-2.0
-- #
-- # Unless required by applicable law or agreed to in writing, software
-- # distributed under the License is distributed on an "AS IS" BASIS,
-- # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- # See the License for the specific language governing permissions and
-- # limitations under the License.
-- #
-- # version 3.3.0 - 03/09/2025 - process_access_import & process_error_import - replace l.importfileid with DISTINCT(l.importfileid) - see changelog
-- #
-- # Copyright 2024-2025 Will Raymond <farmfreshsoftware@gmail.com>
-- #
-- # CHANGELOG.md in repository - https://github.com/WillTheFarmer/apache-logs-to-mysql
-- #
-- file: apache_logs_schema.sql - requires minimum versions MySQL 8.0.41 or MariaDB 10.5.26
-- synopsis: Data Definition (DDL) & Data Manipulation (DML) for MySQL & MariaDB schema apache_logs for ApacheLogs2MySQL
-- author: Will Raymond <farmfreshsoftware@gmail.com>
-- # Script generated from 27 files of database object groups designed to run independently -- # comments at start each file
-- drop schema --------------------------------------------------------
DROP SCHEMA IF EXISTS `apache_logs`;
-- create schema --------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `apache_logs`;
USE `apache_logs`;
-- # Tables associated with Access Logs below
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_access_csv2mysql`;
-- create table ---------------------------------------------------------
-- LogFormat "%v,%p,%h,%t,%I,%O,%S,%B,%{ms}T,%D,%^FB,%>s,\"%H\",\"%m\",\"%U\",\"%q\",\"%{Referer}i\",\"%{User-Agent}i\",\"%{farmwork.app}C\"" csv2mysql
CREATE TABLE `load_access_csv2mysql` (
    server_name VARCHAR(253) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name, including dots: e.g. www.example.com = 15 characters.',
    server_port INT DEFAULT NULL,
    remote_host VARCHAR(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
    remote_logname VARCHAR(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
    remote_user VARCHAR(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
    log_time VARCHAR(28) DEFAULT NULL,
    bytes_received INT DEFAULT NULL,
    bytes_sent INT DEFAULT NULL,
    bytes_transferred INT DEFAULT NULL,
    reqtime_milli INT DEFAULT NULL,
    reqtime_micro INT DEFAULT NULL,
    reqdelay_milli INT DEFAULT NULL,
    req_bytes INT DEFAULT NULL,
    req_status INT DEFAULT NULL,
    req_protocol VARCHAR(30) DEFAULT NULL,
    req_method VARCHAR(50) DEFAULT NULL,
    req_uri VARCHAR(2000) DEFAULT NULL COMMENT 'URLs under 2000 characters work in any combination of client and server software and search engines.',
    req_query VARCHAR(2000) DEFAULT NULL COMMENT 'URLs under 2000 characters work in any combination of client and server software and search engines.',
    log_referer VARCHAR(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
    log_useragent VARCHAR(2000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
    log_cookie VARCHAR(400) DEFAULT NULL COMMENT 'Use to store any Cookie VARNAME. ie - session ID in application cookie to relate with login tables on server.',
    request_log_id VARCHAR(50) DEFAULT NULL COMMENT 'The request log ID from the error log (or - if nothing has been logged to the error log for this request). Look for the matching error log line to see what request caused what error.',
    load_error VARCHAR(10) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    importfileid INT DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for LOAD DATA command for LogFormat csv2mysql to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_access_combined`;
-- create table ---------------------------------------------------------
-- LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
-- LogFormat "%h %l %u %t \"%r\" %>s %O" common
CREATE TABLE `load_access_combined` (
    remote_host VARCHAR(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
    remote_logname VARCHAR(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
    remote_user VARCHAR(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
    log_time_a VARCHAR(21) DEFAULT NULL COMMENT 'due to MySQL LOAD DATA LOCAL INFILE limitations can not have 2 OPTIONALLY ENCLOSED BY "" and []. It is easier with 2 columns for this data',
    log_time_b VARCHAR(6) DEFAULT NULL COMMENT 'to simplify import and use MySQL LOAD DATA LOCAL INFILE. I have python script to import standard combined but this keeps it all in MySQL',
	  first_line_request VARCHAR(4000) DEFAULT NULL COMMENT 'contains req_method, req_uri, req_query, req_protocol',
    req_status INT DEFAULT NULL,
    req_bytes INT DEFAULT NULL,
    log_referer VARCHAR(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
    log_useragent VARCHAR(2000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
    load_error VARCHAR(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    log_time VARCHAR(28) DEFAULT NULL,
    req_protocol VARCHAR(30) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_method VARCHAR(50) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_uri VARCHAR(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
    req_query VARCHAR(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
    server_name VARCHAR(253) DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate Server for multiple domains import. Must be poulated before import process.',
    server_port INT DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate ServerPort for multiple domains import. Must be poulated before import process.',
    importfileid INT DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for LOAD DATA command for LogFormat combined and common to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_access_vhost`;
-- create table ---------------------------------------------------------
-- LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
CREATE TABLE `load_access_vhost` (
    log_server VARCHAR(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name, including dots: e.g. www.example.com = 15 characters. plus : plus 6 for port',
    remote_host VARCHAR(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
    remote_logname VARCHAR(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
    remote_user VARCHAR(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
    log_time_a VARCHAR(21) DEFAULT NULL COMMENT 'due to MySQL LOAD DATA LOCAL INFILE limitations can not have 2 OPTIONALLY ENCLOSED BY "" and []. It is easier with 2 columns for this data',
    log_time_b VARCHAR(6) DEFAULT NULL COMMENT 'to simplify import and use MySQL LOAD DATA LOCAL INFILE. I have python script to import standard combined but this keeps it all in MySQL',
	  first_line_request VARCHAR(4000) DEFAULT NULL COMMENT 'contains req_method, req_uri, req_query, req_protocol',
    req_status INT DEFAULT NULL,
    req_bytes INT DEFAULT NULL,
    log_referer VARCHAR(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
    log_useragent VARCHAR(2000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
    load_error VARCHAR(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    log_time VARCHAR(28) DEFAULT NULL,
    server_name VARCHAR(253) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name, including dots: e.g. www.example.com = 15 characters.',
    server_port INT DEFAULT NULL,
    req_protocol VARCHAR(30) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_method VARCHAR(50) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_uri VARCHAR(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
    req_query VARCHAR(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
    importfileid INT DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for LOAD DATA command for LogFormat vhost to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_reqstatus`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_reqstatus` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_reqprotocol`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_reqprotocol` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_reqmethod`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_reqmethod` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_requri`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_requri` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(2000) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_reqquery`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_reqquery` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(2000) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_remotelogname`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_remotelogname` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_remoteuser`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_remoteuser` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_useragent`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_useragent` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(2000) NOT NULL,
    ua VARCHAR(300) DEFAULT NULL,
    ua_browser VARCHAR(300) DEFAULT NULL,
    ua_browser_family VARCHAR(300) DEFAULT NULL,
    ua_browser_version VARCHAR(300) DEFAULT NULL,
    ua_device VARCHAR(300) DEFAULT NULL,
    ua_device_family VARCHAR(300) DEFAULT NULL,
    ua_device_brand VARCHAR(300) DEFAULT NULL,
    ua_device_model VARCHAR(300) DEFAULT NULL,
    ua_os VARCHAR(300) DEFAULT NULL,
    ua_os_family VARCHAR(300) DEFAULT NULL,
    ua_os_version VARCHAR(300) DEFAULT NULL,
    uaid INT DEFAULT NULL,
    uabrowserid INT DEFAULT NULL,
    uabrowserfamilyid INT DEFAULT NULL,
    uabrowserversionid INT DEFAULT NULL,
    uadeviceid INT DEFAULT NULL,
    uadevicefamilyid INT DEFAULT NULL,
    uadevicebrandid INT DEFAULT NULL,
    uadevicemodelid INT DEFAULT NULL,
    uaosid INT DEFAULT NULL,
    uaosfamilyid INT DEFAULT NULL,
    uaosversionid INT DEFAULT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_browser`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_browser` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_browser_family`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_browser_family` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_browser_version`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_browser_version` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_device`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_device` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_device_family`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_device_family` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_device_brand`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_device_brand` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_device_model`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_device_model` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_os`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_os` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_os_family`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_os_family` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_os_version`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_os_version` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_cookie`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_cookie` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(400) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    logged DATETIME NOT NULL,
    serverid INT DEFAULT NULL COMMENT '%v	The canonical Server of the server serving the request. Access & Error shared normalization table - log_server',
    serverportid INT DEFAULT NULL COMMENT '%p	The canonical port of the server serving the request. Access & Error shared normalization table - log_serverport',
    clientid INT DEFAULT NULL COMMENT 'This is %h - Remote hostname (default) for Access Log or %a - Client IP address and port of the request for Error and Access logs.',
    clientportid INT DEFAULT NULL COMMENT 'a% - Client IP address and port of the request - Default for Error logs and can be used in Access Log LogFormat. Port value is derived from it.',
    refererid INT DEFAULT NULL COMMENT '%{Referer}i - Access & Error shared normalization table - log_referer',
    requestlogid INT DEFAULT NULL COMMENT '%L	Log ID of the request - Access & Error shared normalization table - log_requestlogid',
    bytes_received INT NOT NULL,
    bytes_sent INT NOT NULL,
    bytes_transferred INT NOT NULL,
    reqtime_milli INT NOT NULL,
    reqtime_micro INT NOT NULL,
    reqdelay_milli INT NOT NULL,
    reqbytes INT NOT NULL,
    reqstatusid INT DEFAULT NULL,
    reqprotocolid INT DEFAULT NULL,
    reqmethodid INT DEFAULT NULL,
    requriid INT DEFAULT NULL,
    reqqueryid INT DEFAULT NULL,
    remoteuserid INT DEFAULT NULL,
    remotelognameid INT DEFAULT NULL,
    cookieid INT DEFAULT NULL,
    useragentid INT DEFAULT NULL,
    importfileid INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is core table for access logs and contains foreign keys to relate to log attribute tables.';
-- # Tables associated with Error Logs below
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_error_default`;
-- create table ---------------------------------------------------------
CREATE TABLE `load_error_default` (
    log_time VARCHAR(50) DEFAULT NULL,
    log_mod_level VARCHAR(200) DEFAULT NULL,
    log_processid_threadid VARCHAR(200) DEFAULT NULL,
    log_parse1 VARCHAR(2500) DEFAULT NULL,
    log_parse2 VARCHAR(2500) DEFAULT NULL,
    log_message_nocode VARCHAR(1000) DEFAULT NULL,
    load_error VARCHAR(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    logtime DATETIME DEFAULT NULL,
    loglevel VARCHAR(100) DEFAULT NULL,
    module VARCHAR(200) DEFAULT NULL,
    processid VARCHAR(100) DEFAULT NULL,
    threadid VARCHAR(100) DEFAULT NULL,
    apachecode VARCHAR(200) DEFAULT NULL,
    apachemessage VARCHAR(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    systemcode VARCHAR(200) DEFAULT NULL,
    systemmessage VARCHAR(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    logmessage VARCHAR(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    referer VARCHAR(1060) DEFAULT NULL COMMENT '750 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    client_name VARCHAR(253) DEFAULT NULL COMMENT 'Column to normalize Access & Error attributes with different names. From Error Log Format %a - Client IP (address) and port of the request.',
    client_port INT DEFAULT NULL COMMENT 'Column to normalize Access & Error attributes with different names. From Error Log Format %a - Client IP address and (port) of the request.',
    server_name VARCHAR(253) DEFAULT NULL COMMENT 'Error logs. Added to populate Server for multiple domains import. Must be poulated before import process.',
    server_port INT DEFAULT NULL COMMENT 'Error logs. Added to populate ServerPort for multiple domains import. Must be poulated before import process.',
    request_log_id VARCHAR(50) DEFAULT NULL COMMENT 'Log ID of the request',
    importfileid INT DEFAULT NULL COMMENT 'FOREIGN KEY used in import process to indicate file record extracted from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table used for LOAD DATA command to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_module`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_module` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_level`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_level` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_processid`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_processid` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_threadid`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_threadid` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_apachecode`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_apachecode` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_apachemessage`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_apachemessage` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_systemcode`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_systemcode` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_systemmessage`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_systemmessage` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_message`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_message` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    logged DATETIME NOT NULL,
    serverid INT DEFAULT NULL COMMENT '%v	The canonical Server of the server serving the request. Access & Error shared normalization table - log_server',
    serverportid INT DEFAULT NULL COMMENT '%p	The canonical port of the server serving the request. Access & Error shared normalization table - log_serverport',
    clientid INT DEFAULT NULL COMMENT 'This is %h - Remote hostname (default) for Access Log or %a - Client IP address and port of the request for Error and Access logs.',
    clientportid INT DEFAULT NULL COMMENT 'a% - Client IP address and port of the request - Default for Error logs and can be used in Access Log LogFormat. Port value is derived from it.',
    refererid INT DEFAULT NULL COMMENT '%{Referer}i - Access & Error shared normalization table - log_referer',
    requestlogid INT DEFAULT NULL COMMENT '%L	Log ID of the request - Access & Error shared normalization table - log_requestlogid',
    loglevelid INT DEFAULT NULL,
    moduleid INT DEFAULT NULL,
    processid INT DEFAULT NULL,
    threadid INT DEFAULT NULL,
    apachecodeid INT DEFAULT NULL,
    apachemessageid INT DEFAULT NULL,
    systemcodeid INT DEFAULT NULL,
    systemmessageid INT DEFAULT NULL,
    logmessageid INT DEFAULT NULL,
    importfileid INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- # Tables associated with Import Process below
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_device`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_device` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  deviceid VARCHAR(150) NOT NULL,
  platformNode VARCHAR(200) NOT NULL,
  platformSystem VARCHAR(100) NOT NULL,
  platformMachine VARCHAR(100) NOT NULL,
  platformProcessor VARCHAR(200) NOT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table tracks unique Windows, Linux and Mac devices loading logs to server application.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_client`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_client` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  importdeviceid INT NOT NULL,
  ipaddress VARCHAR(50) NOT NULL,
  login VARCHAR(200) NOT NULL,
  expandUser VARCHAR(200) NOT NULL,
  platformRelease VARCHAR(100) NOT NULL,
  platformVersion VARCHAR(175) NOT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table tracks network, OS release, logon and IP address information. It is important to know who is loading logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_load`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_load` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  importclientid INT NOT NULL,
  errorFilesFound INT DEFAULT NULL,
  errorFilesLoaded INT DEFAULT NULL,
  errorRecordsLoaded INT DEFAULT NULL,
  errorParseCalled TINYINT DEFAULT NULL,
  errorImportCalled TINYINT DEFAULT NULL,
  errorSeconds INT DEFAULT NULL,
  combinedFilesFound INT DEFAULT NULL,
  combinedFilesLoaded INT DEFAULT NULL,
  combinedRecordsLoaded INT DEFAULT NULL,
  combinedParseCalled TINYINT DEFAULT NULL,
  combinedImportCalled TINYINT DEFAULT NULL,
  combinedSeconds INT DEFAULT NULL,
  vhostFilesFound INT DEFAULT NULL,
  vhostFilesLoaded INT DEFAULT NULL,
  vhostRecordsLoaded INT DEFAULT NULL,
  vhostParseCalled TINYINT DEFAULT NULL,
  vhostImportCalled TINYINT DEFAULT NULL,
  vhostSeconds INT DEFAULT NULL,
  csv2mysqlFilesFound INT DEFAULT NULL,
  csv2mysqlFilesLoaded INT DEFAULT NULL,
  csv2mysqlRecordsLoaded INT DEFAULT NULL,
  csv2mysqlParseCalled TINYINT DEFAULT NULL,
  csv2mysqlImportCalled TINYINT DEFAULT NULL,
  csv2mysqlSeconds INT DEFAULT NULL,
  userAgentRecordsParsed INT DEFAULT NULL,
  userAgentNormalizeCalled TINYINT DEFAULT NULL,
  userAgentSeconds INT DEFAULT NULL,
  ipAddressRecordsParsed INT DEFAULT NULL,
  ipAddressNormalizeCalled TINYINT DEFAULT NULL,
  ipAddressSeconds INT DEFAULT NULL,
  errorOccurred INT DEFAULT NULL,
  processSeconds INT DEFAULT NULL,
  started DATETIME NOT NULL DEFAULT NOW(),
  completed DATETIME DEFAULT NULL,
  comments VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table has record for every time the Python processLogs is executed. The has totals for each type and file formats were imported.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_server`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_server` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  dbuser VARCHAR(255) NOT NULL,
  dbhost VARCHAR(255) NOT NULL,
  dbversion VARCHAR(55) NOT NULL,
  dbsystem VARCHAR(55) NOT NULL,
  dbmachine VARCHAR(55) NOT NULL,
  dbcomment VARCHAR(75) NOT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table for keeping track of log processing servers and login information.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_process`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_process` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  importserverid INT NOT NULL,
  importloadid INT DEFAULT NULL,
  type VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  records INT DEFAULT NULL,
  files INT DEFAULT NULL,
  loads INT DEFAULT NULL,
  errorOccurred INT DEFAULT NULL,
  processSeconds INT DEFAULT NULL,
  started DATETIME NOT NULL DEFAULT NOW(),
  completed DATETIME DEFAULT NULL,
  comments VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table has record for every MySQL Stored Procedure import execution. If completed column is NULL the process failed. Look in import_error table for error details.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_file`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_file` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(300) NOT NULL,
  importdeviceid INT NOT NULL,
  importloadid INT NOT NULL,
  parseprocessid INT DEFAULT NULL,
  importprocessid INT DEFAULT NULL,
  filesize BIGINT NOT NULL,
  filecreated DATETIME NOT NULL,
  filemodified DATETIME NOT NULL,
  server_name VARCHAR(253) DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate Server for multiple domains import. Must be populated before import process.',
  server_port INT DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate ServerPort for multiple domains import. Must be populated before import process.',
  importformatid INT NOT NULL COMMENT 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost',
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table contains all access and error log files loaded and processed. Created, modified and size of each file at time of loading is captured for auditability. Each file processed by Server Application must exist in this table.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_format`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_format` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  comments VARCHAR(100) DEFAULT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table contains import file formats imported by application. These values are inserted in schema DDL script. This table is only added for reporting purposes.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_error`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_error` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  importloadid INT DEFAULT NULL,
  importprocessid INT DEFAULT NULL,
  module VARCHAR(300) NULL,
  mysql_errno SMALLINT UNSIGNED NULL,
  message_text VARCHAR(1000) NULL,
  returned_sqlstate VARCHAR(250) NULL,
  schema_name VARCHAR(64) NULL,
  catalog_name VARCHAR(64) NULL,
  comments VARCHAR(350) NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='Application Error log. Any errors that occur in MySQL processes will be here. This is a MyISAM engine table to avoid TRANSACTION ROLLBACKS. Always look in this table for problems!';
-- # Tables associated with both Access and Error Logs below
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_referer`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_referer` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(750) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_server`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_server` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(253) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_serverport`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_serverport` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(253) NOT NULL,
    country_code VARCHAR(20) DEFAULT NULL,
    country VARCHAR(150) DEFAULT NULL,
    subdivision VARCHAR(250) DEFAULT NULL,
    city VARCHAR(250) DEFAULT NULL,
    latitude decimal(10,8) DEFAULT NULL,
    longitude decimal(11,8) DEFAULT NULL,
    organization varchar(500) DEFAULT NULL,
    network varchar(100) DEFAULT NULL,
    countryid INT DEFAULT NULL,
    subdivisionid INT DEFAULT NULL,
    cityid INT DEFAULT NULL,
    coordinateid INT DEFAULT NULL,
    organizationid INT DEFAULT NULL,
    networkid INT DEFAULT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_city`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_city` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_coordinate`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_coordinate` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    latitude decimal(10,8) DEFAULT NULL,
    longitude decimal(11,8) DEFAULT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_country`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_country` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(150) NOT NULL,
    country_code VARCHAR(20) DEFAULT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_network`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_network` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_organization`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_organization` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_subdivision`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_subdivision` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_clientport`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_clientport` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_requestlogid`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_requestlogid` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- # Functions associated with Access Log Normalization below
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqProtocolID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqProtocolID`
    (in_ReqProtocol VARCHAR(20))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqProtocol_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqProtocolID';
    SELECT id
      INTO reqProtocol_ID
      FROM apache_logs.access_log_reqprotocol
     WHERE name = in_ReqProtocol;
    IF reqProtocol_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_reqprotocol (name) VALUES (in_ReqProtocol);
        SET reqProtocol_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqProtocol_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqMethodID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqMethodID`
    (in_ReqMethod VARCHAR(40))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqMethod_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqMethodID';
    SELECT id
      INTO reqMethod_ID
      FROM apache_logs.access_log_reqmethod
     WHERE name = in_ReqMethod;
    IF reqMethod_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_reqmethod (name) VALUES (in_ReqMethod);
        SET reqMethod_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqMethod_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqStatusID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqStatusID`
    (in_ReqStatus INTEGER)
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqStatus_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqStatusID';
    SELECT id
      INTO reqStatus_ID
      FROM apache_logs.access_log_reqstatus
     WHERE name = in_ReqStatus;
    IF reqStatus_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_reqstatus (name) VALUES (in_ReqStatus);
        SET reqStatus_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqStatus_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqUriID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqUriID`
    (in_ReqUri VARCHAR(2000))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqUri_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqUriID';
    SELECT id
      INTO reqUri_ID
      FROM apache_logs.access_log_requri
     WHERE name = in_ReqUri;
    IF reqUri_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_requri (name) VALUES (in_ReqUri);
        SET reqUri_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqUri_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqQueryID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqQueryID`
    (in_ReqQuery VARCHAR(2000))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqQuery_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqQueryID';
    SELECT id
      INTO reqQuery_ID
      FROM apache_logs.access_log_reqquery
     WHERE name = in_ReqQuery;
    IF reqQuery_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_reqquery (name) VALUES (in_ReqQuery);
        SET reqQuery_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqQuery_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_remoteLogNameID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_remoteLogNameID`
    (in_RemoteLogName VARCHAR(150))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE remoteLogName_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_remoteLogNameID';
    SELECT id
      INTO remoteLogName_ID
      FROM apache_logs.access_log_remotelogname
     WHERE name = in_RemoteLogName;
    IF remoteLogName_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_remotelogname (name) VALUES (in_RemoteLogName);
        SET remoteLogName_ID = LAST_INSERT_ID();
    END IF;
    RETURN remoteLogName_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_remoteUserID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_remoteUserID`
    (in_RemoteUser VARCHAR(150))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE remoteUser_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_remoteUserID';
    SELECT id
      INTO remoteUser_ID
      FROM apache_logs.access_log_remoteuser
     WHERE name = in_RemoteUser;
    IF remoteUser_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_remoteuser (name) VALUES (in_RemoteUser);
        SET remoteUser_ID = LAST_INSERT_ID();
    END IF;
    RETURN remoteUser_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_userAgentID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_userAgentID`
    (in_UserAgent VARCHAR(2000))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE userAgent_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_userAgentID';
    SELECT id
      INTO userAgent_ID
      FROM apache_logs.access_log_useragent
     WHERE name = in_UserAgent;
    IF userAgent_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_useragent (name) VALUES (in_UserAgent);
        SET userAgent_ID = LAST_INSERT_ID();
    END IF;
    RETURN userAgent_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaID`
    (in_ua VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaID';
    SELECT id
      INTO ua_ID
      FROM apache_logs.access_log_ua
     WHERE name = in_ua;
    IF ua_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua (name) VALUES (in_ua);
        SET ua_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserID`
    (in_ua_browser VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_browser_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserID';
    SELECT id
      INTO ua_browser_ID
      FROM apache_logs.access_log_ua_browser
     WHERE name = in_ua_browser;
    IF ua_browser_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_browser (name) VALUES (in_ua_browser);
        SET ua_browser_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_browser_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserFamilyID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserFamilyID`
    (in_ua_browser_family VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_browser_family_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserFamilyID';
    SELECT id
      INTO ua_browser_family_ID
      FROM apache_logs.access_log_ua_browser_family
     WHERE name = in_ua_browser_family;
    IF ua_browser_family_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_browser_family (name) VALUES (in_ua_browser_family);
        SET ua_browser_family_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_browser_family_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserVersionID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserVersionID`
    (in_ua_browser_version VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_browser_version_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserVersionID';
    SELECT id
      INTO ua_browser_version_ID
      FROM apache_logs.access_log_ua_browser_version
     WHERE name = in_ua_browser_version;
    IF ua_browser_version_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_browser_version (name) VALUES (in_ua_browser_version);
        SET ua_browser_version_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_browser_version_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsID`
    (in_ua_os VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_os_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsID'; 
    SELECT id
      INTO ua_os_ID
      FROM apache_logs.access_log_ua_os
     WHERE name = in_ua_os;
    IF ua_os_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_os (name) VALUES (in_ua_os);
        SET ua_os_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_os_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsFamilyID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsFamilyID`
    (in_ua_os_family VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_os_family_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsFamilyID';
    SELECT id
      INTO ua_os_family_ID
      FROM apache_logs.access_log_ua_os_family
     WHERE name = in_ua_os_family;
    IF ua_os_family_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_os_family (name) VALUES (in_ua_os_family);
        SET ua_os_family_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_os_family_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsVersionID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsVersionID`
    (in_ua_os_version VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_os_version_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsVersionID';
    SELECT id
      INTO ua_os_version_ID
      FROM apache_logs.access_log_ua_os_version
     WHERE name = in_ua_os_version;
    IF ua_os_version_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_os_version (name) VALUES (in_ua_os_version);
        SET ua_os_version_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_os_version_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceID`
    (in_ua_device VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_device_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceID'; 
    SELECT id
      INTO ua_device_ID
      FROM apache_logs.access_log_ua_device
     WHERE name = in_ua_device;
    IF ua_device_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_device (name) VALUES (in_ua_device);
        SET ua_device_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceFamilyID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceFamilyID`
    (in_ua_device_family VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_device_family_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceFamilyID';
    SELECT id
      INTO ua_device_family_ID
      FROM apache_logs.access_log_ua_device_family
     WHERE name = in_ua_device_family;
    IF ua_device_family_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_device_family (name) VALUES (in_ua_device_family);
        SET ua_device_family_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_family_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceBrandID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceBrandID`
    (in_ua_device_brand VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_device_brand_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceBrandID';
    SELECT id
      INTO ua_device_brand_ID
      FROM apache_logs.access_log_ua_device_brand
     WHERE name = in_ua_device_brand;
    IF ua_device_brand_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_device_brand (name) VALUES (in_ua_device_brand);
        SET ua_device_brand_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_brand_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceModelID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceModelID`
    (in_ua_device_model VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_device_model_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceModelID';
    SELECT id
      INTO ua_device_model_ID
      FROM apache_logs.access_log_ua_device_model
     WHERE name = in_ua_device_model;
    IF ua_device_model_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_device_model (name) VALUES (in_ua_device_model);
        SET ua_device_model_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_model_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_cookieID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_cookieID`
    (in_Cookie VARCHAR(400))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE cookie_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_cookieID';
    SELECT id
      INTO cookie_ID
      FROM apache_logs.access_log_cookie
     WHERE name = in_Cookie;
    IF cookie_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_cookie (name) VALUES (in_Cookie);
        SET cookie_ID = LAST_INSERT_ID();
    END IF;
    RETURN cookie_ID;
END //
DELIMITER ;
-- # Functions associated with Access Log Attributes - Return Values below
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqProtocol`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqProtocol`
    (in_ReqProtocolID INTEGER)
    RETURNS VARCHAR(20)
    READS SQL DATA
BEGIN
    DECLARE reqProtocol VARCHAR(20) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqProtocol';
    SELECT name
      INTO reqProtocol
      FROM apache_logs.access_log_reqprotocol
     WHERE id = in_ReqProtocolID;
    RETURN reqProtocol;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqMethod`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqMethod`
    (in_ReqMethodID INTEGER)
    RETURNS VARCHAR(40)
    READS SQL DATA
BEGIN
    DECLARE reqMethod VARCHAR(40) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqMethod';
    SELECT name
      INTO reqMethod
      FROM apache_logs.access_log_reqmethod
     WHERE id = in_ReqMethodID;
    RETURN reqMethod;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqStatus`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqStatus`
    (in_ReqStatusID INTEGER)
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqStatus INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqStatus';
    SELECT name
      INTO reqStatus
      FROM apache_logs.access_log_reqstatus
     WHERE id = in_ReqStatusID;
    RETURN reqStatus;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqUri`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqUri`
    (in_ReqUriID INTEGER)
    RETURNS VARCHAR(2000)
    READS SQL DATA
BEGIN
    DECLARE reqUri VARCHAR(2000) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqUri';
    SELECT name
      INTO reqUri
      FROM apache_logs.access_log_requri
     WHERE id = in_ReqUriID;
    RETURN reqUri;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqQuery`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqQuery`
    (in_ReqQueryID INTEGER)
    RETURNS VARCHAR(2000)
    READS SQL DATA
BEGIN
    DECLARE reqQuery VARCHAR(2000) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqQuery';
    SELECT name
      INTO reqQuery
      FROM apache_logs.access_log_reqquery
     WHERE id = in_ReqQueryID;
    RETURN reqQuery;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_remoteLogName`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_remoteLogName`
    (in_RemoteLogNameID INTEGER)
    RETURNS VARCHAR(150)
    READS SQL DATA
BEGIN
    DECLARE remoteLogName VARCHAR(150) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_remoteLogName';
    SELECT name
      INTO remoteLogName
      FROM apache_logs.access_log_remotelogname
     WHERE id = in_RemoteLogNameID;
    RETURN remoteLogName;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_remoteUser`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_remoteUser`
    (in_RemoteUserID INTEGER)
    RETURNS VARCHAR(150)
    READS SQL DATA
BEGIN
    DECLARE remoteUser VARCHAR(150) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_remoteUser';
    SELECT name
      INTO remoteUser
      FROM apache_logs.access_log_remoteuser
     WHERE id = in_RemoteUserID;
    RETURN remoteUser;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_userAgent`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_userAgent`
    (in_UserAgentID INTEGER)
    RETURNS VARCHAR(2000)
    READS SQL DATA
BEGIN
    DECLARE userAgent VARCHAR(2000) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_userAgent';
    SELECT name
      INTO userAgent
      FROM apache_logs.access_log_useragent
     WHERE id = in_UserAgentID;
    RETURN userAgent;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_ua`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_ua`
    (in_uaID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_ua';
    SELECT name
      INTO ua
      FROM apache_logs.access_log_ua
     WHERE id = in_uaID;
    RETURN ua;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowser`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowser`
    (in_ua_browserID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_browser VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowser';
    SELECT name
      INTO ua_browser
      FROM apache_logs.access_log_ua_browser
     WHERE id = in_ua_browserID;
    RETURN ua_browser;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserFamily`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserFamily`
    (in_ua_browser_familyID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_browser_family VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserFamily';
    SELECT name
      INTO ua_browser_family
      FROM apache_logs.access_log_ua_browser_family
     WHERE id = in_ua_browser_familyID;
    RETURN ua_browser_family;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserVersion`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserVersion`
    (in_ua_browser_versionID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_browser_version VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserVersion';
    SELECT name
      INTO ua_browser_version
      FROM apache_logs.access_log_ua_browser_version
     WHERE id = in_ua_browser_versionID;
    RETURN ua_browser_version;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOs`
    (in_ua_osID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_os VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOs';
    SELECT name
      INTO ua_os
      FROM apache_logs.access_log_ua_os
     WHERE id = in_ua_osID;
    RETURN ua_os;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsFamily`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsFamily`
    (in_ua_os_familyID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_os_family VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsFamily';
    SELECT name
      INTO ua_os_family
      FROM apache_logs.access_log_ua_os_family
     WHERE id = in_ua_os_familyID;
    RETURN ua_os_family;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsVersion`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsVersion`
    (in_ua_os_versionID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_os_version VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsVersion';
    SELECT name
      INTO ua_os_version
      FROM apache_logs.access_log_ua_os_version
     WHERE id = in_ua_os_versionID;
    RETURN ua_os_version;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDevice`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDevice`
    (in_ua_deviceID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_device VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDevice';
    SELECT name
      INTO ua_device
      FROM apache_logs.access_log_ua_device
     WHERE id = in_ua_deviceID;
    RETURN ua_device;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceFamily`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceFamily`
    (in_ua_device_familyID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_device_family VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceFamily';
    SELECT name
      INTO ua_device_family
      FROM apache_logs.access_log_ua_device_family
     WHERE id = in_ua_device_familyID;
    RETURN ua_device_family;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceBrand`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceBrand`
    (in_ua_device_brandID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_device_brand VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceBrand';
    SELECT name
      INTO ua_device_brand
      FROM apache_logs.access_log_ua_device_brand
     WHERE name = in_ua_device_brandID;
    RETURN ua_device_brand;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceModel`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceModel`
    (in_ua_device_modelID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_device_model VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceModel';
    SELECT name
      INTO ua_device_model
      FROM apache_logs.access_log_ua_device_model
     WHERE id = in_ua_device_modelID;
    RETURN ua_device_model;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_cookie`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_cookie`
    (in_CookieID INTEGER)
    RETURNS VARCHAR(400)
    READS SQL DATA
BEGIN
    DECLARE cookie VARCHAR(400) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_cookie';
    SELECT name
      INTO cookie
      FROM apache_logs.access_log_cookie
     WHERE id = in_CookieID;
    RETURN cookie;
END //
DELIMITER ;
-- # Functions associated with Error Log Normalization below
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_logLevelID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logLevelID`
  (in_loglevel VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logLevelID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_logLevelID';
  SELECT id
    INTO logLevelID
    FROM apache_logs.error_log_level
    WHERE name = in_loglevel;
  IF logLevelID IS NULL THEN
      INSERT INTO apache_logs.error_log_level (name) VALUES (in_loglevel);
      SET logLevelID = LAST_INSERT_ID();
  END IF;
  RETURN logLevelID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_moduleID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_moduleID`
  (in_module VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE moduleID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_moduleID';
  SELECT id
    INTO moduleID
    FROM apache_logs.error_log_module
    WHERE name = in_module;
  IF moduleID IS NULL THEN
      INSERT INTO apache_logs.error_log_module (name) VALUES (in_module);
      SET moduleID = LAST_INSERT_ID();
  END IF;
  RETURN moduleID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_processID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_processID`
  (in_processid VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE process_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_processID';
  SELECT id
    INTO process_ID
    FROM apache_logs.error_log_processid
    WHERE name = in_processid;
  IF process_ID IS NULL THEN
      INSERT INTO apache_logs.error_log_processid (name) VALUES (in_processid);
      SET process_ID = LAST_INSERT_ID();
  END IF;
  RETURN process_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_threadID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_threadID`
  (in_threadid VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE thread_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_threadID';
  SELECT id
    INTO thread_ID
    FROM apache_logs.error_log_threadid
    WHERE name = in_threadid;
  IF thread_ID IS NULL THEN
      INSERT INTO apache_logs.error_log_threadid (name) VALUES (in_threadid);
      SET thread_ID = LAST_INSERT_ID();
  END IF;
  RETURN thread_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_apacheCodeID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_apacheCodeID`
  (in_apacheCode VARCHAR(400))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE apacheCodeID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_apacheCodeID';
  SELECT id
    INTO apacheCodeID
    FROM apache_logs.error_log_apachecode
    WHERE name = in_apacheCode;
  IF apacheCodeID IS NULL THEN
      INSERT INTO apache_logs.error_log_apachecode (name) VALUES (in_apacheCode);
      SET apacheCodeID = LAST_INSERT_ID();
  END IF;
  RETURN apacheCodeID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_apacheMessageID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_apacheMessageID`
  (in_apacheMessage VARCHAR(400))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE apacheMessageID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_apacheMessageID';
  SELECT id
    INTO apacheMessageID
    FROM apache_logs.error_log_apachemessage
    WHERE name = in_apacheMessage;
  IF apacheMessageID IS NULL THEN
      INSERT INTO apache_logs.error_log_apachemessage (name) VALUES (in_apacheMessage);
      SET apacheMessageID = LAST_INSERT_ID();
  END IF;
  RETURN apacheMessageID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_systemCodeID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemCodeID`
  (in_systemCode VARCHAR(400))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE systemCodeID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_systemCodeID';
  SELECT id
    INTO systemCodeID
    FROM apache_logs.error_log_systemcode
    WHERE name = in_systemCode;
  IF systemCodeID IS NULL THEN
      INSERT INTO apache_logs.error_log_systemcode (name) VALUES (in_systemCode);
      SET systemCodeID = LAST_INSERT_ID();
  END IF;
  RETURN systemCodeID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_systemMessageID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemMessageID`
  (in_systemMessage VARCHAR(400))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE systemMessageID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_systemMessageID';
  SELECT id
    INTO systemMessageID
    FROM apache_logs.error_log_systemmessage
    WHERE name = in_systemMessage;
  IF systemMessageID IS NULL THEN
      INSERT INTO apache_logs.error_log_systemmessage (name) VALUES (in_systemMessage);
      SET systemMessageID = LAST_INSERT_ID();
  END IF;
  RETURN systemMessageID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_logMessageID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logMessageID`
  (in_message VARCHAR(500))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE messageID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_logMessageID';
  SELECT id
    INTO messageID
    FROM apache_logs.error_log_message
    WHERE name = in_message;
  IF messageID IS NULL THEN
      INSERT INTO apache_logs.error_log_message (name) VALUES (in_message);
      SET messageID = LAST_INSERT_ID();
  END IF;
  RETURN messageID;
END //
DELIMITER ;
-- # Functions associated with Error Log Attributes - Return Values below
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_logLevel`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logLevel`
  (in_loglevelID INTEGER)
  RETURNS VARCHAR(100)
  READS SQL DATA
BEGIN
  DECLARE logLevel VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_logLevel';
  SELECT name
    INTO logLevel
    FROM apache_logs.error_log_level
    WHERE id = in_loglevelID;
  RETURN logLevel;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_module`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_module`
  (in_module INTEGER)
  RETURNS VARCHAR(100)
  READS SQL DATA
BEGIN
  DECLARE module VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_module';
  SELECT name
    INTO module
    FROM apache_logs.error_log_module
    WHERE id = in_moduleID;
  RETURN module;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_process`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_process`
  (in_processidID INTEGER)
  RETURNS VARCHAR(100)
  READS SQL DATA
BEGIN
  DECLARE process  VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_process';
  SELECT name
    INTO process
    FROM apache_logs.error_log_processid
    WHERE id = in_processidID;
  RETURN process;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_thread`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_thread`
  (in_threadidID INTEGER)
  RETURNS VARCHAR(100)
  READS SQL DATA
BEGIN
  DECLARE thread VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_thread';
  SELECT name
    INTO thread
    FROM apache_logs.error_log_threadid
    WHERE id = in_threadidID;
  RETURN thread;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_apacheCode`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_apacheCode`
  (in_apacheCodeID INTEGER)
  RETURNS VARCHAR(400)
  READS SQL DATA
BEGIN
  DECLARE apacheCode VARCHAR(400) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_apacheCode';
  SELECT name
    INTO apacheCode
    FROM apache_logs.error_log_apachecode
    WHERE id = in_apacheCodeID;
  RETURN apacheCode;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_apacheMessage`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_apacheMessage`
  (in_apacheMessageID INTEGER)
  RETURNS VARCHAR(400)
  READS SQL DATA
BEGIN
  DECLARE apacheMessage VARCHAR(400) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_apacheMessage';
  SELECT name
    INTO apacheMessage
    FROM apache_logs.error_log_apachemessage
    WHERE id = in_apacheMessageID;
  RETURN apacheMessage;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_systemCode`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemCode`
  (in_systemCodeID INTEGER)
  RETURNS VARCHAR(400)
  READS SQL DATA
BEGIN
  DECLARE systemCode VARCHAR(400) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_systemCode';
  SELECT name
    INTO systemCode
    FROM apache_logs.error_log_systemcode
    WHERE id = in_systemCodeID;
  RETURN systemCode;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_systemMessage`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemMessage`
  (in_systemMessageID INTEGER)
  RETURNS VARCHAR(400)
  READS SQL DATA
BEGIN
  DECLARE systemMessage VARCHAR(400) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_systemMessage';
  SELECT name
    INTO systemMessage
    FROM apache_logs.error_log_systemmessage
    WHERE id = in_systemMessageID;
  RETURN systemMessage;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_logMessage`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logMessage`
  (in_messageID INTEGER)
  RETURNS VARCHAR(500)
  READS SQL DATA
BEGIN
  DECLARE logMessage VARCHAR(500) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_logMessage';
  SELECT name
    INTO logMessage
    FROM apache_logs.error_log_message
    WHERE id = in_messageID;
  RETURN logMessage;
END //
DELIMITER ;
-- # Functions associated with both Access and Error Log Views below
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_refererID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_refererID`
  (in_Referer VARCHAR(1000))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE referer_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_refererID';
  SELECT id
    INTO referer_ID
    FROM apache_logs.log_referer
   WHERE name = in_Referer;
  IF referer_ID IS NULL THEN
    INSERT INTO apache_logs.log_referer (name) VALUES (in_Referer);
    SET referer_ID = LAST_INSERT_ID();
  END IF;
  RETURN referer_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_serverID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_serverID`
  (in_Server VARCHAR(253))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE server_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_serverID';
  SELECT id
    INTO server_ID
    FROM apache_logs.log_server
   WHERE name = in_Server;
  IF server_ID IS NULL THEN
    INSERT INTO apache_logs.log_server (name) VALUES (in_Server);
    SET server_ID = LAST_INSERT_ID();
  END IF;
  RETURN server_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_serverPortID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_serverPortID`
  (in_ServerPort INTEGER)
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE serverPort_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_serverPortID';
  SELECT id
    INTO serverPort_ID
    FROM apache_logs.log_serverport
   WHERE name = in_ServerPort;
  IF serverPort_ID IS NULL THEN
    INSERT INTO apache_logs.log_serverport (name) VALUES (in_ServerPort);
    SET serverPort_ID = LAST_INSERT_ID();
  END IF;
  RETURN serverPort_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientID`
  (in_client VARCHAR(253))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE client_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientID';
  SELECT id
    INTO client_ID
    FROM apache_logs.log_client
   WHERE name = in_client;
  IF client_ID IS NULL THEN
    INSERT INTO apache_logs.log_client (name) VALUES (in_client);
    SET client_ID = LAST_INSERT_ID();
  END IF;
  RETURN client_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientCountryID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientCountryID`
  (in_country VARCHAR(150),
   in_country_code VARCHAR(20)
  )
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientCountry_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientCountryID';
  SELECT id
    INTO clientCountry_ID
    FROM apache_logs.log_client_country
   WHERE country = in_country
     AND country_code = in_country_code;
  IF clientCountry_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_country (country, country_code) VALUES (in_country, in_country_code);
    SET clientCountry_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientCountry_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientSubdivisionID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientSubdivisionID`
  (in_subdivision VARCHAR(250))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientSubdivision_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientSubdivisionID';
  SELECT id
    INTO clientSubdivision_ID
    FROM apache_logs.log_client_subdivision
   WHERE name = in_subdivision;
  IF clientSubdivision_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_subdivision (name) VALUES (in_subdivision);
    SET clientSubdivision_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientSubdivision_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientCityID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientCityID`
  (in_city VARCHAR(250))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientCity_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientCityID';
  SELECT id
    INTO clientCity_ID
    FROM apache_logs.log_client_city
   WHERE name = in_city;
  IF clientCity_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_city (name) VALUES (in_city);
    SET clientCity_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientCity_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientCoordinateID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientCoordinateID`
  (in_latitude DECIMAL(10,8),
   in_longitude DECIMAL(11,8)
  )
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientCoordinate_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientCoordinateID';
  SELECT id
    INTO clientCoordinate_ID
    FROM apache_logs.log_client_coordinate
   WHERE latitude = in_latitude
     AND longitude = in_longitude;
  IF clientCoordinate_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_coordinate (latitude, longitude) VALUES (in_latitude, in_longitude);
    SET clientCoordinate_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientCoordinate_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientOrganizationID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientOrganizationID`
  (in_organization VARCHAR(500))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientOrganization_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientOrganizationID';
  SELECT id
    INTO clientOrganization_ID
    FROM apache_logs.log_client_organization
   WHERE name = in_organization;
  IF clientOrganization_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_organization (name) VALUES (in_organization);
    SET clientOrganization_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientOrganization_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientNetworkID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientNetworkID`
  (in_network VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientNetwork_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientNetworkID';
  SELECT id
    INTO clientNetwork_ID
    FROM apache_logs.log_client_network
   WHERE name = in_network;
  IF clientNetwork_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_network (name) VALUES (in_network);
    SET clientNetwork_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientNetwork_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientPortID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientPortID`
  (in_ClientPort INTEGER)
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientPort_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientPortID';
  SELECT id
    INTO clientPort_ID
    FROM apache_logs.log_clientport
   WHERE name = in_ClientPort;
  IF clientPort_ID IS NULL THEN
    INSERT INTO apache_logs.log_clientport (name) VALUES (in_ClientPort);
    SET clientPort_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientPort_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_requestLogID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_requestLogID`
  (in_RequestLog VARCHAR(50))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE requestLog_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_requestLogID';
  SELECT id
    INTO requestLog_ID
    FROM apache_logs.log_requestlogid
   WHERE name = in_RequestLog;
  IF requestLog_ID IS NULL THEN
    INSERT INTO apache_logs.log_requestlogid (name) VALUES (in_RequestLog);
    SET requestLog_ID = LAST_INSERT_ID();
  END IF;
  RETURN requestLog_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `clientID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `clientID_logs`
  (in_clientID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'clientID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE clientID = in_clientID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE clientID = in_clientID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `clientPortID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `clientPortID_logs`
  (in_clientPortID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'clientPortID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE clientPortID = in_clientPortID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE clientPortID = in_clientPortID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `refererID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `refererID_logs`
  (in_refererID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'refererID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE refererID = in_refererID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE refererID = in_refererID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `requestLogID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `requestLogID_logs`
  (in_requestLogID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'requestLogID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE requestLogID = in_requestLogID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE requestLogID = in_requestLogID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `serverID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `serverID_logs`
  (in_ServerID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'serverID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE serverID = in_ServerID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE serverID = in_ServerID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `serverPortID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `serverPortID_logs`
  (in_serverPortID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'serverPortID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE serverPortID = in_serverPortID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE serverPortID = in_serverPortID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
-- # Functions associated with both Access and Error Attributes - Return Values below
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_referer`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_referer`
  (in_RefererID INTEGER)
  RETURNS VARCHAR(1000)
  READS SQL DATA
BEGIN
  DECLARE referer VARCHAR(1000) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_referer';
  SELECT name
    INTO referer
    FROM apache_logs.log_referer
   WHERE id = in_RefererID;
  RETURN referer;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_server`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_server`
  (in_ServerID INTEGER)
  RETURNS VARCHAR(253)
  READS SQL DATA
BEGIN
  DECLARE server VARCHAR(253) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_server';
  SELECT name
    INTO server
    FROM apache_logs.log_server
   WHERE id = in_ServerID;
  RETURN server;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_serverPort`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_serverPort`
  (in_ServerPortID INTEGER)
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE serverPort INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_serverPort';
  SELECT name
    INTO serverPort
    FROM apache_logs.log_serverport
   WHERE id = in_ServerPortID;
  RETURN serverPort;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_client`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_client`
  (in_clientID INTEGER)
  RETURNS VARCHAR(253)
  READS SQL DATA
BEGIN
  DECLARE client VARCHAR(253) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_client';
  SELECT name
    INTO client
    FROM apache_logs.log_client
   WHERE id = in_clientID;
  RETURN client;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientPort`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientPort`
  (in_ClientPortID INTEGER)
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientPort INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientPort';
  SELECT name
    INTO clientPort
    FROM apache_logs.log_clientport
   WHERE id = in_ClientPortID;
  RETURN clientPort;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_requestLog`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_requestLog`
  (in_RequestLogID INTEGER)
  RETURNS VARCHAR(50)
  READS SQL DATA
BEGIN
  DECLARE requestLog VARCHAR(50) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_requestLog';
  SELECT name
    INTO requestLog
    FROM apache_logs.log_requestlogid
   WHERE name = in_RequestLogID;
  RETURN requestLog;
END //
DELIMITER ;
-- # Functions associated with Import Processes below
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importDeviceID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importDeviceID`
  (in_deviceid VARCHAR(150),
   in_platformNode VARCHAR(200),
   in_platformSystem VARCHAR(100),
   in_platformMachine VARCHAR(100),
   in_platformProcessor VARCHAR(200)
  )
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importDevice_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL apache_logs.errorProcess('importdeviceID', e1, e2, e3, 'apache_logs', 'logs2mysql.py', null, null);
  END;
  SELECT id
    INTO importDevice_ID
    FROM apache_logs.import_device
   WHERE deviceid = in_deviceid
     AND platformNode = in_platformNode
     AND platformSystem = in_platformSystem
     AND platformMachine = in_platformMachine
     AND platformProcessor = in_platformProcessor;
  IF importDevice_ID IS NULL THEN
  	INSERT INTO apache_logs.import_device 
      (deviceid,
       platformNode,
       platformSystem,
       platformMachine,
       platformProcessor)
    VALUES
      (in_deviceid,
       in_platformNode,
       in_platformSystem,
       in_platformMachine,
       in_platformProcessor);
	  SET importDevice_ID = LAST_INSERT_ID();
  END IF;
  RETURN importDevice_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importClientID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importClientID`
  (in_ipaddress VARCHAR(50),
   in_login VARCHAR(200),
   in_expandUser VARCHAR(200),
   in_platformRelease VARCHAR(100),
   in_platformVersion VARCHAR(175),
   in_importdevice_id VARCHAR(30)
  )
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importClient_ID INTEGER DEFAULT null;
  DECLARE importDevice_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL apache_logs.errorProcess('importclientID', e1, e2, e3, 'apache_logs', 'logs2mysql.py', null, null);
  END;
  IF NOT CONVERT(in_importdevice_id, UNSIGNED) = 0 THEN
    SET importDevice_ID = CONVERT(in_importdevice_id, UNSIGNED);
  END IF;
  SELECT id
    INTO importClient_ID
    FROM apache_logs.import_client
   WHERE ipaddress = in_ipaddress
     AND login = in_login
     AND expandUser = in_expandUser
     AND platformRelease = in_platformRelease
     AND platformVersion = in_platformVersion
     AND importdeviceid = importDevice_ID;
  IF importClient_ID IS NULL THEN
  	INSERT INTO apache_logs.import_client 
      (ipaddress,
       login,
       expandUser,
       platformRelease,
       platformVersion,
       importdeviceid)
    VALUES
      (in_ipaddress,
       in_login,
       in_expandUser,
       in_platformRelease,
       in_platformVersion,
       importDevice_ID);
	  SET importClient_ID = LAST_INSERT_ID();
  END IF;
  RETURN importClient_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importLoadID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importLoadID`
  (in_importclient_id VARCHAR(30)) 
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importLoad_ID INTEGER DEFAULT null;
  DECLARE importclient_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL apache_logs.errorProcess('importLoadID', e1, e2, e3, 'apache_logs', 'logs2mysql.py', importLoad_ID, null );
  END;
  IF NOT CONVERT(in_importclient_id, UNSIGNED) = 0 THEN
    SET importclient_ID = CONVERT(in_importclient_id, UNSIGNED);
  END IF;
  INSERT INTO apache_logs.import_load (importclientid) VALUES (importclient_ID);
  SET importLoad_ID = LAST_INSERT_ID();
  RETURN importLoad_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importFileExists`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importFileExists`
  (in_importFile VARCHAR(300),
   in_importdevice_id VARCHAR(30)
  )
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importFileID INTEGER DEFAULT null;
  DECLARE importDate DATETIME DEFAULT null;
  DECLARE importDays INTEGER DEFAULT null;
  DECLARE importDevice_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL apache_logs.errorProcess('importFileExists', e1, e2, e3, 'apache_logs', 'logs2mysql.py', null, null );
  END;
  IF NOT CONVERT(in_importdevice_id, UNSIGNED) = 0 THEN
    SET importDevice_ID = CONVERT(in_importdevice_id, UNSIGNED);
  END IF;
  SELECT id,
         added
    INTO importFileID,
         importDate
    FROM apache_logs.import_file
   WHERE name = in_importFile
     AND importdeviceid = importDevice_ID;
  IF NOT ISNULL(importFileID) THEN
    SET importDays = datediff(now(), importDate);
  END IF;
  RETURN importDays;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importFileID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importFileID`
  (importFile VARCHAR(300),
   file_size VARCHAR(30),
   file_created VARCHAR(30),
   file_modified VARCHAR(30),
   in_importdevice_id VARCHAR(10),
   in_importload_id VARCHAR(10),
   fileformat VARCHAR(10)
  )
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importFile_ID INTEGER DEFAULT null;
  DECLARE importLoad_ID INTEGER DEFAULT null;
  DECLARE importDevice_ID INTEGER DEFAULT null;
  DECLARE formatfile_ID INTEGER DEFAULT 0;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL apache_logs.errorProcess('importFileID', e1, e2, e3, 'apache_logs', 'logs2mysql.py', importload_id, null );
  END;
  IF NOT CONVERT(in_importdevice_id, UNSIGNED) = 0 THEN
    SET importDevice_ID = CONVERT(in_importdevice_id, UNSIGNED);
  END IF;
  SELECT id
    INTO importFile_ID
    FROM apache_logs.import_file
   WHERE name = importFile
     AND importdeviceid = importDevice_ID;
  IF importFile_ID IS NULL THEN
    IF NOT CONVERT(in_importload_id, UNSIGNED) = 0 THEN
  	  SET importLoad_ID = CONVERT(in_importload_id, UNSIGNED);
    END IF;
    IF NOT CONVERT(fileformat, UNSIGNED) = 0 THEN
  	  SET formatFile_ID = CONVERT(fileformat, UNSIGNED);
    END IF;
    INSERT INTO apache_logs.import_file 
       (name,
        filesize,
        filecreated,
        filemodified,
        importdeviceid,
        importloadid,
        importformatid)
    VALUES 
      (importFile, 
       CONVERT(file_size, UNSIGNED),
       STR_TO_DATE(file_created,'%a %b %e %H:%i:%s %Y'),
       STR_TO_DATE(file_modified,'%a %b %e %H:%i:%s %Y'),
       importDevice_ID,
       importLoad_ID,
       formatFile_ID);
    SET importFile_ID = LAST_INSERT_ID();
  END IF;
  RETURN importFile_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importServerID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importServerID`
  (in_user VARCHAR(255),
   in_host VARCHAR(255),
   in_version VARCHAR(55),
   in_system VARCHAR(55),
   in_machine VARCHAR(55),
   in_comment VARCHAR(75)
  )
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE importServer_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SET @error_count = 1;
    RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'importServerID'; 
  END;
  SELECT id
	  INTO importServer_ID
	  FROM apache_logs.import_server
   WHERE dbuser = in_user
     AND dbhost = in_host
     AND dbversion = in_version
     AND dbsystem = in_system
     AND dbmachine = in_machine
     AND dbcomment = in_comment;
  IF importServer_ID IS NULL THEN
    INSERT INTO apache_logs.import_server 
       (dbuser,
        dbhost,
        dbversion,
        dbsystem,
        dbmachine,
        dbcomment)
    VALUES
       (in_user,
        in_host,
        in_version,
        in_system,
        in_machine,
        in_comment);
    SET importServer_ID = LAST_INSERT_ID();
  END IF;
  RETURN importServer_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importProcessID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importProcessID`
  (processType VARCHAR(100),
   processName VARCHAR(100)
  ) 
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE importProcess_ID INTEGER DEFAULT NULL;
  DECLARE importServer_ID INTEGER DEFAULT NULL;
  DECLARE db_user VARCHAR(255) DEFAULT NULL;
  DECLARE db_host VARCHAR(255) DEFAULT NULL;
  DECLARE db_version VARCHAR(55) DEFAULT NULL;
  DECLARE db_system VARCHAR(55) DEFAULT NULL;
  DECLARE db_machine VARCHAR(55) DEFAULT NULL;
  DECLARE db_comment VARCHAR(75) DEFAULT NULL;
  -- DECLARE db_server VARCHAR(75) DEFAULT NULL;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    IF @error_count=1 THEN RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'importServerID called from importProcessID'; ELSE RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'importProcessID'; END IF;
  END;
  SET @error_count = 0;
-- 03/04/2025 - @@server_uuid and UUID() - these 2 are not the same - changed in version 3.2.0 on 02/01/2025 release - since then records are added to import_server TABLE as different servers
-- UUUID() - unique per execution. everytime called the value is different. My fault thinking it was the same functionality as @server_uid. Changed and never tested due to workig on another project at time.
-- @@server_uuid - Introduced MySQL 5.7 - the server generates a true UUID in addition to the server_id value supplied by the user. This is available as the global, read-only server_uuid system variable.
-- @@server_uid - Introduced MariaDB 10.5.26 - Automatically calculated server unique id hash. Added to the error log to allow one to verify if error reports are from the same server. continued on next line.
-- UID is a base64-encoded SHA1 hash of the MAC address of one of the interfaces, and the tcp port that the server is listening on.
  SELECT user(),
    @@hostname,
    @@version,
    @@version_compile_os,
    @@version_compile_machine,
    @@version_comment
  INTO 
    db_user,
    db_host,
    db_version,
    db_system,
    db_machine,
    db_comment;
-- this does not work due to MariaDB ERRORS on script execution on @@server_uuid. scraping server_uuid and server_uid. renamed import_table TABLE column uuidserver to comment.    
--  IF LOCATE('mysql', db_comment) THEN
--    SELECT @@server_uuid INTO db_server;
--  ELSE
--    SELECT @@server_uid INTO db_server;
--  END IF;
--	SET importServer_ID = importServerID(db_user, db_host, db_version, db_system, db_machine, db_server, db_comment);
	SET importServer_ID = importServerID(db_user, db_host, db_version, db_system, db_machine, db_comment);
	INSERT INTO apache_logs.import_process
      (type,
       name,
       importserverid)
    VALUES
      (processType,
       processName,
       importServer_ID);
  SET importProcess_ID = LAST_INSERT_ID();
  RETURN importProcess_ID;
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importFileCheck`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importFileCheck`
  (importfileid INTEGER,
   processid INTEGER,
   processType VARCHAR(10)
  ) 
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  -- replaced ER_SIGNAL_EXCEPTION with errno
  DECLARE errno SMALLINT UNSIGNED DEFAULT 1644;
  DECLARE importFileName VARCHAR(300) DEFAULT null;
  DECLARE parseProcess_ID INTEGER DEFAULT null;
  DECLARE importProcess_ID INTEGER DEFAULT null;
  DECLARE processFile INTEGER DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'importFileCheck'; 
  SELECT name,
         parseprocessid,
         importprocessid 
    INTO importFileName,
         parseProcess_ID,
         importProcess_ID
    FROM apache_logs.import_file
   WHERE id = importfileid;
  -- IF none of these things happen all is well. processing records from same file.
  IF importFileName IS NULL THEN
  -- This is an error. Import File must be in table when import processing.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = 'ERROR - Import File is not found in import_file table.',
      MYSQL_ERRNO = errno;
  ELSEIF processid IS NULL THEN
  -- This is an error. This function is only called when import processing. ProcessID must be valid.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = 'ERROR - ProcessID required when import processing.',
      MYSQL_ERRNO = errno;
  ELSEIF processType = 'parse' AND parseProcess_ID IS NULL THEN
  -- First time and first record in file being processed. This will happen one time for each file.
    UPDATE apache_logs.import_file SET parseprocessid = processid WHERE id = importFileID;
  ELSEIF  processType = 'parse' AND processid != parseProcess_ID THEN
  -- This is an error. This function is only called when import processing. only ONE ProcessID must be used for each file.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = 'ERROR - Previous PARSE process found. File has already been PARSED.',
      MYSQL_ERRNO = errno;
  ELSEIF processType = 'import' AND importProcess_ID IS NULL THEN
  -- First time and first record in file being processed. This will happen one time for each file.
    UPDATE apache_logs.import_file SET importprocessid = processid WHERE id = importFileID;
  ELSEIF  processType = 'import' AND processid != importProcess_ID THEN
  -- This is an error. This function is only called when import processing. only ONE ProcessID must be used for each file.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = 'ERROR - Previous IMPORT process found. File has already been IMPORTED.',
      MYSQL_ERRNO = errno;
  END IF;
  RETURN processFile;
END //
DELIMITER ;
-- # Procedures associated with Import Processes below
-- drop function -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `errorProcess`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `errorProcess`
  (IN in_module VARCHAR(300),
   IN in_mysqlerrno INTEGER, 
   IN in_messagetext VARCHAR(1000), 
   IN in_returnedsqlstate VARCHAR(250), 
   IN in_schemaname VARCHAR(64),
   IN in_catalogname VARCHAR(64),
   IN in_loadID INTEGER,
   IN in_processID INTEGER)
BEGIN
   INSERT INTO import_error 
     (module,
      mysql_errno,
      message_text,
      returned_sqlstate,
      schema_name,
      catalog_name,
      importloadid,
      importprocessid)
   VALUES
     (in_module,
      in_mysqlerrno,
      in_messagetext,
      in_returnedsqlstate,
      in_schemaname,
      in_catalogname,
      in_loadID,
      in_processID);
END //
DELIMITER ;
-- drop function -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `errorLoad`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `errorLoad`
	(IN in_module VARCHAR(300),
     IN in_mysqlerrno VARCHAR(10),
     IN in_messagetext VARCHAR(1000), 
     IN in_loadID VARCHAR(10))
BEGIN
	DECLARE mysqlerrno INTEGER DEFAULT 0;
	DECLARE loadID INTEGER DEFAULT 0;
  IF NOT CONVERT(in_mysqlerrno, UNSIGNED) = 0 THEN
    SET mysqlerrno = CONVERT(in_mysqlerrno, UNSIGNED);
  END IF;
  IF NOT CONVERT(in_loadID, UNSIGNED) = 0 THEN
    SET loadID = CONVERT(in_loadID, UNSIGNED);
  END IF;
  INSERT INTO import_error 
     (module,
      mysql_errno,
      message_text,
      importloadid,
      schema_name)
  VALUES
     (in_module,
      mysqlerrno,
      in_messagetext,
      loadID,
      'logs2mysql.py');
END //
DELIMITER ;
-- # Views associated with Access Log below
-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_requri_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_requri_list` AS
     SELECT `ln`.`name` AS `Access Log URI`, 
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_requri` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`requriid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_reqquery_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_reqquery_list` AS
     SELECT `ln`.`name` AS `Access Log Query String`, 
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_reqquery` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`reqqueryid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_reqstatus_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_reqstatus_list` AS
     SELECT `ln`.`name` AS `Access Log Status`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_reqstatus` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`reqstatusid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_referer_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_referer_list` AS
     SELECT `ln`.`name` AS `Access Log Referer`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_referer` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`refererid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_reqprotocol_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_reqprotocol_list` AS
     SELECT `ln`.`name` AS `Access Log Protocol`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_reqprotocol` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`reqstatusid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_reqmethod_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_reqmethod_list` AS
     SELECT `ln`.`name` AS `Access Log Method`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_reqmethod` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`reqmethodid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_remotelogname_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_remotelogname_list` AS
     SELECT `ln`.`name` AS `Access Log Remote Log Name`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_remotelogname` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`remotelognameid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_remoteuser_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_remoteuser_list` AS
     SELECT `ln`.`name` AS `Access Log Remote User`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_remoteuser` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`remoteuserid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_cookie_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_cookie_list` AS
     SELECT `ln`.`name` AS `Access Log Cookie`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_cookie` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`cookieid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_server_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_server_list` AS
     SELECT `ln`.`name` AS `Access Log Server Name`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_server` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`serverid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_serverport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_serverport_list` AS
     SELECT `ln`.`name` AS `Access Log Server Port`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_serverport` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`serverportid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_server_serverport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_server_serverport_list` AS
     SELECT `sn`.`name` AS `Access Log Server Name`,
            `sp`.`name` AS `Server Port`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log` `l`
 INNER JOIN `log_server` `sn`
         ON `sn`.`id` = `l`.`serverid`
 INNER JOIN `log_serverport` `sp`
         ON `sp`.`id` = `l`.`serverportid`
   GROUP BY `l`.`serverid`,
            `l`.`serverportid`
   ORDER BY `sn`.`name`,
	          `sp`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_period_year_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_period_year_list` AS
     SELECT YEAR(l.logged) 'Year',
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM apache_logs.access_log l
   GROUP BY YEAR(l.logged)
   ORDER BY 'Year'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_period_month_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_period_month_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM apache_logs.access_log l
   GROUP BY YEAR(l.logged),
            MONTH(l.logged)
   ORDER BY 'Year',
            'Month'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_period_week_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_period_week_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            WEEK(l.logged) 'Week',
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM apache_logs.access_log l
   GROUP BY YEAR(l.logged),
            MONTH(l.logged),
            WEEK(l.logged)
   ORDER BY 'Year',
            'Month',
            'Week'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_period_day_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_period_day_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            DAY(l.logged) 'Day',
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM apache_logs.access_log l
   GROUP BY YEAR(l.logged),
            MONTH(l.logged),
            DAY(l.logged)
   ORDER BY 'Year',
            'Month',
            'Day'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_period_hour_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_period_hour_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            DAY(l.logged) 'Day',
            HOUR(l.logged) 'Hour',
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM apache_logs.access_log l
   GROUP BY YEAR(l.logged),
            MONTH(l.logged),
            DAY(l.logged),
            HOUR(l.logged)
   ORDER BY 'Year',
            'Month',
            'Day',
            'Hour';
   
-- # Views associated with Error Log tables below
-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_level_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_level_list` AS
     SELECT `ln`.`name` AS `Error Log Level`, 
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_level` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`loglevelid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_module_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_module_list` AS
     SELECT `ln`.`name` AS `Error Log Module`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_module` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`moduleid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_processid_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_processid_list` AS
     SELECT `ln`.`name` AS `Error Log ProcessID`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_processid` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`processid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_threadid_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_threadid_list` AS
     SELECT `ln`.`name` AS `Error Log ThreadID`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_threadid` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`threadid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_processid_threadid_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_processid_threadid_list` AS
     SELECT `pid`.`name` AS `ProcessID`,
            `tid`.`name` AS `ThreadID`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log` `l`
 INNER JOIN `error_log_processid` `pid`
         ON `l`.`processid` = `pid`.`id`
 INNER JOIN `error_log_threadid` `tid`
         ON `l`.`threadid` = `tid`.`id`
   GROUP BY `pid`.`id`,
            `tid`.`id`
   ORDER BY `pid`.`name`,
            `tid`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_apacheCode_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_apacheCode_list` AS
     SELECT `ln`.`name` AS `Error Log Apache Code`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_apachecode` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`apachecodeid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_apacheMessage_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_apacheMessage_list` AS
     SELECT `ln`.`name` AS `Error Log Apache Message`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_apachemessage` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`apachemessageid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_systemCode_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_systemCode_list` AS
     SELECT `ln`.`name` AS `Error Log System Code`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_systemcode` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`systemcodeid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;


-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_systemMessage_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_systemMessage_list` AS
     SELECT `ln`.`name` AS `Error Log System Message`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_systemmessage` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`systemmessageid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_message_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_message_list` AS
     SELECT `ln`.`name` AS `Error Log Message`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_message` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`logmessageid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_client_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_client_list` AS
     SELECT `ln`.`name` AS `Error Log Client Name`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `log_client` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_clientport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_client_port_list` AS
     SELECT `ln`.`name` AS `Error Log Client Port`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `log_clientport` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`clientportid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_client_clientport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_client_clientport_list` AS
     SELECT `cn`.`name` AS `Error Log Server Name`,
            `cp`.`name` AS `Server Port`,
            COUNT(`l`.`id`) AS `Log Count` 
       FROM `error_log` `l`
 INNER JOIN `log_client` `cn`
         ON `cn`.`id` = `l`.`clientid`
 INNER JOIN `log_clientport` `cp`
         ON `cp`.`id` = `l`.`clientportid`
   GROUP BY `l`.`clientid`,
            `l`.`clientportid`
   ORDER BY `cn`.`name`,
            `cp`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_referer_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_referer_list` AS
     SELECT `ln`.`name` AS `Error Log Referer`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `log_referer` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`refererid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_server_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_server_list` AS
     SELECT `ln`.`name` AS `Error Log Server Name`,
            COUNT(`l`.`id`) AS `Log Count` 
       FROM `log_server` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`serverid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_serverport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_serverport_list` AS
     SELECT `ln`.`name` AS `Error Log Server Port`,
            COUNT(`l`.`id`) AS `Log Count` 
       FROM `log_serverport` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`serverportid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_server_serverport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_server_serverport_list` AS
     SELECT `sn`.`name` AS `Error Log Server Name`,
            `sp`.`name` AS `Server Port`,
            COUNT(`l`.`id`) AS `Log Count` 
       FROM `error_log` `l`
 INNER JOIN `log_server` `sn`
         ON `sn`.`id` = `l`.`serverid`
 INNER JOIN `log_serverport` `sp`
         ON `sp`.`id` = `l`.`serverportid`
   GROUP BY `l`.`serverid`,
            `l`.`serverportid`
   ORDER BY `sn`.`name`,
	          `sp`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_importfile_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_importfile_list` AS
     SELECT `ln`.`name` AS `Error Log Import File`, 
            COUNT(`l`.`id`) AS `Log Count`
       FROM `import_file` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`importfileid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_year_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_year_list` AS
     SELECT YEAR(l.logged) 'Year',
            COUNT(`l`.`id`) AS `Log Count`
       FROM apache_logs.error_log l
   GROUP BY YEAR(l.logged)
   ORDER BY 'Year'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_month_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_month_list` AS
    SELECT YEAR(l.logged) 'Year',
           MONTH(l.logged) 'Month',
           COUNT(`l`.`id`) AS `Log Count`
      FROM apache_logs.error_log l
  GROUP BY YEAR(l.logged),
           MONTH(l.logged)
  ORDER BY 'Year',
           'Month'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_week_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_week_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            WEEK(l.logged) 'Week',
            COUNT(`l`.`id`) AS `Log Count`
       FROM apache_logs.error_log l
   GROUP BY YEAR(l.logged),
            MONTH(l.logged),
            WEEK(l.logged)
   ORDER BY 'Year',
            'Month',
            'Week'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_day_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_day_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            DAY(l.logged) 'Day',
            COUNT(`l`.`id`) AS `Log Count`
       FROM apache_logs.error_log l
   GROUP BY YEAR(l.logged),
            MONTH(l.logged),
            DAY(l.logged)
   ORDER BY 'Year',
            'Month',
            'Day'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_hour_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_hour_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            DAY(l.logged) 'Day',
            HOUR(l.logged) 'Hour',
            COUNT(`l`.`id`) AS `Log Count`
       FROM apache_logs.error_log l
   GROUP BY YEAR(l.logged),
            MONTH(l.logged),
            DAY(l.logged),
            HOUR(l.logged)
   ORDER BY 'Year',
            'Month',
            'Day',
            'Hour';
     
-- # Views associated with Log tables below
-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_client_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_client_list` AS
SELECT `name` AS `Client Name`,
       `clientID_logs`(id, 'A') AS `Access Log Count`, 
       `clientID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_client`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_clientport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_clientport_list` AS
SELECT `name` AS `Client Port`,
       `clientPortID_logs`(id, 'A') AS `Access Log Count`, 
       `clientPortID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_clientport`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_referer_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_referer_list` AS
SELECT `name` AS `Referer`,
       `refererID_logs`(id, 'A') AS `Access Log Count`, 
       `refererID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_referer`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_requestlog_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_requestlog_list` AS
SELECT `name` AS `Request Log`,
       `requestlogID_logs`(id, 'A') AS `Access Log Count`, 
       `requestlogID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_requestlogid`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_server_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_server_list` AS
SELECT `name` AS `Server Name`,
       `serverID_logs`(id, 'A') AS `Access Log Count`, 
       `serverID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_server`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_serverport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_serverport_list` AS
SELECT `name` AS `Server Port`,
       `serverPortID_logs`(id, 'A') AS `Access Log Count`, 
       `serverPortID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_serverport`
ORDER BY `name`;

-- # Views associated with UserAgent and User-Agent data tables below
-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_list` AS
     SELECT `ln`.`name` AS `Access Log UserAgent`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_pretty_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_pretty_list` AS
     SELECT `ln`.`ua` AS `Access Log Pretty User Agent`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua`
   ORDER BY `ln`.`ua`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_os_browser_device_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_os_browser_device_list` AS
     SELECT `ln`.`ua_os_family` AS `Operating System`,
            `ln`.`ua_browser_family` AS `Browser`,
            `ln`.`ua_device_family` AS `Device`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_os_family`,
            `ln`.`ua_browser_family`,
            `ln`.`ua_device_family`
   ORDER BY `ln`.`ua_os_family`, 
            `ln`.`ua_browser_family`,
            `ln`.`ua_device_family`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_browser_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_browser_list` AS
     SELECT `ln`.`ua_browser` AS `Browser`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_browser`
   ORDER BY `ln`.`ua_browser`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_browser_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_browser_family_list` AS
     SELECT `ln`.`ua_browser_family` AS `Browser Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_browser_family`
   ORDER BY `ln`.`ua_browser_family`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_browser_version_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_browser_version_list` AS
     SELECT `ln`.`ua_browser_version` AS `Browser Version`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_browser_version`
   ORDER BY `ln`.`ua_browser_version`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_device_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_device_list` AS
     SELECT `ln`.`ua_device` AS `Device`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_device`
   ORDER BY `ln`.`ua_device`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_device_brand_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_device_brand_list` AS
     SELECT `ln`.`ua_device_brand` AS `Device Brand`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_device_brand`
   ORDER BY `ln`.`ua_device_brand`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_device_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_device_family_list` AS
     SELECT `ln`.`ua_device_family` AS `Device Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_device_family`
   ORDER BY `ln`.`ua_device_family`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_device_model_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_device_model_list` AS
     SELECT `ln`.`ua_device_model` AS `Device Model`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_device_model`
   ORDER BY `ln`.`ua_device_model`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_os_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_os_list` AS
     SELECT `ln`.`ua_os` AS `Operating System`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_os`
   ORDER BY `ln`.`ua_os`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_os_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_os_family_list` AS
     SELECT `ln`.`ua_os_family` AS `Operating System Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_os_family`
   ORDER BY `ln`.`ua_os_family`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_os_version_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_os_version_list` AS
     SELECT `ln`.`ua_os_version` AS `Operating System Version`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_os_version`
   ORDER BY `ln`.`ua_os_version`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_list` AS
     SELECT `ln`.`name` AS `Access Log User Agent`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uaid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_browser_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_browser_list` AS
    SELECT `ln`.`name` AS `Browser`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_browser` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uabrowserid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_browser_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_browser_family_list` AS
     SELECT `ln`.`name` AS `Browser Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_browser_family` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uabrowserfamilyid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_browser_version_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_browser_version_list` AS
    SELECT `ln`.`name` AS `Browser Version`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_browser_version` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uabrowserversionid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_device_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_device_list` AS
    SELECT `ln`.`name` AS `Device`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_device` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uadeviceid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_device_brand_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_device_brand_list` AS
    SELECT `ln`.`name` AS `Device Brand`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_device_brand` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uadevicebrandid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_device_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_device_family_list` AS
    SELECT `ln`.`name` AS `Device Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_device_family` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uadevicefamilyid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_device_model_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_device_model_list` AS
     SELECT `ln`.`name` AS `Device Model`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_device_model` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uadevicefamilyid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_os_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_os_list` AS
    SELECT `ln`.`name` AS `Operating System`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_os` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uaosid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_os_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_os_family_list` AS
     SELECT `ln`.`name` AS `Operating System Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_os_family` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uaosfamilyid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_os_version_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_os_version_list` AS
     SELECT `ln`.`name` AS `Operating System Version`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_os_version` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uaosversionid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- # Views associated with Client and IP Geolocation data tables below
-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_list` AS
     SELECT `ln`.`name` AS `Access Client Name`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`name`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientcity_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientcity_list` AS
     SELECT `ln`.`city` AS `Access Client City`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`city`
   ORDER BY `ln`.`city`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientcountry_code_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientcountry_code_list` AS
     SELECT `ln`.`country_code` AS `Access Client Country Code`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`country_code`
   ORDER BY `ln`.`country_code`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientcountry_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientcountry_list` AS
     SELECT `ln`.`country` AS `Access Client Country`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`country`
   ORDER BY `ln`.`country`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientsubdivision_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientsubdivision_list` AS
     SELECT `ln`.`subdivision` AS `Access Client Subdivision`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`subdivision`
   ORDER BY `ln`.`subdivision`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientorganization_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientorganization_list` AS
     SELECT `ln`.`organization` AS `Access Client Organization`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`organization`
   ORDER BY `ln`.`organization`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientnetwork_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientnetwork_list` AS
     SELECT `ln`.`network` AS `Access Client Network`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`network`
   ORDER BY `ln`.`network`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_city_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_city_list` AS
     SELECT `ca`.`name` AS `Access Client City`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_city` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`cityid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`name`
   ORDER BY `ca`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_country_code_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_country_code_list` AS
     SELECT `ca`.`country_code` AS `Access Client Country Code`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_country` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`countryid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`country_code`
   ORDER BY `ca`.`country_code`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_country_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_country_list` AS
     SELECT `ca`.`country` AS `Access Client Country`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_country` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`countryid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`country`
   ORDER BY `ca`.`country`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_subdivision_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_subdivision_list` AS
     SELECT `ca`.`name` AS `Access Client Subdivision`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_subdivision` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`subdivisionid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`name`
   ORDER BY `ca`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_organization_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_organization_list` AS
     SELECT `ca`.`name` AS `Access Client Organization`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_organization` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`organizationid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`name`
   ORDER BY `ca`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_network_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_network_list` AS
     SELECT `ca`.`name` AS `Access Client Network`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_network` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`networkid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`name`
   ORDER BY `ca`.`name`;

-- # Views associated with Import tables below
-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `import_file_access_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `import_file_access_list` AS
     SELECT `ln`.`name` AS `Import File`, 
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `import_file` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`importfileid` = `ln`.`id`
   GROUP BY `ln`.`name`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `import_file_error_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `import_file_error_list` AS
     SELECT `ln`.`name` AS `Import File`, 
            COUNT(`l`.`id`) AS `Log Count`
       FROM `import_file` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`importfileid` = `ln`.`id`
   GROUP BY `ln`.`name`
   ORDER BY `ln`.`name`;

-- # Stored Procedure Access Log parsing performed on LOAD TABLE below
-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `process_access_parse`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `process_access_parse` (
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE importRecordID INTEGER DEFAULT NULL;
  DECLARE importFileCheck_ID INTEGER DEFAULT NULL;
  DECLARE importFile_common_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 0;
  DECLARE loadsProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- declare cursor for csv2mysql format - All importloadIDs not processed
  DECLARE csv2mysqlStatus CURSOR FOR 
      SELECT l.id
        FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0 FOR UPDATE;
  -- declare cursor for csv2mysql format - All importloadIDs not processed
  DECLARE csv2mysqlStatusFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
  -- declare cursor for csv2mysql format - single importLoadID
  DECLARE csv2mysqlLoadID CURSOR FOR 
      SELECT l.id
  	    FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=0 FOR UPDATE;
  -- declare cursor for csv2mysql format - single importLoadID
  DECLARE csv2mysqlLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
  	    FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=0;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE vhostStatus CURSOR FOR 
      SELECT l.id
  	    FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0 FOR UPDATE;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE vhostStatusFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
  	    FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
  -- declare cursor for combined format - single importLoadID
  DECLARE vhostLoadID CURSOR FOR 
      SELECT l.id
	      FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=0 FOR UPDATE;
  -- declare cursor for combined format - single importLoadID
  DECLARE vhostLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
	      FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=0;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE combinedStatus CURSOR FOR 
      SELECT l.id
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0 FOR UPDATE;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE combinedStatusFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
  -- declare cursor for combined format - single importLoadID
  DECLARE combinedLoadID CURSOR FOR 
      SELECT l.id
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=0 FOR UPDATE;
  -- declare cursor for combined format - single importLoadID
  DECLARE combinedLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=0;
  -- declare cursor for importformatid SET=2 in Python check if common format
  DECLARE commonStatusFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0
         AND l.log_useragent IS NULL;
  -- declare cursor for importformatid SET=2 in Python check if common format
  DECLARE commonLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = importLoad_ID
         AND l.process_status = 0
         AND l.log_useragent IS NULL;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
      CALL apache_logs.errorProcess('process_access_parse', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "csv2mysql,vhost,combined") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be csv2mysql, vhost OR combined';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
  END IF;
  IF importLoad_ID IS NULL THEN
  	IF in_processName = 'csv2mysql' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loadsProcessed
        FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
    ELSEIF in_processName = 'vhost' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loadsProcessed
        FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
    ELSEIF in_processName = 'combined' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loadsProcessed
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
    END IF;
  END IF;	
  SET importProcessID = apache_logs.importProcessID('access_parse', in_processName);
	START TRANSACTION;
	IF in_processName = 'combined' THEN 
    -- importformatid SET=2 in Python check if common format - 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost'
    IF importLoad_ID IS NULL THEN
      OPEN commonStatusFile;
    ELSE
      OPEN commonLoadIDFile;
	  END IF;	
    set_commonformat: LOOP
      IF importLoad_ID IS NULL THEN
        FETCH commonStatusFile INTO importFile_common_ID;
      ELSE
        FETCH commonLoadIDFile INTO importFile_common_ID;
      END IF;
      IF done = true THEN 
        LEAVE set_commonformat;
      END IF;
      UPDATE apache_logs.import_file 
         SET importformatid=1 
       WHERE id = importFile_common_ID;
    END LOOP set_commonformat;
    IF importLoad_ID IS NULL THEN
      CLOSE commonStatusFile;
    ELSE
      CLOSE commonLoadIDFile;
	  END IF;
    SET done = false;
	END IF;	
  -- process import_file TABLE first 
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    OPEN csv2mysqlStatusFile;
  ELSEIF in_processName = 'csv2mysql' THEN
    OPEN csv2mysqlLoadIDFile;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    OPEN vhostStatusFile;
	ELSEIF in_processName = 'vhost' THEN
    OPEN vhostLoadIDFile;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    OPEN combinedStatusFile;
	ELSE
    OPEN combinedLoadIDFile;
  END IF;	
  process_parse_file: LOOP
  	IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
	  	FETCH csv2mysqlStatusFile INTO importFileCheck_ID;
	  ELSEIF in_processName = 'csv2mysql' THEN
		  FETCH csv2mysqlLoadIDFile INTO importFileCheck_ID;
	  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
		  FETCH vhostStatusFile INTO importFileCheck_ID;
  	ELSEIF in_processName = 'vhost' THEN
	  	FETCH vhostLoadIDFile INTO importFileCheck_ID;
	  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
  		FETCH combinedStatusFile INTO importFileCheck_ID;
	  ELSE
		  FETCH combinedLoadIDFile INTO importFileCheck_ID;
    END IF;	
    IF done = true THEN 
      LEAVE process_parse_file;
    END IF;
    IF apache_logs.importFileCheck(importFileCheck_ID, importProcessID, 'parse') = 0 THEN
      ROLLBACK;
      LEAVE process_parse_file;
    END IF;
    SET filesProcessed = filesProcessed + 1;
  END LOOP process_parse_file;
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
		CLOSE csv2mysqlStatusFile;
	ELSEIF in_processName = 'csv2mysql' THEN
		CLOSE csv2mysqlLoadIDFile;
	ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
		CLOSE vhostStatusFile;
	ELSEIF in_processName = 'vhost' THEN
		CLOSE vhostLoadIDFile;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
		CLOSE combinedStatusFile;
	ELSE
		CLOSE combinedLoadIDFile;
	END IF;	
  -- process records 
  SET done = false;
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    OPEN csv2mysqlStatus;
  ELSEIF in_processName = 'csv2mysql' THEN
    OPEN csv2mysqlLoadID;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    OPEN vhostStatus;
	ELSEIF in_processName = 'vhost' THEN
    OPEN vhostLoadID;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    OPEN combinedStatus;
	ELSE
    OPEN combinedLoadID;
  END IF;	
  process_parse: LOOP
    IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
      FETCH csv2mysqlStatus INTO importRecordID;
    ELSEIF in_processName = 'csv2mysql' THEN
      FETCH csv2mysqlLoadID INTO importRecordID;
    ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
      FETCH vhostStatus INTO importRecordID;
    ELSEIF in_processName = 'vhost' THEN
      FETCH vhostLoadID INTO importRecordID;
    ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
      FETCH combinedStatus INTO importRecordID;
    ELSE
      FETCH combinedLoadID INTO importRecordID;
    END IF;	
    IF done = true THEN 
      LEAVE process_parse;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
    -- IF in_processName = 'csv2mysql' THEN
    -- by default, no parsing required for csv2mysql format 
    IF in_processName = 'vhost' THEN
      UPDATE apache_logs.load_access_vhost 
      SET server_name = SUBSTR(log_server, 1, LOCATE(':', log_server)-1) 
      WHERE id=importRecordID AND LOCATE(':', log_server)>0;
      
      UPDATE apache_logs.load_access_vhost 
      SET server_port = SUBSTR(log_server, LOCATE(':', log_server)+1) 
      WHERE id=importRecordID AND LOCATE(':', log_server)>0;
      
      UPDATE apache_logs.load_access_vhost 
      SET req_method = SUBSTR(first_line_request, 1, LOCATE(' ', first_line_request)-1) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_uri = SUBSTR(first_line_request,LOCATE(' ', first_line_request)+1,LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)-LOCATE(' ', first_line_request)-1) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_protocol = SUBSTR(first_line_request, LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_query = SUBSTR(req_uri, LOCATE('?', req_uri)) 
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE apache_logs.load_access_vhost 
      SET req_uri = SUBSTR(req_uri, 1, LOCATE('?', req_uri)-1) 
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE apache_logs.load_access_vhost 
      SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request' 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) NOT RLIKE '^[A-Z]|-';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request' 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^-';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_protocol = TRIM(req_protocol)
      WHERE id=importRecordID;
      
      UPDATE apache_logs.load_access_vhost 
      SET log_time = CONCAT(log_time_a, ' ', log_time_b)
      WHERE id=importRecordID;

    ELSEIF in_processName = 'combined' THEN
      UPDATE apache_logs.load_access_combined 
      SET req_method = SUBSTR(first_line_request, 1, LOCATE(' ', first_line_request)-1) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_combined 
      SET req_uri = SUBSTR(first_line_request, LOCATE(' ', first_line_request)+1, LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)-LOCATE(' ', first_line_request)-1) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_combined 
      SET req_protocol = SUBSTR(first_line_request, LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_combined 
      SET req_query = SUBSTR(req_uri,LOCATE('?', req_uri)) 
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE apache_logs.load_access_combined 
      SET req_uri = SUBSTR(req_uri, 1, LOCATE('?', req_uri)-1) 
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE apache_logs.load_access_combined 
      SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request' 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) NOT RLIKE '^[A-Z]|-';
      
      UPDATE apache_logs.load_access_combined 
      SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request' 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^-';
      
      UPDATE apache_logs.load_access_combined 
      SET req_protocol = TRIM(req_protocol) 
      WHERE id=importRecordID;
      
      UPDATE apache_logs.load_access_combined 
      SET log_time = CONCAT(log_time_a, ' ', log_time_b) 
      WHERE id=importRecordID;
    END IF;
    IF in_processName = 'csv2mysql' THEN
      UPDATE apache_logs.load_access_csv2mysql SET process_status=1 WHERE id=importRecordID;
    ELSEIF in_processName = 'vhost' THEN
      UPDATE apache_logs.load_access_vhost SET process_status=1 WHERE id=importRecordID;
    ELSE
      UPDATE apache_logs.load_access_combined SET process_status=1 WHERE id=importRecordID;
    END IF;	
  END LOOP process_parse;
  -- to remove SQL calculating loadsProcessed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND recordsProcessed=0 THEN
    SET loadsProcessed = 0;
  END IF;
  -- update import process table
 	UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed, 
         loads = loadsProcessed, 
         importloadid = importLoad_ID,
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
  COMMIT;
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    CLOSE csv2mysqlStatus;
  ELSEIF in_processName = 'csv2mysql' THEN
    CLOSE csv2mysqlLoadID;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    CLOSE vhostStatus;
  ELSEIF in_processName = 'vhost' THEN
    CLOSE vhostLoadID;
  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    CLOSE combinedStatus;
  ELSE
    CLOSE combinedLoadID;
  END IF;	
END//
DELIMITER ;
-- # Stored Procedure Access Log import from LOAD TABLE and normalization below
-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `process_access_import`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `process_access_import` (
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE importRecordID INTEGER DEFAULT NULL;
  DECLARE importFileCheck_ID INTEGER DEFAULT NULL;
  DECLARE importFile_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 0;
  DECLARE loadsProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- LOAD DATA staging table column variables
  DECLARE logTime VARCHAR(50) DEFAULT NULL;
  DECLARE logTimeConverted DATETIME DEFAULT now();
  DECLARE remoteLogName VARCHAR(150) DEFAULT NULL;
  DECLARE remoteUser VARCHAR(150) DEFAULT NULL;
  DECLARE bytesReceived INTEGER DEFAULT 0;
  DECLARE bytesSent INTEGER DEFAULT 0;
  DECLARE bytesTransferred INTEGER DEFAULT 0;
  DECLARE reqTimeMilli INTEGER DEFAULT 0;
  DECLARE reqTimeMicro INTEGER DEFAULT 0;
  DECLARE reqDelayMilli INTEGER DEFAULT 0;
  DECLARE reqBytes INTEGER DEFAULT 0;
  DECLARE reqStatus INTEGER DEFAULT 0;
  DECLARE reqProtocol VARCHAR(30) DEFAULT NULL;
  DECLARE reqMethod VARCHAR(50) DEFAULT NULL;
  DECLARE reqUri VARCHAR(2000) DEFAULT NULL;
  DECLARE reqQuery VARCHAR(2000) DEFAULT NULL;
  DECLARE reqQueryConverted VARCHAR(2000) DEFAULT NULL;
  DECLARE referer VARCHAR(1000) DEFAULT NULL;
  DECLARE refererConverted VARCHAR(2000) DEFAULT NULL;
  DECLARE userAgent VARCHAR(2000) DEFAULT NULL;
  DECLARE logCookie VARCHAR(400) DEFAULT NULL;
  DECLARE logCookieConverted VARCHAR(400) DEFAULT NULL;
  DECLARE client VARCHAR(253) DEFAULT NULL;
  DECLARE server VARCHAR(253) DEFAULT NULL;
  DECLARE serverPort INTEGER DEFAULT NULL;
  DECLARE serverFile VARCHAR(253) DEFAULT NULL;
  DECLARE serverPortFile INTEGER DEFAULT NULL;
  DECLARE requestLogID VARCHAR(50) DEFAULT NULL;
  DECLARE importFile VARCHAR(300) DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
  DECLARE remoteLogName_Id, 
          remoteUser_Id, 
          reqStatus_Id, 
          reqProtocol_Id, 
          reqMethod_Id, 
          reqUri_Id, 
          reqQuery_Id, 
          referer_Id, 
          userAgent_Id, 
          logCookie_Id, 
          client_Id, 
          server_Id, 
          serverPort_Id, 
          requestLog_Id INTEGER DEFAULT NULL;
  -- declare cursor for csv2mysql format - All importloadIDs not processed
  DECLARE csv2mysqlStatus CURSOR FOR 
      SELECT l.remote_host, 
             l.remote_logname, 
             l.remote_user, 
             l.log_time, 
             l.bytes_received, 
             l.bytes_sent, 
             l.bytes_transferred, 
             l.reqtime_milli, 
             l.reqtime_micro, 
             l.reqdelay_milli, 
             l.req_bytes, 
             l.req_status, 
             l.req_protocol, 
             l.req_method, 
             l.req_uri, 
             l.req_query, 
             l.log_referer, 
             l.log_useragent,
             l.log_cookie,
             l.server_name, 
             l.server_port, 
             l.request_log_id,
             l.importfileid,
             f.server_name server_name_file, 
             f.server_port server_port_file, 
             l.id 
        FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status=1 FOR UPDATE;
  -- declare cursor for csv2mysql format - All importloadIDs not processed
  DECLARE csv2mysqlStatusFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status=1;
  -- declare cursor for csv2mysql format - single importLoadID
  DECLARE csv2mysqlLoadID CURSOR FOR 
      SELECT l.remote_host, 
             l.remote_logname, 
             l.remote_user, 
             l.log_time, 
             l.bytes_received, 
             l.bytes_sent, 
             l.bytes_transferred, 
             l.reqtime_milli, 
             l.reqtime_micro, 
             l.reqdelay_milli, 
             l.req_bytes, 
             l.req_status, 
             l.req_protocol, 
             l.req_method, 
             l.req_uri, 
             l.req_query, 
             l.log_referer, 
             l.log_useragent,
             l.log_cookie,
             l.server_name, 
             l.server_port, 
             l.request_log_id, 
             l.importfileid,
             f.server_name server_name_file, 
             f.server_port server_port_file, 
             l.id 
  	    FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=1 FOR UPDATE;
  -- declare cursor for csv2mysql format - single importLoadID
  DECLARE csv2mysqlLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
  	    FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=1;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE vhostStatus CURSOR FOR 
      SELECT l.remote_host, 
             l.remote_logname, 
             l.remote_user, 
             l.log_time, 
             l.req_bytes, 
             l.req_status, 
             l.req_protocol, 
             l.req_method, 
             l.req_uri, 
             l.req_query, 
             l.log_referer, 
             l.log_useragent,
             l.server_name, 
             l.server_port, 
             l.importfileid,
             f.server_name server_name_file, 
             f.server_port server_port_file, 
             l.id 
  	    FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status=1 FOR UPDATE;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE vhostStatusFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
  	    FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status=1;
  -- declare cursor for combined format - single importLoadID
  DECLARE vhostLoadID CURSOR FOR 
      SELECT l.remote_host, 
             l.remote_logname, 
             l.remote_user, 
             l.log_time, 
             l.req_bytes, 
             l.req_status, 
             l.req_protocol, 
             l.req_method, 
             l.req_uri, 
             l.req_query, 
             l.log_referer, 
             l.log_useragent,
             l.server_name, 
             l.server_port, 
             l.importfileid,
             f.server_name server_name_file, 
             f.server_port server_port_file, 
             l.id 
	      FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=1 FOR UPDATE;
  -- declare cursor for combined format - single importLoadID
  DECLARE vhostLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
	      FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=1;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE combinedStatus CURSOR FOR 
      SELECT l.remote_host, 
             l.remote_logname, 
             l.remote_user, 
             l.log_time, 
             l.req_bytes, 
             l.req_status, 
             l.req_protocol, 
             l.req_method, 
             l.req_uri, 
             l.req_query, 
             l.log_referer, 
             l.log_useragent,
             l.server_name, 
             l.server_port, 
             l.importfileid,
             f.server_name server_name_file, 
             f.server_port server_port_file, 
             l.id 
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status=1 FOR UPDATE;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE combinedStatusFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status=1;
  -- declare cursor for combined format - single importLoadID
  DECLARE combinedLoadID CURSOR FOR 
      SELECT l.remote_host, 
             l.remote_logname, 
             l.remote_user, 
             l.log_time, 
             l.req_bytes, 
             l.req_status, 
             l.req_protocol, 
             l.req_method, 
             l.req_uri, 
             l.req_query, 
             l.log_referer, 
             l.log_useragent,
             l.server_name, 
             l.server_port, 
             l.importfileid,
             f.server_name server_name_file, 
             f.server_port server_port_file, 
             l.id 
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=1 FOR UPDATE;
  -- declare cursor for combined format - single importLoadID
  DECLARE combinedLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=1;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
      CALL apache_logs.errorProcess('process_access_import', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "csv2mysql,vhost,combined") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be csv2mysql, vhost OR combined';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
  END IF;
  IF importLoad_ID IS NULL THEN
    IF in_processName = 'csv2mysql' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loadsProcessed
        FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
      ELSEIF in_processName = 'vhost' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loadsProcessed
        FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
    ELSEIF in_processName = 'combined' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loadsProcessed
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
    END IF;	
  END IF;	
  SET importProcessID = apache_logs.importProcessID('access_import', in_processName);
  START TRANSACTION;
  -- process import_file TABLE first 
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    OPEN csv2mysqlStatusFile;
  ELSEIF in_processName = 'csv2mysql' THEN
    OPEN csv2mysqlLoadIDFile;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    OPEN vhostStatusFile;
  ELSEIF in_processName = 'vhost' THEN
    OPEN vhostLoadIDFile;
  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    OPEN combinedStatusFile;
  ELSE
    OPEN combinedLoadIDFile;
  END IF;	
  process_import_file: LOOP
    IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
      FETCH csv2mysqlStatusFile INTO importFileCheck_ID; 
    ELSEIF in_processName = 'csv2mysql' THEN
      FETCH csv2mysqlLoadIDFile INTO importFileCheck_ID;
    ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
      FETCH vhostStatusFile INTO importFileCheck_ID; 
    ELSEIF in_processName = 'vhost' THEN
      FETCH vhostLoadIDFile INTO importFileCheck_ID; 
    ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
      FETCH combinedStatusFile INTO importFileCheck_ID; 
    ELSE
      FETCH combinedLoadIDFile INTO importFileCheck_ID; 
    END IF;	
    IF done = true THEN 
      LEAVE process_import_file;
    END IF;
    IF apache_logs.importFileCheck(importFileCheck_ID, importProcessID, 'import') = 0 THEN
      ROLLBACK;
      LEAVE process_import_file;
    END IF;
    SET filesProcessed = filesProcessed + 1;
  END LOOP process_import_file;
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    CLOSE csv2mysqlStatusFile;
  ELSEIF in_processName = 'csv2mysql' THEN
    CLOSE csv2mysqlLoadIDFile;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    CLOSE vhostStatusFile;
  ELSEIF in_processName = 'vhost' THEN
    CLOSE vhostLoadIDFile;
  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    CLOSE combinedStatusFile;
  ELSE
    CLOSE combinedLoadIDFile;
  END IF;	
  -- process records 
  SET done = false;
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    OPEN csv2mysqlStatus;
  ELSEIF in_processName = 'csv2mysql' THEN
    OPEN csv2mysqlLoadID;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    OPEN vhostStatus;
  ELSEIF in_processName = 'vhost' THEN
    OPEN vhostLoadID;
  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    OPEN combinedStatus;
  ELSE
    OPEN combinedLoadID;
  END IF;	
  process_import: LOOP
    IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
      FETCH csv2mysqlStatus INTO 
            client, 
            remoteLogName, 
            remoteUser, 
            logTime, 
            bytesReceived, 
            bytesSent, 
            bytesTransferred, 
            reqTimeMilli, 
            reqTimeMicro, 
            reqDelayMilli, 
            reqBytes, 
            reqStatus, 
            reqProtocol, 
            reqMethod, 
            reqUri, 
            reqQuery, 
            referer, 
            userAgent,
            logCookie,
            server, 
            serverPort, 
            requestLogID, 
            importFile_ID,
            serverFile, 
            serverPortFile, 
            importRecordID; 
    ELSEIF in_processName = 'csv2mysql' THEN
      FETCH csv2mysqlLoadID INTO 
            client, 
            remoteLogName, 
            remoteUser, 
            logTime, 
            bytesReceived, 
            bytesSent, 
            bytesTransferred, 
            reqTimeMilli, 
            reqTimeMicro, 
            reqDelayMilli, 
            reqBytes, 
            reqStatus, 
            reqProtocol, 
            reqMethod, 
            reqUri, 
            reqQuery, 
            referer, 
            userAgent,
            logCookie,
            server, 
            serverPort, 
            requestLogID, 
            importFile_ID,
            serverFile, 
            serverPortFile, 
            importRecordID; 
    ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
      FETCH vhostStatus INTO 
            client, 
            remoteLogName, 
            remoteUser, 
            logTime, 
            reqBytes, 
            reqStatus, 
            reqProtocol, 
            reqMethod, 
            reqUri, 
            reqQuery, 
            referer, 
            userAgent,
            server, 
            serverPort, 
            importFile_ID,
            serverFile, 
            serverPortFile, 
            importRecordID; 
    ELSEIF in_processName = 'vhost' THEN
      FETCH vhostLoadID INTO 
            client, 
            remoteLogName, 
            remoteUser, 
            logTime, 
            reqBytes, 
            reqStatus, 
            reqProtocol, 
            reqMethod, 
            reqUri, 
            reqQuery, 
            referer, 
            userAgent,
            server, 
            serverPort, 
            importFile_ID,
            serverFile, 
            serverPortFile, 
            importRecordID; 
    ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
      FETCH combinedStatus INTO 
            client, 
            remoteLogName, 
            remoteUser, 
            logTime, 
            reqBytes, 
            reqStatus, 
            reqProtocol, 
            reqMethod, 
            reqUri, 
            reqQuery, 
            referer, 
            userAgent,
            server, 
            serverPort, 
            importFile_ID,
            serverFile, 
            serverPortFile, 
            importRecordID; 
    ELSE
      FETCH combinedLoadID INTO 
            client, 
            remoteLogName, 
            remoteUser, 
            logTime, 
            reqBytes, 
            reqStatus, 
            reqProtocol, 
            reqMethod, 
            reqUri, 
            reqQuery, 
            referer, 
            userAgent,
            server, 
            serverPort, 
            importFile_ID,
            serverFile, 
            serverPortFile, 
            importRecordID; 
    END IF;	
    IF done = true THEN 
      LEAVE process_import;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
    SET remoteLogName_Id = null, 
        remoteUser_Id = null, 
        reqStatus_Id = null, 
        reqProtocol_Id = null, 
        reqMethod_Id = null, 
        reqUri_Id = null, 
        reqQuery_Id = null, 
        referer_Id = null, 
        userAgent_Id = null, 
        logCookie_Id = null, 
        client_Id = null, 
        server_Id = null, 
        serverPort_Id = null,
        requestLog_Id = null;
    -- any customizing for business needs should be done here before normalization functions called.
    -- convert import staging columns - reqQuery, referer, log_time and log_cookie in import for audit purposes
    IF LOCATE("?", reqQuery)>0 THEN
      SET reqQueryConverted = SUBSTR(reqQuery, LOCATE("?", reqQuery)+1);
    ELSE
      SET reqQueryConverted = reqQuery;
    END IF;
    IF LOCATE("?", referer)>0 THEN
      SET refererConverted = SUBSTR(referer,1,LOCATE("?", referer)-1);
    ELSE
      SET refererConverted = referer;
    END IF;
    IF LOCATE("[", logTime)>0 THEN
      SET logTimeConverted = STR_TO_DATE(SUBSTR(logTime, 2, 20), '%d/%b/%Y:%H:%i:%s');
    ELSE
      SET logTimeConverted = STR_TO_DATE(SUBSTR(logTime, 1, 20), '%d/%b/%Y:%H:%i:%s');
    END IF;
    IF logCookie IS NULL OR logCookie = '-' THEN
      SET logCookieConverted = NULL;
    ELSEIF LOCATE('.', logCookie) > 0 THEN
      SET logCookieConverted = SUBSTR(logCookie, 3, LOCATE('.', logCookie)-3);
    ELSE
      SET logCookieConverted = logCookie;
    END IF;
    -- normalize import staging table 
    IF reqProtocol IS NOT NULL THEN
      SET reqProtocol_Id = apache_logs.access_reqProtocolID(reqProtocol);
    END IF;
    IF reqMethod IS NOT NULL THEN
      SET reqMethod_Id = apache_logs.access_reqMethodID(reqMethod);
    END IF;
    IF reqStatus IS NOT NULL THEN
      SET reqStatus_Id = apache_logs.access_reqStatusID(reqStatus);
    END IF;
    IF reqUri IS NOT NULL THEN
      SET reqUri_Id = apache_logs.access_reqUriID(reqUri);
    END IF;
    IF reqQueryConverted IS NOT NULL THEN
      SET reqQuery_Id = apache_logs.access_reqQueryID(reqQueryConverted);
    END IF;
    IF remoteLogName IS NOT NULL AND remoteLogName != '-' THEN
      SET remoteLogName_Id = apache_logs.access_remoteLogNameID(remoteLogName);
    END IF;
    IF remoteUser IS NOT NULL AND remoteUser != '-' THEN
      SET remoteUser_Id = apache_logs.access_remoteUserID(remoteUser);
    END IF;
    IF userAgent IS NOT NULL THEN
      SET userAgent_Id = apache_logs.access_userAgentID(userAgent);
    END IF;
    IF logCookieConverted IS NOT NULL THEN
      SET logCookie_Id = apache_logs.access_cookieID(logCookieConverted);
    END IF;
    IF refererConverted IS NOT NULL AND refererConverted != '-' THEN
      SET referer_Id = apache_logs.log_refererID(refererConverted);
    END IF;
    IF client IS NOT NULL THEN
      SET client_Id = apache_logs.log_clientID(client);
    END IF;
    IF server IS NOT NULL THEN
      SET server_Id = apache_logs.log_serverID(server);
    ELSEIF serverFile IS NOT NULL THEN
      SET server_Id = apache_logs.log_serverID(serverFile);
    END IF;
    IF serverPort IS NOT NULL THEN
      SET serverPort_Id = apache_logs.log_serverPortID(serverPort);
    ELSEIF serverPortFile IS NOT NULL THEN
      SET serverPort_Id = apache_logs.log_serverPortID(serverPortFile);
    END IF;
    IF requestLogID IS NOT NULL AND requestLogID != '-' THEN
      IF server_Id IS NOT NULL THEN
        SET requestLogID = CONCAT(requestLogID, '_', CONVERT(server_Id, CHAR));
      END IF;
      SET requestLog_Id = apache_logs.log_requestLogID(requestLogID);
    END IF;
    INSERT INTO apache_logs.access_log 
      (logged, 
       bytes_received,
       bytes_sent,
       bytes_transferred,
       reqtime_milli,
       reqtime_micro,
       reqdelay_milli,
       reqbytes,
       reqstatusid, 
       reqprotocolid, 
       reqmethodid, 
       requriid, 
       reqqueryid, 
       remotelognameid,
       remoteuserid, 
       useragentid,
       cookieid,
       refererid, 
       clientid,
       serverid, 
       serverportid, 
       requestlogid, 
       importfileid) 
    VALUES
      (logTimeConverted,
       bytesReceived,
       bytesSent,
       bytesTransferred,
       reqTimeMilli,
       reqTimeMicro,
       reqDelayMilli,
       reqBytes,
       reqStatus_Id,
       reqProtocol_Id,
       reqMethod_Id,
       reqUri_Id,
       reqQuery_Id,
       remoteLogName_Id,
       remoteUser_Id,
       userAgent_Id,
       logCookie_Id,
       referer_Id,
       client_Id,
       server_Id, 
       serverPort_Id, 
       requestLog_Id, 
       importFile_ID);
    IF in_processName = 'csv2mysql' THEN
      UPDATE apache_logs.load_access_csv2mysql SET process_status=2 WHERE id=importRecordID;
    ELSEIF in_processName = 'vhost' THEN
      UPDATE apache_logs.load_access_vhost SET process_status=2 WHERE id=importRecordID;
    ELSE
      UPDATE apache_logs.load_access_combined SET process_status=2 WHERE id=importRecordID;
    END IF;	
  END LOOP process_import;
  -- to remove SQL calculating loadsProcessed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND recordsProcessed=0 THEN
    SET loadsProcessed = 0;
  END IF;
  -- update import process table
  UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed, 
         loads = loadsProcessed, 
         importloadid = importLoad_ID, 
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
  COMMIT;
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    CLOSE csv2mysqlStatus;
  ELSEIF in_processName = 'csv2mysql' THEN
    CLOSE csv2mysqlLoadID;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    CLOSE vhostStatus;
  ELSEIF in_processName = 'vhost' THEN
    CLOSE vhostLoadID;
  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    CLOSE combinedStatus;
  ELSE
    CLOSE combinedLoadID;
  END IF;	
END//
DELIMITER ;
-- # Stored Procedure Error Log parsing performed on LOAD TABLE data below
-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `process_error_parse`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `process_error_parse` (
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE importRecordID INTEGER DEFAULT NULL;
  DECLARE importFileCheck_ID INTEGER DEFAULT NULL;
  DECLARE importFile_vhost_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 0;
  DECLARE loadsProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- declare cursor for default format - single importLoadID
  DECLARE defaultByLoadID CURSOR FOR 
      SELECT l.id
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status = 0 FOR UPDATE;
  DECLARE defaultByLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status = 0;
  DECLARE defaultByStatus CURSOR FOR 
      SELECT l.id
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0 FOR UPDATE;
  DECLARE defaultByStatusFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
  DECLARE vhostByLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status = 0
         AND LOCATE(' ,', l.log_parse1)>0 OR LOCATE(' ,', l.log_parse2)>0;
  DECLARE vhostByStatusFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0
         AND LOCATE(' ,', l.log_parse1)>0 OR LOCATE(' ,', l.log_parse2)>0;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
      CALL apache_logs.errorProcess('process_error_parse', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
      ROLLBACK;
    END;
	-- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "default") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be default';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
  END IF;
  IF importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_error_default l 
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
INNER JOIN apache_logs.import_load il 
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL 
       AND l.process_status = 0;
  END IF;
  SET importProcessID = apache_logs.importProcessID('error_parse', in_processName);
  START TRANSACTION;
  IF importLoad_ID IS NULL THEN
    -- importformatid SET=5 in Python check if error_vhost format - 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost'
    OPEN vhostByStatusFile;
  ELSE
    -- importformatid SET=5 in Python check if error_vhost format - 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost'
    OPEN vhostByLoadIDFile;
  END IF;
  set_vhostformat: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH vhostByStatusFile INTO importFile_vhost_ID;
    ELSE
      FETCH vhostByLoadIDFile INTO importFile_vhost_ID;
    END IF;
    IF done = true THEN 
      LEAVE set_vhostformat;
    END IF;
    UPDATE apache_logs.import_file 
       SET importformatid=6 
     WHERE id = importFile_vhost_ID;
  END LOOP set_vhostformat;
  IF importLoad_ID IS NULL THEN
    CLOSE vhostByStatusFile;
  ELSE
    CLOSE vhostByLoadIDFile;
  END IF;
  -- process import_file TABLE first 
  SET done = false;
  IF importLoad_ID IS NULL THEN
    OPEN defaultByStatusFile;
  ELSE
    OPEN defaultByLoadIDFile;
  END IF;
  process_parse_file: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH defaultByStatusFile INTO importFileCheck_ID;
    ELSE
      FETCH defaultByLoadIDFile INTO importFileCheck_ID;
    END IF;
    IF done = true THEN 
      LEAVE process_parse_file;
    END IF;
    IF apache_logs.importFileCheck(importFileCheck_ID, importProcessID, 'parse') = 0 THEN
      ROLLBACK;
      LEAVE process_parse_file;
    END IF;
    SET filesProcessed = filesProcessed + 1;
  END LOOP process_parse_file;
  IF importLoad_ID IS NULL THEN
    CLOSE defaultByStatusFile;
  ELSE
    CLOSE defaultByLoadIDFile;
  END IF;
  -- process records 
  SET done = false;
  IF importLoad_ID IS NULL THEN
    OPEN defaultByStatus;
  ELSE
    OPEN defaultByLoadID;
  END IF;
  process_parse: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH defaultByStatus INTO importRecordID;
    ELSE
      FETCH defaultByLoadID INTO importRecordID;
    END IF;
    IF done = true THEN 
      LEAVE process_parse;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
    UPDATE apache_logs.load_error_default 
       SET module = SUBSTR(log_mod_level,3, LOCATE(':', log_mod_level)-3),
           loglevel = SUBSTR(log_mod_level, LOCATE(':', log_mod_level)+1),
           processid = SUBSTR(log_processid_threadid, LOCATE('pid', log_processid_threadid)+4, LOCATE(':', log_processid_threadid)-LOCATE('pid', log_processid_threadid)-4),
           threadid = SUBSTR(log_processid_threadid, LOCATE('tid', log_processid_threadid)+4),
           logtime = STR_TO_DATE(SUBSTR(log_time, 2, 31),'%a %b %d %H:%i:%s.%f %Y')
     WHERE id = importRecordID;

    UPDATE apache_logs.load_error_default 
       SET apachecode = SUBSTR(log_parse1, 2, LOCATE(':', log_parse1)-2) 
     WHERE id = importRecordID AND LEFT(log_parse1, 2)=' A';
    UPDATE apache_logs.load_error_default 
       SET apachecode = SUBSTR(log_parse2, 2, LOCATE(':', log_parse2)-2) 
     WHERE id = importRecordID AND LEFT(log_parse2, 2)=' A';
    UPDATE apache_logs.load_error_default 
       SET apachecode = SUBSTR(log_parse1, LOCATE(': AH', log_parse1)+2, LOCATE(':', log_parse1, (LOCATE(': AH', log_parse1)+2))-LOCATE(': AH', log_parse1)-2) 
     WHERE id = importRecordID AND LOCATE(': AH', log_parse1)>0;

    UPDATE apache_logs.load_error_default 
       SET apachemessage = SUBSTR(log_parse1, LOCATE(':', log_parse1)+1) 
     WHERE id = importRecordID AND LEFT(log_parse1, 2)=' A';
    UPDATE apache_logs.load_error_default 
       SET apachemessage = SUBSTR(log_parse2, LOCATE(':', log_parse2)+1) 
     WHERE id = importRecordID AND LEFT(log_parse2, 2)=' A' AND LOCATE('referer:', log_parse2)=0;
    UPDATE apache_logs.load_error_default 
       SET apachemessage = SUBSTR(log_parse2, LOCATE(':', log_parse2)+1, LOCATE(', referer:', log_parse2)-LOCATE(':', log_parse2)-1) 
     WHERE id = importRecordID AND LEFT(log_parse2, 2)=' A' AND LOCATE(', referer:', log_parse2)>0;
    UPDATE apache_logs.load_error_default 
       SET apachemessage = SUBSTR(log_parse1, LOCATE(':', log_parse1, LOCATE(': AH', log_parse1)+2)+2) 
     WHERE id = importRecordID AND LOCATE(': AH', log_parse1)>0;

    UPDATE apache_logs.load_error_default 
       SET client_name = SUBSTR(log_parse1, LOCATE('[client', log_parse1)+8) 
     WHERE id = importRecordID AND LOCATE('[client', log_parse1)>0;

    UPDATE apache_logs.load_error_default 
       SET client_port = SUBSTR(client_name, LOCATE(':', client_name)+1) 
     WHERE id = importRecordID AND LOCATE(':', client_name)>0;

    UPDATE apache_logs.load_error_default 
       SET client_name = SUBSTR(client_name, 1, LOCATE(':', client_name)-1) 
     WHERE id = importRecordID AND LOCATE(':', client_name)>0;

    UPDATE apache_logs.load_error_default 
       SET systemcode = SUBSTR(log_parse1, LOCATE('(', log_parse1), LOCATE(':', log_parse1, LOCATE('(', log_parse1))-LOCATE('(', log_parse1)) 
     WHERE id = importRecordID AND LOCATE('(', log_parse1)>0 AND LOCATE(':', log_parse1, LOCATE('(', log_parse1))-LOCATE('(', log_parse1)>0;

    UPDATE apache_logs.load_error_default 
       SET systemmessage = SUBSTR(log_parse1, LOCATE(':', log_parse1) + 1) 
     WHERE id = importRecordID AND LOCATE('(', log_parse1)>0 AND LOCATE(':', log_parse1, LOCATE('(', log_parse1))-LOCATE('(', log_parse1)>0 AND apachecode IS NULL;

    UPDATE apache_logs.load_error_default 
       SET log_message_nocode = log_parse1 
     WHERE id = importRecordID AND systemcode IS NULL AND apachecode IS NULL;

    UPDATE apache_logs.load_error_default 
       SET module = SUBSTR(log_parse1, 2, LOCATE(':', log_parse1)-2) 
     WHERE id = importRecordID AND systemcode IS NULL AND apachecode IS NULL AND LENGTH(module)=0 AND LOCATE(':', log_parse1)>0 AND LOCATE(' ', log_parse1, 2)>LOCATE(':', log_parse1);

    UPDATE apache_logs.load_error_default 
       SET logmessage = SUBSTR(log_parse1, LOCATE(':', log_parse1)+1) 
     WHERE id = importRecordID AND systemcode IS NULL AND apachecode IS NULL AND LOCATE(':', log_parse1)>0 AND LOCATE(' ', log_parse1,2)>LOCATE(':', log_parse1);

    UPDATE apache_logs.load_error_default 
       SET logmessage = log_message_nocode 
     WHERE id = importRecordID AND logmessage IS NULL AND log_message_nocode IS NOT NULL;

    UPDATE apache_logs.load_error_default 
       SET referer = SUBSTR(log_parse2, LOCATE('referer:', log_parse2)+8) 
     WHERE id = importRecordID AND LOCATE('referer:', log_parse2)>0;

    -- 12/07/2024 @ 4:55AM - server_name and request_log_id parsing - if either exists
    -- referer
    UPDATE apache_logs.load_error_default 
       SET request_log_ID=SUBSTR(referer,LOCATE(' ,', referer, LOCATE(' ,', referer)+2)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', referer, LOCATE(' ,', referer)+2)>0;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(referer, LOCATE(' ,',referer)+2, LOCATE(' ,',referer, LOCATE(' ,',referer)+2)-LOCATE(' ,', referer)-2) 
     WHERE id = importRecordID AND LOCATE(' ,', referer, LOCATE(' ,',referer)+2)>0;

--    UPDATE apache_logs.load_error_default 
--       SET server_name=SUBSTR(referer, LOCATE(' ,',referer)+2) 
--     WHERE id = importRecordID AND LOCATE(' ,', referer)>0 AND server_name IS NULL;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(referer, LOCATE(' ,',referer)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', referer)>0 AND LOCATE(' ,', referer, LOCATE(' ,',referer)+2)=0;

    UPDATE apache_logs.load_error_default 
       SET referer=SUBSTR(referer, 1, LOCATE(' ,', referer)) 
     WHERE id = importRecordID AND LOCATE(' ,', referer)>0;
    -- logmessage
    UPDATE apache_logs.load_error_default 
       SET request_log_ID=SUBSTR(logmessage, LOCATE(' ,', logmessage, LOCATE(' ,',logmessage)+2)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', logmessage, LOCATE(' ,',logmessage)+2)>0;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(logmessage, LOCATE(' ,',logmessage)+2, LOCATE(' ,',logmessage,LOCATE(' ,',logmessage)+2)-LOCATE(' ,',logmessage)-2) 
     WHERE id = importRecordID AND LOCATE(' ,', logmessage, LOCATE(' ,', logmessage)+2)>0;

--    UPDATE apache_logs.load_error_default 
--       SET server_name=SUBSTR(logmessage, LOCATE(' ,', logmessage)+2) 
--     WHERE id = importRecordID AND LOCATE(' ,', logmessage)>0 AND server_name IS NULL;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(logmessage, LOCATE(' ,', logmessage)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', logmessage, LOCATE(' ,', logmessage)+2)=0 AND LOCATE(' ,', logmessage)>0;

    UPDATE apache_logs.load_error_default 
       SET logmessage=SUBSTR(logmessage, 1, LOCATE(' ,', logmessage)) 
     WHERE id = importRecordID AND LOCATE(' ,', logmessage)>0;
    -- systemmessage
    UPDATE apache_logs.load_error_default 
       SET request_log_ID=SUBSTR(systemmessage, LOCATE(' ,', systemmessage, LOCATE(' ,',systemmessage)+2)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', systemmessage, LOCATE(' ,', systemmessage)+2)>0;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(systemmessage, LOCATE(' ,', systemmessage)+2, LOCATE(' ,',systemmessage,LOCATE(' ,',systemmessage)+2)-LOCATE(' ,',systemmessage)-2) 
     WHERE id = importRecordID AND LOCATE(' ,',systemmessage, LOCATE(' ,', systemmessage)+2)>0;

--    UPDATE apache_logs.load_error_default 
--       SET server_name=SUBSTR(systemmessage, LOCATE(' ,', systemmessage)+2) 
--     WHERE id = importRecordID AND LOCATE(' ,', systemmessage)>0 AND server_name IS NULL;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(systemmessage, LOCATE(' ,', systemmessage)+2) 
     WHERE id = importRecordID AND LOCATE(' ,',systemmessage, LOCATE(' ,', systemmessage)+2)=0 AND LOCATE(' ,', systemmessage)>0;

    UPDATE apache_logs.load_error_default 
       SET systemmessage=SUBSTR(systemmessage, 1, LOCATE(' ,', systemmessage)) 
     WHERE id = importRecordID AND LOCATE(' ,', systemmessage)>0;
    -- apachemessage
    UPDATE apache_logs.load_error_default 
       SET request_log_ID=SUBSTR(apachemessage, LOCATE(' ,', apachemessage, LOCATE(' ,',apachemessage)+2)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', apachemessage, LOCATE(' ,', apachemessage)+2)>0;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(apachemessage, LOCATE(' ,', apachemessage)+2, LOCATE(' ,', apachemessage, LOCATE(' ,', apachemessage)+2)-LOCATE(' ,', apachemessage)-2) 
     WHERE id = importRecordID AND LOCATE(' ,', apachemessage, LOCATE(' ,', apachemessage)+2)>0;

--    UPDATE apache_logs.load_error_default 
--       SET server_name=SUBSTR(apachemessage, LOCATE(' ,', apachemessage)+2) 
--     WHERE id = importRecordID AND LOCATE(' ,', apachemessage)>0 AND server_name IS NULL;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(apachemessage, LOCATE(' ,', apachemessage)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', apachemessage, LOCATE(' ,', apachemessage)+2)=0 AND LOCATE(' ,', apachemessage)>0;

    UPDATE apache_logs.load_error_default 
       SET apachemessage=SUBSTR(apachemessage, 1, LOCATE(' ,', apachemessage)) 
     WHERE id = importRecordID AND LOCATE(' ,', apachemessage)>0;

    UPDATE apache_logs.load_error_default 
       SET module=TRIM(module),
           loglevel=TRIM(loglevel),
           processid=TRIM(processid),
           threadid=TRIM(threadid),
           apachecode=TRIM(apachecode),
           apachemessage=TRIM(apachemessage),
           systemcode=TRIM(systemcode),
           systemmessage = TRIM(systemmessage),
           logmessage=TRIM(logmessage),
           client_name=TRIM(client_name),
           referer=TRIM(referer),
           server_name=TRIM(server_name),
           request_log_id=TRIM(request_log_id)
     WHERE id=importRecordID;
    UPDATE apache_logs.load_error_default SET process_status=1 WHERE id=importRecordID;
  END LOOP process_parse;
  -- to remove SQL calculating loadsProcessed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND recordsProcessed=0 THEN
    SET loadsProcessed = 0;
  END IF;
  -- update import process table
  UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed, 
         loads = loadsProcessed, 
         importloadid = importLoad_ID,
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
  COMMIT;
  IF importLoad_ID IS NULL THEN
    CLOSE defaultByStatus;
  ELSE
    CLOSE defaultByLoadID;
  END IF;
END//
DELIMITER ;
-- # Stored Procedure Error Log import from LOAD TABLE and normalization below
-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `process_error_import`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `process_error_import` (
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE importRecordID INTEGER DEFAULT NULL;
  DECLARE importFile_ID INTEGER DEFAULT NULL;
  DECLARE importFileCheck_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 0;
  DECLARE loadsProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- LOAD DATA staging table column variables
  DECLARE log_time DATETIME DEFAULT now();
  DECLARE log_level VARCHAR(100) DEFAULT NULL;
  DECLARE log_module VARCHAR(100) DEFAULT NULL;
  DECLARE log_processid VARCHAR(100) DEFAULT NULL;
  DECLARE log_threadid VARCHAR(100) DEFAULT NULL;
  DECLARE log_apacheCode VARCHAR(400) DEFAULT NULL;
  DECLARE log_apacheMessage VARCHAR(400) DEFAULT NULL;
  DECLARE log_systemCode VARCHAR(400) DEFAULT NULL;
  DECLARE log_systemMessage VARCHAR(400) DEFAULT NULL;
  DECLARE log_message VARCHAR(500) DEFAULT NULL;
  DECLARE log_referer VARCHAR(1000) DEFAULT NULL;
  DECLARE refererConverted VARCHAR(1000) DEFAULT NULL;
  DECLARE client VARCHAR(253) DEFAULT NULL;
  DECLARE clientPort VARCHAR(100) DEFAULT NULL;
  DECLARE server VARCHAR(253) DEFAULT NULL;
  DECLARE serverPort INTEGER DEFAULT NULL;
  DECLARE requestLogID VARCHAR(50) DEFAULT NULL;
  DECLARE serverFile VARCHAR(253) DEFAULT NULL;
  DECLARE serverPortFile INTEGER DEFAULT NULL;
  DECLARE importFile VARCHAR(300) DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
  DECLARE logLevel_Id,
          module_Id,
          process_Id, 
          thread_Id, 
          apacheCode_Id, 
          apacheMessage_Id, 
          systemCode_Id, 
          systemMessage_Id, 
          logMessage_Id, 
          referer_Id,
          client_Id, 
          clientPort_Id, 
          server_Id, 
          serverPort_Id, 
          requestLog_Id INTEGER DEFAULT NULL;
	-- declare cursor for default format - single importLoadID
  DECLARE defaultByLoadID CURSOR FOR 
      SELECT l.logtime, 
             l.loglevel, 
             l.module, 
             l.processid, 
             l.threadid, 
             l.apachecode, 
             l.apachemessage, 
             l.systemcode, 
             l.systemmessage, 
             l.logmessage, 
             l.referer,
             l.client_name, 
             l.client_port, 
             l.server_name, 
             l.server_port, 
             l.request_log_id, 
             l.importfileid,
             f.server_name server_name_file, 
             f.server_port server_port_file, 
             l.id
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status = 1
         AND f.importloadid = CONVERT(in_importLoadID, UNSIGNED);
  DECLARE defaultByLoadIDFile CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status = 1
         AND f.importloadid = CONVERT(in_importLoadID, UNSIGNED);
  DECLARE defaultByStatus CURSOR FOR 
      SELECT l.logtime, 
             l.loglevel, 
             l.module, 
             l.processid, 
             l.threadid, 
             l.apachecode, 
             l.apachemessage, 
             l.systemcode, 
             l.systemmessage, 
             l.logmessage, 
             l.referer,
             l.client_name, 
             l.client_port, 
             l.server_name, 
             l.server_port, 
             l.request_log_id, 
             l.importfileid,
             f.server_name server_name_file, 
             f.server_port server_port_file, 
             l.id
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
  DECLARE defaultByStatusFile CURSOR FOR 
     SELECT DISTINCT(l.importfileid)
       FROM apache_logs.load_error_default l 
 INNER JOIN apache_logs.import_file f 
         ON l.importfileid = f.id
      WHERE l.process_status = 1;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
      CALL apache_logs.errorProcess('process_error_import', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "default") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be default';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
  END IF;
  IF importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_error_default l 
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE l.process_status = 1;
  END IF;
  SET importProcessID = apache_logs.importProcessID('error_import', in_processName);
  START TRANSACTION;
  -- process import_file TABLE first 
  IF importLoad_ID IS NULL THEN
    OPEN defaultByStatusFile;
  ELSE
    OPEN defaultByLoadIDFile;
  END IF;
  process_import_file: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH defaultByStatusFile INTO importFileCheck_ID; 
    ELSE
      FETCH defaultByLoadIDFile INTO importFileCheck_ID; 
    END IF;
    IF done = true THEN 
      LEAVE process_import_file;
    END IF;
    IF apache_logs.importFileCheck(importFileCheck_ID, importProcessID, 'import') = 0 THEN
      ROLLBACK;
      LEAVE process_import_file;
    END IF;
    SET filesProcessed = filesProcessed + 1;
  END LOOP process_import_file;
  IF importLoad_ID IS NULL THEN
    CLOSE defaultByStatusFile;
  ELSE
    CLOSE defaultByLoadIDFile;
  END IF;
  -- process records 
  SET done = false;
  IF importLoad_ID IS NULL THEN
    OPEN defaultByStatus;
  ELSE
    OPEN defaultByLoadID;
  END IF;
  process_import: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH defaultByStatus INTO 
            log_time, 
            log_level,
            log_module,
            log_processid, 
            log_threadid, 
            log_apacheCode, 
            log_apacheMessage, 
            log_systemCode, 
            log_systemMessage, 
            log_message, 
            log_referer, 
            client, 
            clientPort, 
            server, 
            serverPort, 
            requestLogID, 
            importFile_ID,
            serverFile, 
            serverPortFile, 
            importRecordID; 
    ELSE
      FETCH defaultByLoadID INTO 
            log_time, 
            log_level,
            log_module,
            log_processid, 
            log_threadid, 
            log_apacheCode, 
            log_apacheMessage, 
            log_systemCode, 
            log_systemMessage, 
            log_message, 
            log_referer, 
            client, 
            clientPort, 
            server, 
            serverPort, 
            requestLogID, 
            importFile_ID,
            serverFile, 
            serverPortFile, 
            importRecordID; 
    END IF;
    IF done = true THEN 
      LEAVE process_import;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
    SET logLevel_Id = null,
        module_Id = null,
        process_Id = null, 
        thread_Id = null, 
        apacheCode_Id = null, 
        apacheMessage_Id = null, 
        systemCode_Id = null, 
        systemMessage_Id = null, 
        logMessage_Id = null, 
        referer_Id = null,
        client_Id = null, 
        clientPort_Id = null, 
        server_Id = null, 
        serverPort_Id = null,
        requestLog_Id = null;
    -- any customizing for business needs should be done here before normalization functions called.
    -- convert staging columns - log_referer in import for audit purposes
    IF LOCATE("?", log_referer)>0 THEN
      SET refererConverted = SUBSTR(log_referer, 1, LOCATE("?", log_referer)-1);
    ELSE
      SET refererConverted = log_referer;
    END IF;
    -- normalize import staging table 
    IF log_level IS NOT NULL THEN
      SET logLevel_Id = apache_logs.error_logLevelID(log_level);
    END IF;
    IF log_module IS NOT NULL THEN
      SET module_Id = apache_logs.error_moduleID(log_module);
    END IF;
    IF log_processid IS NOT NULL THEN
      SET process_Id = apache_logs.error_processID(log_processid);
    END IF;
    IF log_threadid IS NOT NULL THEN
      SET thread_Id = apache_logs.error_threadID(log_threadid);
    END IF;
    IF log_apacheCode IS NOT NULL THEN
      SET apacheCode_Id = apache_logs.error_apacheCodeID(log_apacheCode);
    END IF;
    IF log_apacheMessage IS NOT NULL THEN
      SET apacheMessage_Id = apache_logs.error_apacheMessageID(log_apacheMessage);
    END IF;
    IF log_systemCode IS NOT NULL THEN
      SET systemCode_Id = apache_logs.error_systemCodeID(log_systemCode);
    END IF;
    IF log_systemMessage IS NOT NULL THEN
      SET systemMessage_Id = apache_logs.error_systemMessageID(log_systemMessage);
    END IF;
    IF log_message IS NOT NULL THEN
      SET logMessage_id = apache_logs.error_logMessageID(log_message);
    END IF;
    IF refererConverted IS NOT NULL AND refererConverted != '-' THEN
      SET referer_Id = apache_logs.log_refererID(refererConverted);
    END IF;
    IF client IS NOT NULL THEN
      SET client_id = apache_logs.log_clientID(client);
    END IF;
    IF clientPort IS NOT NULL THEN
      SET clientPort_id = apache_logs.log_clientPortID(clientPort);
    END IF;
    IF server IS NOT NULL THEN
      SET server_Id = apache_logs.log_serverID(server);
    ELSEIF serverFile IS NOT NULL THEN
      SET server_Id = apache_logs.log_serverID(serverFile);
    END IF;
    IF serverPort IS NOT NULL THEN
      SET serverPort_Id = apache_logs.log_serverPortID(serverPort);
    ELSEIF serverPortFile IS NOT NULL THEN
      SET serverPort_Id = apache_logs.log_serverPortID(serverPortFile);
    END IF;
    IF requestLogID IS NOT NULL AND requestLogID != '-' THEN
      IF server_Id IS NOT NULL THEN
        SET requestLogID = CONCAT(requestLogID, '_', CONVERT(server_Id, CHAR));
      END IF;
      SET requestLog_Id = apache_logs.log_requestLogID(requestLogID);
    END IF;
    INSERT INTO apache_logs.error_log 
       (logged, 
        loglevelid,
        moduleid,
        processid, 
        threadid, 
        apachecodeid, 
        apachemessageid, 
        systemcodeid, 
        systemmessageid, 
        logmessageid, 
        refererid,
        clientid, 
        clientportid, 
        serverid, 
        serverportid,
        requestlogid, 
        importfileid) 
    VALUES
       (log_time,
        logLevel_Id,
        module_Id,
        process_Id, 
        thread_Id, 
        apacheCode_Id, 
        apacheMessage_Id, 
        systemCode_Id, 
        systemMessage_Id, 
        logMessage_Id, 
        referer_Id,
        client_Id, 
        clientPort_Id, 
        server_Id, 
        serverPort_Id, 
        requestLog_Id, 
        importFile_ID);
    UPDATE apache_logs.load_error_default SET process_status=2 WHERE id=importRecordID;
  END LOOP process_import;
  -- to remove SQL calculating loadsProcessed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND recordsProcessed=0 THEN
    SET loadsProcessed = 0;
  END IF;
  -- update import process table
  UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed, 
         loads = loadsProcessed,
         importloadid = importLoad_ID, 
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
  COMMIT;
  IF importLoad_ID IS NULL THEN
    CLOSE defaultByStatus;
  ELSE
    CLOSE defaultByLoadID;
  END IF;
END//
DELIMITER ;
-- # Stored Procedure for Browser User Agent data normalization below
-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `normalize_useragent`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `normalize_useragent` (
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- LOAD DATA staging table column variables
  DECLARE v_ua VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_browser VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_browser_family VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_browser_version VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_os VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_os_family VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_os_version VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_device VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_device_family VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_device_brand VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_device_model VARCHAR(200) DEFAULT NULL;
  DECLARE userAgent_id INTEGER DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
  DECLARE ua_id,
          uabrowser_id,
          uabrowserfamily_id,
          uabrowserversion_id,
          uaos_id,
          uaosfamily_id,
          uaosversion_id,
          uadevice_id,
          uadevicefamily_id,
          uadevicebrand_id,
          uadevicemodel_id INTEGER DEFAULT NULL;
  -- declare cursor for userAgent format
  DECLARE userAgent CURSOR FOR 
    SELECT ua,
           ua_browser,
           ua_browser_family,
           ua_browser_version,
           ua_os,
           ua_os_family,
           ua_os_version,
           ua_device,
           ua_device_family,
           ua_device_brand,
           ua_device_model,
           id
      FROM apache_logs.access_log_useragent
     WHERE uaid IS NULL;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
      CALL apache_logs.errorProcess('normalize_useragent', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF LENGTH(in_processName) < 8 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be minimum of 8 characters';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
  END IF;
  SET importProcessID = apache_logs.importProcessID('normalize_useragent', in_processName);
  OPEN userAgent;
  START TRANSACTION;	
  process_normalize: LOOP
    FETCH userAgent
     INTO v_ua,
          v_ua_browser,
          v_ua_browser_family,
          v_ua_browser_version,
          v_ua_os,
          v_ua_os_family,
          v_ua_os_version,
          v_ua_device,
          v_ua_device_family,
          v_ua_device_brand,
          v_ua_device_model,
          userAgent_id;
    IF done = true THEN 
      LEAVE process_normalize;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
    SET ua_id = null,
        uabrowser_id = null,
        uabrowserfamily_id = null,
        uabrowserversion_id = null,
        uaos_id = null,
        uaosfamily_id = null,
        uaosversion_id = null,
        uadevice_id = null,
        uadevicefamily_id = null,
        uadevicebrand_id = null,
        uadevicemodel_id = null;
        -- normalize import staging table 
    IF v_ua IS NOT NULL THEN
      SET ua_Id = apache_logs.access_uaID(v_ua);
    END IF;
    IF v_ua_browser IS NOT NULL THEN
      SET uabrowser_id = apache_logs.access_uaBrowserID(v_ua_browser);
    END IF;
    IF v_ua_browser_family IS NOT NULL THEN
      SET uabrowserfamily_id = apache_logs.access_uaBrowserFamilyID(v_ua_browser_family);
    END IF;
    IF v_ua_browser_version IS NOT NULL THEN
      SET uabrowserversion_id = apache_logs.access_uaBrowserVersionID(v_ua_browser_version);
    END IF;
    IF v_ua_os IS NOT NULL THEN
      SET uaos_id = apache_logs.access_uaOsID(v_ua_os);
    END IF;
    IF v_ua_os_family IS NOT NULL THEN
      SET uaosfamily_id = apache_logs.access_uaOsFamilyID(v_ua_os_family);
    END IF;
    IF v_ua_os_version IS NOT NULL THEN
      SET uaosversion_id = apache_logs.access_uaOsVersionID(v_ua_os_version);
    END IF;
    IF v_ua_device IS NOT NULL THEN
      SET uadevice_id = apache_logs.access_uaDeviceID(v_ua_device);
    END IF;
    IF v_ua_device_family IS NOT NULL THEN
      SET uadevicefamily_id = apache_logs.access_uaDeviceFamilyID(v_ua_device_family);
    END IF;
    IF v_ua_device_brand IS NOT NULL THEN
      SET uadevicebrand_id = apache_logs.access_uaDeviceBrandID(v_ua_device_brand);
    END IF;
    IF v_ua_device_model IS NOT NULL THEN
      SET uadevicemodel_id = apache_logs.access_uaDeviceModelID(v_ua_device_model);
    END IF;
    UPDATE apache_logs.access_log_useragent 
       SET uaid = ua_id,
           uabrowserid = uabrowser_id,
           uabrowserfamilyid = uabrowserfamily_id,
           uabrowserversionid = uabrowserversion_id,
           uaosid = uaos_id,
           uaosfamilyid = uaosfamily_id,
           uaosversionid = uaosversion_id,
           uadeviceid = uadevice_id,
           uadevicefamilyid = uadevicefamily_id,
           uadevicebrandid = uadevicebrand_id,
           uadevicemodelid = uadevicemodel_id
     WHERE id = userAgent_id;
  END LOOP;
  -- to remove SQL calculating filesProcessed when recordsProcessed = 0. Set=1 by default.
  IF recordsProcessed=0 THEN
    SET filesProcessed = 0;
  END IF;
  -- update import process table
	UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed,
         importloadid = importLoad_ID,
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
	COMMIT;
    -- close the cursor
	CLOSE userAgent;
END//
DELIMITER ;
-- # Stored Procedure for GeoIP data normalization below
-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `normalize_client`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `normalize_client` (
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- LOAD DATA staging table column variables
  DECLARE v_country_code VARCHAR(20) DEFAULT NULL;
  DECLARE v_country VARCHAR(150) DEFAULT NULL;
  DECLARE v_subdivision VARCHAR(250) DEFAULT NULL;
  DECLARE v_city VARCHAR(250) DEFAULT NULL;
  DECLARE v_latitude DECIMAL(10,8) DEFAULT NULL;
  DECLARE v_longitude DECIMAL(11,8) DEFAULT NULL;
  DECLARE v_organization VARCHAR(500) DEFAULT NULL;
  DECLARE v_network VARCHAR(100) DEFAULT NULL;
  DECLARE recid INTEGER DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
  DECLARE country_id,
          subdivision_id,
          city_id,
          coordinate_id,
          organization_id,
          network_id INTEGER DEFAULT NULL;
  -- declare cursor for log_client format
  DECLARE logClient CURSOR FOR 
      SELECT country_code,
             country,
             subdivision,
             city,
             latitude,
             longitude,
             organization,
             network,
             id
        FROM apache_logs.log_client
       WHERE countryid IS NULL;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
      CALL apache_logs.errorProcess('normalize_client', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF LENGTH(in_processName) < 8 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be minimum of 8 characters';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
  END IF;
  SET importProcessID = apache_logs.importProcessID('normalize_client', in_processName);
  OPEN logClient;
  START TRANSACTION;	
  process_normalize: LOOP
    FETCH logClient
     INTO v_country_code,
          v_country,
          v_subdivision,
          v_city,
          v_latitude,
          v_longitude,
          v_organization,
          v_network,
          recid;
    IF done = true THEN 
      LEAVE process_normalize;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
    SET country_id = null,
        subdivision_id = null,
        city_id = null,
        coordinate_id = null,
        organization_id = null,
        network_id = null;
    -- normalize import staging table 
    IF v_country IS NOT NULL AND LENGTH(v_country) > 0 THEN
      SET country_id = apache_logs.log_clientCountryID(v_country, v_country_code);
    END IF;
    IF v_subdivision IS NOT NULL AND LENGTH(v_subdivision) > 0 THEN
      SET subdivision_id = apache_logs.log_clientSubdivisionID(v_subdivision);
    END IF;
    IF v_city IS NOT NULL AND LENGTH(v_city) > 0 THEN
      SET city_id = apache_logs.log_clientCityID(v_city);
    END IF;
    IF v_latitude IS NOT NULL AND LENGTH(v_latitude) > 0 THEN
      SET coordinate_id = apache_logs.log_clientCoordinateID(v_latitude, v_longitude);
    END IF;
    IF v_organization IS NOT NULL AND LENGTH(v_organization) > 0 THEN
      SET organization_id = apache_logs.log_clientOrganizationID(v_organization);
    END IF;
    IF v_network IS NOT NULL AND LENGTH(v_network) > 0 THEN
      SET network_id = apache_logs.log_clientNetworkID(v_network);
    END IF;
    UPDATE apache_logs.log_client
       SET countryid = country_id,
           subdivisionid = subdivision_id,
           cityid = city_id,
           coordinateid = coordinate_id,
           organizationid = organization_id,
           networkid = network_id
     WHERE id = recid;
  END LOOP;
  -- to remove SQL calculating filesProcessed when recordsProcessed = 0. Set=1 by default.
  IF recordsProcessed=0 THEN
    SET filesProcessed = 0;
  END IF;
  -- update import process table
  UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed,
         importloadid = importLoad_ID,
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
  COMMIT;
  -- close the cursor
  CLOSE logClient;
END//
DELIMITER ;
-- # Inserts default application data below
-- Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost',
INSERT INTO `import_format`
  (name)
VALUES
 ("common"),
 ("combined"),
 ("vhost"),
 ("csc2mysql"),
 ("error_default"),
 ("error_vhost");
-- # Indexes, Foreign Keys and Constraints for all Tables below
-- UNIQUE Indexes
ALTER TABLE `log_client` ADD CONSTRAINT `U_log_client` UNIQUE (name);
ALTER TABLE `log_client_city` ADD CONSTRAINT `U_log_client_city` UNIQUE (name);
ALTER TABLE `log_client_coordinate` ADD CONSTRAINT `U_log_client_coordinate` UNIQUE (latitude, longitude);
ALTER TABLE `log_client_country` ADD CONSTRAINT `U_log_client_country` UNIQUE (country, country_code);
ALTER TABLE `log_client_network` ADD CONSTRAINT `U_log_client_network` UNIQUE (name);
ALTER TABLE `log_client_organization` ADD CONSTRAINT `U_log_client_organization` UNIQUE (name);
ALTER TABLE `log_client_subdivision` ADD CONSTRAINT `U_log_client_subdivision` UNIQUE (name);

ALTER TABLE `log_clientport` ADD CONSTRAINT `U_log_clientport` UNIQUE (name);
ALTER TABLE `log_referer` ADD CONSTRAINT `U_log_referer` UNIQUE (name);
ALTER TABLE `log_server` ADD CONSTRAINT `U_log_server` UNIQUE (name);
ALTER TABLE `log_serverport` ADD CONSTRAINT `U_log_serverport` UNIQUE (name);

ALTER TABLE `access_log_remotelogname` ADD CONSTRAINT `U_access_remotelogname` UNIQUE (name);
ALTER TABLE `access_log_remoteuser` ADD CONSTRAINT `U_access_remoteuser` UNIQUE (name);
ALTER TABLE `access_log_reqmethod` ADD CONSTRAINT `U_access_reqmethod` UNIQUE (name);
ALTER TABLE `access_log_reqprotocol` ADD CONSTRAINT `U_access_reqprotocol` UNIQUE (name);
ALTER TABLE `access_log_reqstatus` ADD CONSTRAINT `U_access_reqstatus` UNIQUE (name);
-- ALTER TABLE `access_log_requri` ADD CONSTRAINT `U_access_requri` UNIQUE (name);
-- ALTER TABLE `access_log_reqquery` ADD CONSTRAINT `U_access_reqquery` UNIQUE (name);
ALTER TABLE `access_log_cookie` ADD CONSTRAINT `U_access_cookie` UNIQUE (name);
-- ALTER TABLE `access_log_useragent` ADD CONSTRAINT `U_access_useragent` UNIQUE (name);

ALTER TABLE `access_log_ua` ADD CONSTRAINT `U_access_ua` UNIQUE (name);
ALTER TABLE `access_log_ua_browser` ADD CONSTRAINT `U_access_ua_browser` UNIQUE (name);
ALTER TABLE `access_log_ua_browser_family` ADD CONSTRAINT `U_access_ua_browser_family` UNIQUE (name);
ALTER TABLE `access_log_ua_browser_version` ADD CONSTRAINT `U_access_ua_browser_version` UNIQUE (name);
ALTER TABLE `access_log_ua_device` ADD CONSTRAINT `U_access_ua_device` UNIQUE (name);
ALTER TABLE `access_log_ua_device_brand` ADD CONSTRAINT `U_access_ua_device_brand` UNIQUE (name);
ALTER TABLE `access_log_ua_device_family` ADD CONSTRAINT `U_access_ua_device_family` UNIQUE (name);
ALTER TABLE `access_log_ua_device_model` ADD CONSTRAINT `U_access_ua_device_model` UNIQUE (name);
ALTER TABLE `access_log_ua_os` ADD CONSTRAINT `U_access_ua_os` UNIQUE (name);
ALTER TABLE `access_log_ua_os_family` ADD CONSTRAINT `U_access_ua_os_family` UNIQUE (name);
ALTER TABLE `access_log_ua_os_version` ADD CONSTRAINT `U_access_ua_os_version` UNIQUE (name);

ALTER TABLE `error_log_apachecode` ADD CONSTRAINT `U_error_apachecode` UNIQUE (name);
ALTER TABLE `error_log_apachemessage` ADD CONSTRAINT `U_error_apachemessage` UNIQUE (name);
ALTER TABLE `error_log_level` ADD CONSTRAINT `U_error_level` UNIQUE (name);
ALTER TABLE `error_log_message` ADD CONSTRAINT `U_error_message` UNIQUE (name);
ALTER TABLE `error_log_module` ADD CONSTRAINT `U_error_module` UNIQUE (name);
ALTER TABLE `error_log_processid` ADD CONSTRAINT `U_error_processid` UNIQUE (name);
ALTER TABLE `error_log_systemcode` ADD CONSTRAINT `U_error_systemcode` UNIQUE (name);
ALTER TABLE `error_log_systemmessage` ADD CONSTRAINT `U_error_systemmessage` UNIQUE (name);
ALTER TABLE `error_log_threadid` ADD CONSTRAINT `U_error_threadid` UNIQUE (name);

ALTER TABLE `import_file` ADD CONSTRAINT `U_import_file` UNIQUE (importdeviceid, name);
ALTER TABLE `import_format` ADD CONSTRAINT `U_import_format` UNIQUE (name);
-- ALTER TABLE `import_server` ADD CONSTRAINT `U_import_server` UNIQUE(dbuser, dbhost, dbversion, dbsystem, dbmachine, serveruuid);
ALTER TABLE `import_server` ADD CONSTRAINT `U_import_server` UNIQUE(dbuser, dbhost, dbversion, dbsystem, dbmachine, dbcomment);
ALTER TABLE `import_device` ADD CONSTRAINT `U_import_device` UNIQUE(deviceid, platformNode, platformSystem, platformMachine, platformProcessor);
ALTER TABLE `import_client` ADD CONSTRAINT `U_import_client` UNIQUE(importdeviceid, ipaddress, login, expandUser, platformRelease, platformVersion);

-- FOREIGN KEY Indexes
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_reqstatus` FOREIGN KEY (reqstatusid) REFERENCES `access_log_reqstatus`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_reqprotocol` FOREIGN KEY (reqprotocolid) REFERENCES `access_log_reqprotocol`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_reqmethod` FOREIGN KEY (reqmethodid) REFERENCES `access_log_reqmethod`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_requri` FOREIGN KEY (requriid) REFERENCES `access_log_requri`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_reqquery` FOREIGN KEY (reqqueryid) REFERENCES `access_log_reqquery`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_remotelogname` FOREIGN KEY (remotelognameid) REFERENCES `access_log_remotelogname`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_remoteuser` FOREIGN KEY (remoteuserid) REFERENCES `access_log_remoteuser`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_useragent` FOREIGN KEY (useragentid) REFERENCES `access_log_useragent`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_cookie` FOREIGN KEY (cookieid) REFERENCES `access_log_cookie`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);

ALTER TABLE `access_log` ADD CONSTRAINT `F_access_client` FOREIGN KEY (clientid) REFERENCES `log_client`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_clientport` FOREIGN KEY (clientportid) REFERENCES `log_clientport`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_referer` FOREIGN KEY (refererid) REFERENCES `log_referer`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_server` FOREIGN KEY (serverid) REFERENCES `log_server`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_serverport` FOREIGN KEY (serverportid) REFERENCES `log_serverport`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_requestlogid` FOREIGN KEY (requestlogid) REFERENCES `log_requestlogid`(id);

ALTER TABLE `error_log` ADD CONSTRAINT `F_error_level` FOREIGN KEY (loglevelid) REFERENCES `error_log_level`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_module` FOREIGN KEY (moduleid) REFERENCES `error_log_module`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_processid` FOREIGN KEY (processid) REFERENCES `error_log_processid`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_threadid` FOREIGN KEY (threadid) REFERENCES `error_log_threadid`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_apachecode` FOREIGN KEY (apachecodeid) REFERENCES `error_log_apachecode`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_apachemessage` FOREIGN KEY (apachemessageid) REFERENCES `error_log_apachemessage`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_systemcode` FOREIGN KEY (systemcodeid) REFERENCES `error_log_systemcode`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_systemmessage` FOREIGN KEY (systemmessageid) REFERENCES `error_log_systemmessage`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_message` FOREIGN KEY (logmessageid) REFERENCES `error_log_message`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);

ALTER TABLE `error_log` ADD CONSTRAINT `F_error_client` FOREIGN KEY (clientid) REFERENCES `log_client`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_clientport` FOREIGN KEY (clientportid) REFERENCES `log_clientport`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_referer` FOREIGN KEY (refererid) REFERENCES `log_referer`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_server` FOREIGN KEY (serverid) REFERENCES `log_server`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_serverport` FOREIGN KEY (serverportid) REFERENCES `log_serverport`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_requestlogid` FOREIGN KEY (requestlogid) REFERENCES `log_requestlogid`(id);

ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_city` FOREIGN KEY (cityid) REFERENCES `log_client_city`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_coordinate` FOREIGN KEY (coordinateid) REFERENCES `log_client_coordinate`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_country` FOREIGN KEY (countryid) REFERENCES `log_client_country`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_network` FOREIGN KEY (networkid) REFERENCES `log_client_network`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_organization` FOREIGN KEY (organizationid) REFERENCES `log_client_organization`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_subdivision` FOREIGN KEY (subdivisionid) REFERENCES `log_client_subdivision`(id);

ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua` FOREIGN KEY (uaid) REFERENCES `access_log_ua`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_browser` FOREIGN KEY (uabrowserid) REFERENCES `access_log_ua_browser`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_browser_family` FOREIGN KEY (uabrowserfamilyid) REFERENCES `access_log_ua_browser_family`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_browser_version` FOREIGN KEY (uabrowserversionid) REFERENCES `access_log_ua_browser_version`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_device` FOREIGN KEY (uadeviceid) REFERENCES `access_log_ua_device`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_device_brand` FOREIGN KEY (uadevicebrandid) REFERENCES `access_log_ua_device_brand`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_device_family` FOREIGN KEY (uadevicefamilyid) REFERENCES `access_log_ua_device_family`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_device_model` FOREIGN KEY (uadevicemodelid) REFERENCES `access_log_ua_device_model`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_os` FOREIGN KEY (uaosid) REFERENCES `access_log_ua_os`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_os_family` FOREIGN KEY (uaosfamilyid) REFERENCES `access_log_ua_os_family`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_os_version` FOREIGN KEY (uaosversionid) REFERENCES `access_log_ua_os_version`(id);

ALTER TABLE `import_client` ADD CONSTRAINT `F_importclient_importdevice` FOREIGN KEY (importdeviceid) REFERENCES `import_device`(id);

ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_importformat` FOREIGN KEY (importformatid) REFERENCES `import_format`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_importdevice` FOREIGN KEY (importdeviceid) REFERENCES `import_device`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_importload` FOREIGN KEY (importloadid) REFERENCES `import_load`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_parseprocess` FOREIGN KEY (parseprocessid) REFERENCES `import_process`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_importprocess` FOREIGN KEY (importprocessid) REFERENCES `import_process`(id);

ALTER TABLE `import_process` ADD CONSTRAINT `F_importprocess_importserver` FOREIGN KEY (importserverid) REFERENCES `import_server`(id);

ALTER TABLE `import_load` ADD CONSTRAINT `F_importload_importclient` FOREIGN KEY (importclientid) REFERENCES `import_client`(id);

ALTER TABLE `load_access_combined` ADD CONSTRAINT `F_load_access_combined_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);
ALTER TABLE `load_access_csv2mysql` ADD CONSTRAINT `F_load_access_csv2mysql_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);
ALTER TABLE `load_access_vhost` ADD CONSTRAINT `F_load_access_combined_vhost_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);
ALTER TABLE `load_error_default` ADD CONSTRAINT `F_load_error_default_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);

-- Additional Indexes
ALTER TABLE `access_log` ADD INDEX `I_access_log_logged` (logged);
ALTER TABLE `access_log` ADD INDEX `I_access_log_serverid_logged` (serverid, logged);
ALTER TABLE `access_log` ADD INDEX `I_access_log_serverid_serverportid` (serverid, serverportid);
ALTER TABLE `access_log` ADD INDEX `I_access_log_clientid_clientportid` (clientid, clientportid);

ALTER TABLE `error_log` ADD INDEX `I_error_log_logged` (logged);
ALTER TABLE `error_log` ADD INDEX `I_error_log_serverid_logged` (serverid, logged);
ALTER TABLE `error_log` ADD INDEX `I_error_log_serverid_serverportid` (serverid, serverportid);
ALTER TABLE `error_log` ADD INDEX `I_error_log_clientid_clientportid` (clientid, clientportid);
ALTER TABLE `error_log` ADD INDEX `I_error_log_processid_threadid` (processid, threadid);

ALTER TABLE `load_access_combined` ADD INDEX `I_load_access_combined_process` (process_status);
ALTER TABLE `load_access_csv2mysql` ADD INDEX `I_load_access_csv2mysql_process` (process_status);
ALTER TABLE `load_access_vhost` ADD INDEX `I_load_access_vhost_process` (process_status);
ALTER TABLE `load_error_default` ADD INDEX `I_load_error_default_process` (process_status);

-- indexes for parse and retrieve processes
ALTER TABLE `log_client` ADD INDEX `I_log_client_country_code` (country_code);
ALTER TABLE `access_log_useragent` ADD INDEX `I_access_log_useragent_ua` (ua);