# coding: utf-8
# version 1.0.0 - 10/31/2024
# version 1.1.0 - 11/18/2024 - major changes
#
# Copyright 2024 Will Raymond <farmfreshsoftware@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# file: apacheLogs2MySQL.py 
# module: apacheLogs2MySQL
# function: processLogs()
# synopsis: processes apache access and error logs into MySQL for apachelogs2MySQL application.
# Changelog
# [1.1.0] renamed LOAD DATA TABLES, normalized access_log_useragent TABLE into 11 TABLES, added 13 VIEWS.
# [1.1.0] resized LOAD DATA COLUMNS, added req_query COLUMN and seperated query strings from req_uri COLUMN.
# [1.1.0] added access_log_reqquery TABLE, renamed access_log_session TABLE to access_log_cookie.
# [1.1.0] added UPDATE TRIM statements for apachemessage COLUMNS.
import os
import platform
import socket
import pymysql
import glob
from dotenv import load_dotenv
from user_agents import parse
import time
load_dotenv()  # Loads variables from .env into the environment
mysql_host = os.getenv('MYSQL_HOST')
mysql_port = int(os.getenv('MYSQL_PORT'))
mysql_user = os.getenv('MYSQL_USER')
mysql_password = os.getenv('MYSQL_PASSWORD')
mysql_schema = os.getenv('MYSQL_SCHEMA')
errorlog = int(os.getenv('ERROR'))
errorlog_path = os.getenv('ERROR_PATH')
errorlog_recursive = bool(int(os.getenv('ERROR_RECURSIVE')))
errorlog_log = int(os.getenv('ERROR_LOG'))
errorlog_process = int(os.getenv('ERROR_PROCESS'))
combined = int(os.getenv('COMBINED'))
combined_path = os.getenv('COMBINED_PATH')
combined_recursive = bool(int(os.getenv('COMBINED_RECURSIVE')))
combined_log = int(os.getenv('COMBINED_LOG'))
combined_process = int(os.getenv('COMBINED_PROCESS'))
vhost = int(os.getenv('VHOST'))
vhost_path = os.getenv('VHOST_PATH')
vhost_recursive = bool(int(os.getenv('VHOST_RECURSIVE')))
vhost_log = int(os.getenv('VHOST_LOG'))
vhost_process = int(os.getenv('VHOST_PROCESS'))
extended = int(os.getenv('EXTENDED'))
extended_path = os.getenv('EXTENDED_PATH')
extended_recursive = bool(int(os.getenv('EXTENDED_RECURSIVE')))
extended_log = int(os.getenv('EXTENDED_LOG'))
extended_process = int(os.getenv('EXTENDED_PROCESS'))
useragent = int(os.getenv('USERAGENT'))
useragent_log = int(os.getenv('USERAGENT_LOG'))
useragent_process = int(os.getenv('USERAGENT_PROCESS'))
# Database connection parameters
db_params = {
    'host': mysql_host,
    'port': mysql_port,
    'user': mysql_user,
    'password': mysql_password,
    'database': mysql_schema,
    'local_infile': True
 }
# information to identify & register import client 
def get_device_id():
    system = platform.system()
    if system == "Windows":
        import winreg
        try:
            with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Cryptography") as key:
                return winreg.QueryValueEx(key, "MachineGuid")[0]
        except:
            return "Not Found"
    elif system == "Darwin":
        import subprocess
        return subprocess.check_output("system_profiler SPHardwareDataType | grep 'Serial Number (system)' | awk '{print $4}'", shell=True).decode().strip()
    elif system == "Linux":
        try:
            with open("/etc/machine-id", "r") as f:
                return f.read().strip()
        except:
            return "Not Found"
    else:
        return "Unsupported Platform"

ipaddress = socket.gethostbyname(socket.gethostname())
deviceid = get_device_id()
login = os.getlogin( )
expandUser = os.path.expanduser('~')
tuple_uname = platform.uname()
platformSystem = tuple_uname[0]
platformNode = tuple_uname[1]
platformRelease = tuple_uname[2]
platformVersion = tuple_uname[3]
platformMachine = tuple_uname[4]
platformProcessor = platform.processor()

def processLogs():
    import os # module is not accessible from import above. for some reason... module is not available inside function.  
    start_time = time.time()
    conn = pymysql.connect(**db_params)
    getImportClientID = ("SELECT apache_logs.importClientID('" + ipaddress + 
                         "', '" + deviceid + 
                         "', '"  + login + 
                         "', '"  + expandUser + 
                         "', '"  + platformSystem + 
                         "', '"  + platformNode + 
                         "', '"  + platformRelease + 
                         "', '"  + platformVersion + 
                         "', '"  + platformMachine + 
                         "', '"  + platformProcessor + "');")
    importClientCursor = conn.cursor()
    try:
        importClientCursor.execute( getImportClientID )
    except:
        print("ERROR - SELECT apache_logs.importClientID() Statement execution on Server failed")
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importClientCursor.callproc("loadError",["SELECT apache_logs.importClientID()",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    importClientTupleID = importClientCursor.fetchall()
    importClientID = importClientTupleID[0][0]
    getImportLoadID = "SELECT apache_logs.importLoadID('" + str(importClientID) + "');"
    importLoadCursor = conn.cursor()
    try:
        importLoadCursor.execute( getImportLoadID )
    except:
        print("ERROR - SELECT apache_logs.importLoadID(importClientID) Statement execution on Server failed")
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importClientCursor.callproc("loadError",["SELECT apache_logs.importLoadID(importClientID)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    importLoadTupleID = importLoadCursor.fetchall()
    importLoadID = importLoadTupleID[0][0]
    errorDataLoaded = 0
    errorFileCount = 0
    errorFileLoaded = 0
    errorFileProcessed = 0
    combinedDataLoaded = 0
    combinedFileCount = 0
    combinedFileLoaded = 0
    combinedFileProcessed = 0
    vhostDataLoaded = 0
    vhostFileCount = 0
    vhostFileLoaded = 0
    vhostFileProcessed = 0
    extendedDataLoaded = 0
    extendedFileCount = 0
    extendedFileLoaded = 0
    extendedFileProcessed = 0
    useragentFileProcessed = 0 
    if errorlog == 1:
        if errorlog_log >= 1:
            print('Checking for Error Logs to Import... Import Process started %s seconds ago!' % (time.time() - start_time))
        errorExistsCursor = conn.cursor()
        errorInsertCursor = conn.cursor()
        errorLoadCursor = conn.cursor()
        for errorFile in glob.glob(errorlog_path, recursive=errorlog_recursive):
            errorFileCount += 1
            errorLoadFile = errorFile.replace(os.sep, os.sep+os.sep)
            errorExistsSQL = "SELECT apache_logs.importFileExists('" + errorLoadFile + "');"
            try:
                errorExistsCursor.execute( errorExistsSQL )
            except:
                print("ERROR - SELECT apache_logs.importFileExists(error_log) Statement execution on Server failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("loadError",["SELECT apache_logs.importFileExists(error_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            errorExistsTuple = errorExistsCursor.fetchall()
            errorExists = errorExistsTuple[0][0]
            if errorExists == 0:
                errorFileLoaded += 1
                errorDataLoaded = 1
                if errorlog_log >= 2:
                    print('Loading Error log - ' + errorFile )
                errorLoadCreated = time.ctime(os.path.getctime(errorFile))
                errorLoadModified = time.ctime(os.path.getmtime(errorFile))
                errorLoadSize     = str(os.path.getsize(errorFile))
                errorLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\\\\'"
                try:
                    errorLoadCursor.execute( errorLoadSQL )
                except:
                    print("ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_error_default Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["LOAD DATA LOCAL INFILE INTO TABLE load_error_default",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                errorInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  errorLoadFile + 
                                  "', '" + errorLoadSize + 
                                  "', '"  + errorLoadCreated + 
                                  "', '"  + errorLoadModified + 
                                  "', '"  + str(importClientID) + 
                                  "', '"  + str(importLoadID) + "' );")
                try:
                    errorInsertCursor.execute( errorInsertSQL )
                except:
                    print("ERROR - SELECT apache_logs.importFileID(error_log) Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["SELECT apache_logs.importFileID(error_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                errorInsertTupleID = errorInsertCursor.fetchall()
                errorInsertFileID = errorInsertTupleID[0][0]
                try:
                    errorLoadCursor.execute("UPDATE load_error_default SET importfileid=" + str(errorInsertFileID) + " WHERE importfileid IS NULL")
                except:
                    print("ERROR - UPDATE load_error_default SET importfileid= Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["UPDATE load_error_default SET importfileid=",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
        if errorDataLoaded == 1:
            try:
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET module = SUBSTR(log_mod_level,3,(POSITION(':' IN log_mod_level)-3))")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET loglevel = SUBSTR(log_mod_level,(POSITION(':' IN log_mod_level)+1))")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET processid = SUBSTR(log_processid_threadid,(POSITION('pid' IN log_processid_threadid)+4),(POSITION(':' IN log_processid_threadid)-(POSITION('pid' IN log_processid_threadid)+4)))")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET threadid = SUBSTR(log_processid_threadid,(POSITION('tid' IN log_processid_threadid)+4))")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET apachecode = SUBSTR(log_parse1,2,(POSITION(':' IN log_parse1)-2)) WHERE LEFT(log_parse1,2)=' A'")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET apachemessage = SUBSTR(log_parse1,(POSITION(':' IN log_parse1)+1)) WHERE LEFT(log_parse1,2)=' A'")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET apachecode = SUBSTR(log_parse2,2,(POSITION(':' IN log_parse2)-2)) WHERE LEFT(log_parse2,2)=' A'")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET apachemessage = SUBSTR(log_parse2,(POSITION(':' IN log_parse2)+1)) WHERE LEFT(log_parse2,2)=' A' and POSITION('referer:' IN log_parse2)=0")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET apachemessage = SUBSTR(log_parse2,(POSITION(':' IN log_parse2)+1),POSITION(', referer:' IN log_parse2)-(POSITION(':' IN log_parse2)+1)) WHERE LEFT(log_parse2,2)=' A' and POSITION(', referer:' IN log_parse2)>0")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET apachecode = SUBSTR(log_parse1,(POSITION(': AH' IN log_parse1)+2),LOCATE(':',log_parse1,(POSITION(': AH' IN log_parse1)+2))-(POSITION(': AH' IN log_parse1)+2)) WHERE POSITION(': AH' IN log_parse1)>0")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET apachemessage = SUBSTR(log_parse1,LOCATE(':',log_parse1,POSITION(': AH' IN log_parse1)+2)+2) WHERE POSITION(': AH' IN log_parse1)>0")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET reqclient = SUBSTR(log_parse1,(POSITION('[client' IN log_parse1)+8)) WHERE POSITION('[client' IN log_parse1)>0")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET systemcode = SUBSTR(log_parse1,POSITION('(' IN log_parse1),LOCATE(':',log_parse1,POSITION('(' IN log_parse1))-POSITION('(' IN log_parse1)) WHERE POSITION('(' IN log_parse1)>0 AND LOCATE(':',log_parse1,POSITION('(' IN log_parse1))-POSITION('(' IN log_parse1)>0")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET systemmessage = SUBSTR(log_parse1,POSITION(':' IN log_parse1) + 1) WHERE POSITION('(' IN log_parse1)>0 AND LOCATE(':',log_parse1,POSITION('(' IN log_parse1))-POSITION('(' IN log_parse1)>0 AND apachecode IS NULL")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET log_message_nocode = log_parse1 WHERE systemcode IS NULL and apachecode IS NULL")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET module = SUBSTR(log_parse1,2,(POSITION(':' IN log_parse1)-2)) WHERE systemcode IS NULL and apachecode IS NULL and LENGTH(module)=0 AND POSITION(':' IN log_parse1)>0 AND LOCATE(' ',log_parse1,2)>POSITION(':' IN log_parse1)")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET logmessage = SUBSTR(log_parse1,(POSITION(':' IN log_parse1)+1)) WHERE systemcode IS NULL and apachecode IS NULL AND POSITION(':' IN log_parse1)>0 AND LOCATE(' ',log_parse1,2)>POSITION(':' IN log_parse1)")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET logmessage = log_message_nocode WHERE logmessage IS NULL and log_message_nocode IS NOT NULL")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET referer = SUBSTR(log_parse2,(POSITION('referer:' IN log_parse2)+8)) WHERE POSITION('referer:' IN log_parse2)>0")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET logtime = STR_TO_DATE(SUBSTR(log_time,2,31),'%a %b %d %H:%i:%s.%f %Y')")
                errorLoadCursor.execute("UPDATE apache_logs.load_error_default SET module=TRIM(module), loglevel=TRIM(loglevel), processid=TRIM(processid), threadid=TRIM(threadid), apachecode=TRIM(apachecode), apachemessage=TRIM(apachemessage), systemcode=TRIM(systemcode), systemmessage = TRIM(systemmessage), logmessage=TRIM(logmessage), reqclient=TRIM(reqclient), referer=TRIM(referer)")
            except:
                print("ERROR - UPDATE apache_logs.load_error_default SET Statements execution on Server failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("loadError",["UPDATE apache_logs.load_error_default SET Statements",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            # Processing loaded data
            if errorlog_process == 1:
                errorFileProcessed += 1
                if errorlog_log >= 1:
                    print('Processing Error Logs...')
                errorProcedureCursor = conn.cursor()
                try:
                    errorProcedureCursor.callproc("import_error_log",["default"])
                except:
                    print("ERROR - Stored Procedure import_error_log(default) execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["Stored Procedure import_error_log(default)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                errorProcedureCursor.close()
                if errorlog_log >= 1:
                    print('Error Logs import completed. Import Process started %s seconds ago!' % (time.time() - start_time))
        errorInsertCursor.close()
        errorLoadCursor.close()
        errorExistsCursor.close()
    if combined == 1:
        # starting load and process of access logs - combined and common
        if combined_log >= 1:
            print('Checking for Combined Access Log to Import... Import Process started %s seconds ago!' % (time.time() - start_time))
        combinedExistsCursor = conn.cursor()
        combinedInsertCursor = conn.cursor()
        combinedLoadCursor = conn.cursor()
        for combinedFile in glob.glob(combined_path, recursive=combined_recursive):
            combinedFileCount += 1
            combinedLoadFile = combinedFile.replace(os.sep, os.sep+os.sep)
            combinedExistsSQL = "SELECT apache_logs.importFileExists('" + combinedLoadFile + "');"
            try:
                combinedExistsCursor.execute( combinedExistsSQL )
            except:
                print("ERROR - SELECT apache_logs.importFileExists(combined_log) Statement execution on Server failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("loadError",["SELECT apache_logs.importFileExists(combined_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            combinedExistsTuple = combinedExistsCursor.fetchall()
            combinedExists = combinedExistsTuple[0][0]
            if combinedExists == 0:
                combinedFileLoaded += 1
                if combined_log >= 2:
                    print('Loading Combined Access Log - ' + combinedFile )
                combinedDataLoaded = 1
                combinedLoadCreated = time.ctime(os.path.getctime(combinedFile))
                combinedLoadModified = time.ctime(os.path.getmtime(combinedFile))
                combinedLoadSize     = str(os.path.getsize(combinedFile))
                combinedLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\\\\'"
                try:
                    combinedLoadCursor.execute( combinedLoadSQL )
                except:
                    print("ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_combined Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["LOAD DATA LOCAL INFILE INTO TABLE load_access_combined",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                combinedInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  combinedLoadFile + 
                                  "', '" + combinedLoadSize + 
                                  "', '"  + combinedLoadCreated + 
                                  "', '"  + combinedLoadModified + 
                                  "', '"  + str(importClientID) + 
                                  "', '"  + str(importLoadID) + "' );")
                try:
                    combinedInsertCursor.execute( combinedInsertSQL )
                except:
                    print("ERROR - SELECT apache_logs.importFileID(combined_log) Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["SELECT apache_logs.importFileID(combined_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                combinedInsertTupleID = combinedInsertCursor.fetchall()
                combinedInsertFileID = combinedInsertTupleID[0][0]
                try:
                    combinedLoadCursor.execute("UPDATE load_access_combined SET importfileid=" + str(combinedInsertFileID) + " WHERE importfileid IS NULL")
                except:
                    print("ERROR - UPDATE load_access_combined SET importfileid= Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["UPDATE load_access_combined SET importfileid=",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
        if combinedDataLoaded == 1:
            try:
                combinedLoadCursor.execute("UPDATE apache_logs.load_access_combined SET req_method = SUBSTR(first_line_request,1,(POSITION(' ' IN first_line_request)-1)) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
                combinedLoadCursor.execute("UPDATE apache_logs.load_access_combined SET req_uri = SUBSTR(first_line_request,(POSITION(' ' IN first_line_request)+1),LOCATE(' ',first_line_request,(POSITION(' ' IN first_line_request)+1))-(POSITION(' ' IN first_line_request)+1)) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
                combinedLoadCursor.execute("UPDATE apache_logs.load_access_combined SET req_protocol = SUBSTR(first_line_request,LOCATE(' ',first_line_request,(POSITION(' ' IN first_line_request)+1))) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
                combinedLoadCursor.execute("UPDATE apache_logs.load_access_combined SET req_query = SUBSTR(req_uri,POSITION('?' IN req_uri)) WHERE POSITION('?' IN req_uri)>0")
                combinedLoadCursor.execute("UPDATE apache_logs.load_access_combined SET req_uri = SUBSTR(req_uri,1,(POSITION('?' IN req_uri)-1)) WHERE POSITION('?' IN req_uri)>0")
                combinedLoadCursor.execute("UPDATE apache_logs.load_access_combined SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request' WHERE LEFT(first_line_request,1) NOT RLIKE '^[A-Z]|-'")
                combinedLoadCursor.execute("UPDATE apache_logs.load_access_combined SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request' WHERE LEFT(first_line_request,1) RLIKE '^-'")
                combinedLoadCursor.execute("UPDATE apache_logs.load_access_combined SET req_protocol = TRIM(req_protocol)")
                combinedLoadCursor.execute("UPDATE apache_logs.load_access_combined SET log_time = CONCAT(log_time_a,' ',log_time_b)")
            except:
                print("ERROR - UPDATE apache_logs.load_access_combined SET Statements execution on Server failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("loadError",["UPDATE apache_logs.load_access_combined SET",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            # Processing loaded data
            if combined_process == 1:
                combinedFileProcessed += 1
                if combined_log >= 1:
                    print('Processing Combined Access Logs... Import Process started %s seconds ago!' % (time.time() - start_time))
                combinedProcedureCursor = conn.cursor()
                try:
                    combinedProcedureCursor.callproc("import_access_log",["combined"])
                except:
                    print("ERROR - Stored Procedure import_access_log(combined) execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["Stored Procedure import_access_log(combined)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                combinedProcedureCursor.close()
                if combined_log >= 1:
                    print('Combined Access Logs import completed. Import Process started %s seconds ago!' % (time.time() - start_time))
        combinedInsertCursor.close()
        combinedLoadCursor.close()
        combinedExistsCursor.close()
    if vhost == 1:
        # starting load and process of access logs - combined
        if vhost_log >= 1:
            print('Checking for vHost Access Logs to Import... Import Process started %s seconds ago!' % (time.time() - start_time))
        vhostExistsCursor = conn.cursor()
        vhostInsertCursor = conn.cursor()
        vhostLoadCursor = conn.cursor()
        for vhostFile in glob.glob(vhost_path, recursive=vhost_recursive):
            vhostFileCount += 1
            vhostLoadFile = vhostFile.replace(os.sep, os.sep+os.sep)
            vhostExistsSQL = "SELECT apache_logs.importFileExists('" + vhostLoadFile +"');"
            try:
                vhostExistsCursor.execute( vhostExistsSQL )
            except:
                print("ERROR - SELECT apache_logs.importFileExists(vhost_log) Statement execution on Server failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("loadError",["SELECT apache_logs.importFileExists(vhost_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            vhostExistsTuple = vhostExistsCursor.fetchall()
            vhostExists = vhostExistsTuple[0][0]
            if vhostExists == 0:
                vhostFileLoaded += 1
                if vhost_log >= 2:
                    print('Loading Vhost Access Log - '+vhostFile)
                vhostDataLoaded = 1
                vhostLoadCreated = time.ctime(os.path.getctime(vhostFile))
                vhostLoadModified = time.ctime(os.path.getmtime(vhostFile))
                vhostLoadSize     = str(os.path.getsize(vhostFile))
                vhostLoadSQL = "LOAD DATA LOCAL INFILE '" + vhostLoadFile + "' INTO TABLE load_access_vhost FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\\\\'"
                try:
                    vhostLoadCursor.execute( vhostLoadSQL )
                except:
                    print("ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_vhost Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["LOAD DATA LOCAL INFILE INTO TABLE load_access_vhost",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                vhostInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  vhostLoadFile + 
                                  "', '" + vhostLoadSize + 
                                  "', '"  + vhostLoadCreated + 
                                  "', '"  + vhostLoadModified + 
                                  "', '"  + str(importClientID) + 
                                  "', '"  + str(importLoadID) + "' );")
                try:
                    vhostInsertCursor.execute( vhostInsertSQL )
                except:
                    print("ERROR - SELECT apache_logs.importFileID(vhost_log) Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["SELECT apache_logs.importFileID(vhost_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                vhostInsertTupleID = vhostInsertCursor.fetchall()
                vhostInsertFileID = vhostInsertTupleID[0][0]
                try:
                    vhostLoadCursor.execute("UPDATE load_access_vhost SET importfileid=" + str(vhostInsertFileID) + " WHERE importfileid IS NULL")
                except:
                    print("ERROR - UPDATE load_access_vhost SET importfileid= Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["UPDATE load_access_vhost SET importfileid=",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
        if vhostDataLoaded == 1:
            try:
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET server_name = SUBSTR(log_server,1,(POSITION(':' IN log_server)-1)) WHERE POSITION(':' IN log_server)>0")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET server_port = SUBSTR(log_server,(POSITION(':' IN log_server)+1)) WHERE POSITION(':' IN log_server)>0")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET req_method = SUBSTR(first_line_request,1,(POSITION(' ' IN first_line_request)-1)) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET req_uri = SUBSTR(first_line_request,(POSITION(' ' IN first_line_request)+1),LOCATE(' ',first_line_request,(POSITION(' ' IN first_line_request)+1))-(POSITION(' ' IN first_line_request)+1)) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET req_protocol = SUBSTR(first_line_request,LOCATE(' ',first_line_request,(POSITION(' ' IN first_line_request)+1))) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET req_query = SUBSTR(req_uri,POSITION('?' IN req_uri)) WHERE POSITION('?' IN req_uri)>0")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET req_uri = SUBSTR(req_uri,1,(POSITION('?' IN req_uri)-1)) WHERE POSITION('?' IN req_uri)>0")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request' WHERE LEFT(first_line_request,1) NOT RLIKE '^[A-Z]|-'")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request' WHERE LEFT(first_line_request,1) RLIKE '^-'")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET req_protocol = TRIM(req_protocol)")
                vhostLoadCursor.execute("UPDATE apache_logs.load_access_vhost SET log_time = CONCAT(log_time_a,' ',log_time_b)")
            except:
                print("ERROR - UPDATE apache_logs.load_access_vhost SET Statements execution on Server failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("loadError",["UPDATE apache_logs.load_access_vhost SET Statements",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            # Processing loaded data
            if vhost_process == 1:
                vhostFileProcessed += 1
                if vhost_log >= 1:
                    print('Processing Vhost Access Logs... Import Process started %s seconds ago!' % (time.time() - start_time))
                vhostProcedureCursor = conn.cursor()
                try:
                    vhostProcedureCursor.callproc("import_access_log",["vhost"])
                except:
                    print("ERROR - Stored Procedure 'import_access_log(vhost)' execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["Stored Procedure 'import_access_log(vhost)'",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                vhostProcedureCursor.close()
                if vhost_log >= 1:
                    print('Vhost Access Logs import completed. Import Process started %s seconds ago!' % (time.time() - start_time))
        vhostInsertCursor.close()
        vhostLoadCursor.close()
        vhostExistsCursor.close()
    if extended == 1:
        # starting load and process of access logs - extended
        if extended_log >= 1:
            print('Checking for Extended Access Logs to Import... Import Process started %s seconds ago!' % (time.time() - start_time))
        extendedExistsCursor = conn.cursor()
        extendedInsertCursor = conn.cursor()
        extendedLoadCursor = conn.cursor()
        for extendedFile in glob.glob(extended_path, recursive=extended_recursive):
            extendedFileCount += 1
            extendedLoadFile = extendedFile.replace(os.sep, os.sep+os.sep)
            extendedExistsSQL = "SELECT apache_logs.importFileExists('" + extendedLoadFile + "');"
            try:
                extendedExistsCursor.execute( extendedExistsSQL )
            except:
                print("ERROR - SELECT apache_logs.importFileExists(extended_log) Statement execution on Server failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("loadError",["SELECT apache_logs.importFileExists(extended_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            extendedExistsTuple = extendedExistsCursor.fetchall()
            extendedExists = extendedExistsTuple[0][0]
            if extendedExists == 0:
                extendedFileLoaded += 1
                if extended_log >= 2:
                    print('Loading Extended Access Log - ' + extendedFile )
                extendedDataLoaded = 1
                extendedLoadCreated = time.ctime(os.path.getctime(extendedFile))
                extendedLoadModified = time.ctime(os.path.getmtime(extendedFile))
                extendedLoadSize     = str(os.path.getsize(extendedFile))
                extendedLoadSQL = "LOAD DATA LOCAL INFILE '" + extendedLoadFile + "' INTO TABLE load_access_extended FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\\\\'"
                try:
                    extendedLoadCursor.execute( extendedLoadSQL )
                except:
                    print("ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_extended Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["LOAD DATA LOCAL INFILE INTO TABLE load_access_extended",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                extendedInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  extendedLoadFile + 
                                  "', '" + extendedLoadSize + 
                                  "', '"  + extendedLoadCreated + 
                                  "', '"  + extendedLoadModified + 
                                  "', '"  + str(importClientID) + 
                                  "', '"  + str(importLoadID) + "' );")
                try:
                    extendedInsertCursor.execute( extendedInsertSQL )
                except:
                    print("ERROR - SELECT apache_logs.importFileID(extended_log) Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["SELECT apache_logs.importFileID(extended_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                extendedInsertTupleID = extendedInsertCursor.fetchall()
                extendedInsertFileID = extendedInsertTupleID[0][0]
                try:
                    extendedLoadCursor.execute("UPDATE load_access_extended SET importfileid=" + str(extendedInsertFileID) + " WHERE importfileid IS NULL")
                except:
                    print("ERROR - UPDATE load_access_extended SET importfileid= Statement execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["UPDATE load_access_extended SET importfileid=",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
        # Commit and close
        if extendedDataLoaded == 1:
            # this is where additional parsing would be done if needed prior to importing
            # Processing loaded data
            if extended_process == 1:
                extendedFileProcessed += 1
                if extended_log >= 1:
                    print('Processing Extended Access Logs... Import Process started %s seconds ago!' % (time.time() - start_time))
                extendedProcedureCursor = conn.cursor()
                try:
                    extendedProcedureCursor.callproc("import_access_log",["extended"])
                except:
                    print("ERROR - Stored Procedure 'import_access_log(extended)' execution on Server failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("loadError",["Stored Procedure 'import_access_log(extended)'",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                extendedProcedureCursor.close()
                if extended_log >= 1:
                    print('Extended Access Logs import completed. Import Process started %s seconds ago!' % (time.time() - start_time))
        extendedExistsCursor.close()
        extendedInsertCursor.close()
        extendedLoadCursor.close()
    # done with load and process of access and error logs
    # if any access logs were processed check to update useragent if any records added
    if  useragent == 1 and (combinedDataLoaded == 1 or vhostDataLoaded == 1 or extendedDataLoaded ==1):
        if useragent_log >= 1:
            print('Checking for access_log_useragent data parsing to process... Import Process started %s seconds ago!' % (time.time() - start_time))
        selectUserAgentCursor = conn.cursor()
        updateUserAgentCursor = conn.cursor()
        selectUserAgentCursor.execute("SELECT id, name FROM `access_log_useragent` WHERE ua_browser IS NULL")
        try:
            selectUserAgentCursor.execute("SELECT id, name FROM `access_log_useragent` WHERE ua_browser IS NULL")
        except:
            print("ERROR - SELECT id, name FROM `access_log_useragent` WHERE ua_browser IS NULL Statement execution on Server failed")
            showWarnings = conn.show_warnings()
            print(showWarnings)
            importClientCursor.callproc("loadError",["SELECT id, name FROM `access_log_useragent` WHERE ua_browser",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        for x in range(selectUserAgentCursor.rowcount):
            useragentFileProcessed += 1
            userAgent = selectUserAgentCursor.fetchone()
            recID = str(userAgent[0])
            ua = parse(userAgent[1])
            if useragent_log >= 2:
                print('Parsing record ' + str(recID) + ' - ' + str(ua) )
            # Accessing user agent's browser attributes
            # br = str(ua.browser)  # returns Browser(family=u'Mobile Safari', version=(5, 1), version_string='5.1')
            br_family = str(ua.browser.family)  # returns 'Mobile Safari'
            #ua.browser.version  # returns (5, 1)
            br_version = ua.browser.version_string   # returns '5.1'
            # Accessing user agent's operating system properties
            os = str(ua.os)  # returns OperatingSystem(family=u'iOS', version=(5, 1), version_string='5.1')
            os_family = str(ua.os.family)  # returns 'iOS'
            #ua.os.version  # returns (5, 1)
            os_version = ua.os.version_string  # returns '5.1'
            # Accessing user agent's device properties
            dv = str(ua.device)  # returns Device(family=u'iPhone', brand=u'Apple', model=u'iPhone')
            dv_family = str(ua.device.family)  # returns 'iPhone'
            dv_brand = str(ua.device.brand) # returns 'Apple'
            dv_model = str(ua.device.model) # returns 'iPhone'
            updateSql = ('UPDATE access_log_useragent SET ua="'+str(ua) + 
                         '", ua_browser="' + br_family + 
                         '", ua_browser_family="' + br_family + 
                         '", ua_browser_version="' + br_version + 
                         '", ua_os="' + os + 
                         '", ua_os_family="' + os_family + 
                         '", ua_os_version="' + os_version + 
                         '", ua_device="' + dv + 
                         '", ua_device_family="' + dv_family + 
                         '", ua_device_brand="' + dv_brand + 
                         '", ua_device_model="' + dv_model + 
                         '" WHERE id=' + recID + ';')
            try:
                updateUserAgentCursor.execute(updateSql)
            except:
                print("ERROR - UPDATE import_load SET Statement execution on Server failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("loadError",["UPDATE import_load SET",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        conn.commit()
        selectUserAgentCursor.close()
        updateUserAgentCursor.close()        
        if useragent_log >= 1:
            print('Useragent data parsing completed. Import Process started %s seconds ago!' % (time.time() - start_time))
        if useragent_process == 1:
            if useragent_log >= 1:
                print('Normalizing UserAgent data to seperate tables... Import Process started %s seconds ago!' % (time.time() - start_time))
            normalizeCursor = conn.cursor()
            try:
                normalizeCursor.callproc("normalize_useragent",["Python Processed"])
            except:
                print("ERROR - Stored Procedure 'normalize_useragent(Python Processed)' execution on Server failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("loadError",["Stored Procedure 'normalize_useragent(Python Processed)'",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            normalizeCursor.close()
            if useragent_log >= 1:
                print('Normalizing UserAgent data completed. Import Process started %s seconds ago!' % (time.time() - start_time))
    processSeconds = round(time.time() - start_time, 4)
    loadUpdateSQL = ('UPDATE import_load SET errorLogCount=' + str(errorFileCount) + 
                  ', errorLogLoaded=' + str(errorFileLoaded) + 
                  ', errorLogProcessed=' + str(errorFileProcessed) + 
                  ', combinedLogCount=' + str(combinedFileCount) + 
                  ', combinedLogLoaded=' + str(combinedFileLoaded) + 
                  ', combinedLogProcessed=' + str(combinedFileProcessed) + 
                  ', vhostLogCount=' + str(vhostFileCount) + 
                  ', vhostLogLoaded=' + str(vhostFileLoaded) + 
                  ', vhostLogProcessed=' + str(vhostFileProcessed) + 
                  ', extendedLogCount=' + str(extendedFileCount) + 
                  ', extendedLogLoaded=' + str(extendedFileLoaded) + 
                  ', extendedLogProcessed=' + str(extendedFileProcessed) + 
                  ', userAgentProcessed=' + str(useragentFileProcessed) + 
                  ', processSeconds=' + str(processSeconds) + ' WHERE id=' + str(importLoadID) +';')
    importLoadCursor = conn.cursor()
    try:
        importLoadCursor.execute(loadUpdateSQL)
    except:
        print("ERROR - UPDATE import_load SET Statement execution on Server failed")
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importClientCursor.callproc("loadError",["UPDATE import_load SET Statement",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    conn.commit()
    importLoadCursor.close()
    importClientCursor.close()
    conn.close()
    print('Importing of Apache Logs to MySQL completed in %s seconds!' % (time.time() - start_time))

if __name__ == "__main__":
    # This will run if apacheLogs2MySQL.py is executed directly
    print("apacheLogs2MySQL.py is being run directly")
    processLogs()
