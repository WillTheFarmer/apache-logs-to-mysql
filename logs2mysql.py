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
# version 3.2.5 - 02/06/2025 - Log Generator Stress Test Improvements - see changelog
#
# Copyright 2024-2025 Will Raymond <farmfreshsoftware@gmail.com>
#
# CHANGELOG.md in repository - https://github.com/WillTheFarmer/apache-logs-to-mysql
"""
:module: logs2mysql
:function: processLogs()
:synopsis: processes apache access and error logs into MySQL for ApacheLogs2MySQL application.
:author: Will Raymond <farmfreshsoftware@gmail.com>
"""
from os import getenv
from os import path
from os import getlogin
from os import sep
from os import remove
from os import makedirs
from platform import processor
from platform import uname
from platform import system
from socket import gethostbyname
from socket import gethostname
from pymysql import connect
from glob import glob
from geoip2 import database
from dotenv import load_dotenv
from user_agents import parse
from time import ctime
from time import perf_counter
from datetime import datetime
import shutil
from pathlib import Path
# Readability of process start, complete, info and error messages in console - all error messages start with 'ERROR - ' for keyword log search
from color import fg
from color import bg
from color import style
load_dotenv() # Loads variables from .env into the environment
mysql_host = getenv('MYSQL_HOST')
mysql_port = int(getenv('MYSQL_PORT'))
mysql_user = getenv('MYSQL_USER')
mysql_password = getenv('MYSQL_PASSWORD')
mysql_schema = getenv('MYSQL_SCHEMA')
watch_path = getenv('WATCH_PATH')
errorlog = int(getenv('ERROR'))
errorlog_path = getenv('ERROR_PATH')
errorlog_recursive = bool(int(getenv('ERROR_RECURSIVE')))
errorlog_log = int(getenv('ERROR_LOG'))
errorlog_process = int(getenv('ERROR_PROCESS'))
errorlog_server = getenv('ERROR_SERVER')
errorlog_serverport = int(getenv('ERROR_SERVERPORT'))
combined = int(getenv('COMBINED'))
combined_path = getenv('COMBINED_PATH')
combined_recursive = bool(int(getenv('COMBINED_RECURSIVE')))
combined_log = int(getenv('COMBINED_LOG'))
combined_process = int(getenv('COMBINED_PROCESS'))
combined_server = getenv('COMBINED_SERVER')
combined_serverport = int(getenv('COMBINED_SERVERPORT'))
vhost = int(getenv('VHOST'))
vhost_path = getenv('VHOST_PATH')
vhost_recursive = bool(int(getenv('VHOST_RECURSIVE')))
vhost_log = int(getenv('VHOST_LOG'))
vhost_process = int(getenv('VHOST_PROCESS'))
csv2mysql = int(getenv('CSV2MYSQL'))
csv2mysql_path = getenv('CSV2MYSQL_PATH')
csv2mysql_recursive = bool(int(getenv('CSV2MYSQL_RECURSIVE')))
csv2mysql_log = int(getenv('CSV2MYSQL_LOG'))
csv2mysql_process = int(getenv('CSV2MYSQL_PROCESS'))
useragent = int(getenv('USERAGENT'))
useragent_log = int(getenv('USERAGENT_LOG'))
useragent_process = int(getenv('USERAGENT_PROCESS'))
geoip2 = int(getenv('GEOIP2'))
geoip2_log = int(getenv('GEOIP2_LOG'))
geoip2_city = getenv('GEOIP2_CITY')
geoip2_asn = getenv('GEOIP2_ASN')
geoip2_process = int(getenv('GEOIP2_PROCESS'))
backup_days = int(getenv('BACKUP_DAYS'))
backup_path = getenv('BACKUP_PATH')
watch_path = getenv('WATCH_PATH')
# Database connection parameters
db_params = {
    'host': mysql_host,
    'port': mysql_port,
    'user': mysql_user,
    'password': mysql_password,
    'database': mysql_schema,
    'local_infile': True
 }
# Information to identify & register import load clients 
def get_device_id():
    sys_os = system()
    if sys_os == "Windows":
        import winreg
        try:
            with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Cryptography") as key:
                return winreg.QueryValueEx(key, "MachineGuid")[0]
        except:
            return "Not Found"
    elif sys_os == "Darwin":
        import subprocess
        return subprocess.check_output("system_profiler SPHardwareDataType | grep 'Serial Number (system)' | awk '{print $4}'", shell=True).decode().strip()
    elif sys_os == "Linux":
        try:
            with open("/etc/machine-id", "r") as f:
                return f.read().strip()
        except:
            return "Not Found"
    else:
        return "Unsupported Platform"
ipaddress = gethostbyname(gethostname())
deviceid = get_device_id()
login = getlogin( )
expandUser = path.expanduser('~')
tuple_uname = uname()
platformSystem = tuple_uname[0]
platformNode = tuple_uname[1]
platformRelease = tuple_uname[2]
platformVersion = tuple_uname[3]
platformMachine = tuple_uname[4]
platformProcessor = processor()
def processLogs():
    print (fg.YELLOW + style.BRIGHT + 'ProcessLogs start: ' + datetime.now().strftime("%m/%d/%Y %H:%M:%S") + style.END) 
    processError = 0
    processLogs_start = perf_counter()
    processLogs_duration = 0 
    errorlog_duration = 0
    combined_duration = 0
    vhost_duration = 0
    csv2mysql_duration = 0
    useragent_duration = 0
    geoip2_duration = 0
    conn = connect(**db_params)
    getImportDeviceID = ("SELECT apache_logs.importDeviceID('" + deviceid + 
                         "', '"  + platformNode + 
                         "', '"  + platformSystem + 
                         "', '"  + platformMachine + 
                         "', '"  + platformProcessor + "');")
    importLoadCursor = conn.cursor()
    try:
        importLoadCursor.execute( getImportDeviceID )
    except:
        processError += 1
        print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importDeviceID() failed' + style.END)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importLoadCursor.callproc("errorLoad",["Function apache_logs.importDeviceID()",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    importDeviceTupleID = importLoadCursor.fetchall()
    importDeviceID = importDeviceTupleID[0][0]
    getImportClientID = ("SELECT apache_logs.importClientID('" + ipaddress + 
                         "', '"  + login + 
                         "', '"  + expandUser + 
                         "', '"  + platformRelease + 
                         "', '"  + platformVersion + 
                         "', '"  + str(importDeviceID) + "');")
    try:
        importLoadCursor.execute( getImportClientID )
    except:
        processError += 1
        print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importClientID() failed' + style.END)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importLoadCursor.callproc("errorLoad",["Function apache_logs.importClientID()",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    importClientTupleID = importLoadCursor.fetchall()
    importClientID = importClientTupleID[0][0]
    getImportLoadID = "SELECT apache_logs.importLoadID('" + str(importClientID) + "');"
    try:
        importLoadCursor.execute( getImportLoadID )
    except:
        processError += 1
        print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importLoadID(importClientID) failed' + style.END)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importLoadCursor.callproc("errorLoad",["Function apache_logs.importLoadID(importClientID)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    importLoadTupleID = importLoadCursor.fetchall()
    importLoadID = importLoadTupleID[0][0]
    errorDataLoaded = 0
    errorFilesFound = 0
    errorFilesLoaded = 0
    errorRecordsLoaded = 0
    errorParseCalled = 0
    errorImportCalled = 0
    combinedDataLoaded = 0
    combinedFilesFound = 0
    combinedFilesLoaded = 0
    combinedRecordsLoaded = 0
    combinedParseCalled = 0
    combinedImportCalled = 0
    vhostDataLoaded = 0
    vhostFilesFound = 0
    vhostFilesLoaded = 0
    vhostRecordsLoaded = 0
    vhostParseCalled = 0
    vhostImportCalled = 0
    csv2mysqlDataLoaded = 0
    csv2mysqlFilesFound = 0
    csv2mysqlFilesLoaded = 0
    csv2mysqlRecordsLoaded = 0
    csv2mysqlParseCalled = 0
    csv2mysqlImportCalled = 0
    userAgentRecordsParsed = 0 
    userAgentNormalizeCalled = 0
    ipAddressRecordsParsed = 0 
    ipAddressNormalizeCalled = 0
    backup_Path = Path(backup_path)
    watch_Path = Path(watch_path)
    def copy_backup_file(log_path_file, log_days):
        fileCopied = False
        if backup_days > 0 and log_days > backup_days:
            log_relpath = path.relpath(log_path_file, watch_Path)
            copy_path =  path.join(backup_Path, log_relpath)
            try:
                makedirs(path.dirname(copy_path), exist_ok=True)
                try:
                    shutil.copy2(log_path_file, copy_path)
                    print(fg.GREENER + style.BRIGHT + "Copied file to : " + copy_path + style.END)
                    fileCopied = True
                except FileNotFoundError:
                    print(bg.RED + style.BRIGHT + 'ERROR - Source file not found: ' + log_path_file + style.END)
                    importLoadCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Source file not found: " + log_path_file,str(importLoadID)])
                except PermissionError:
                    print(bg.RED + style.BRIGHT + 'ERROR - Permission denied: Cannot copy ' + log_path_file + style.END)
                    importLoadCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Permission denied: Cannot copy " + log_path_file,str(importLoadID)])
                except shutil.SameFileError:
                    print(bg.RED + style.BRIGHT + 'ERROR - Source and destination are the same file - ' + log_path_file + style.END)
                    importLoadCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Source and destination are the same file - " + log_path_file,str(importLoadID)])
                except OSError as e:
                    print(bg.RED + style.BRIGHT + 'ERROR - Error copying file: ' + log_path_file + style.END, e)
                    importLoadCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Error copying file: " + log_path_file,str(importLoadID)])
            except FileExistsError:
                print(bg.RED + style.BRIGHT + 'ERROR - One or more directories in ' + log_path_file + ' already exist.' + style.END)
                importLoadCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"One or more directories in " + log_path_file + " already exist.",str(importLoadID)])
            except PermissionError:
                print(bg.RED + style.BRIGHT + 'ERROR - Permission denied: Unable to create ' + log_path_file + style.END)
                importLoadCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Permission denied: Unable to create  " + log_path_file,str(importLoadID)])
            except Exception as e:
                print(bg.RED + style.BRIGHT + 'ERROR - An error occurred: ' + log_path_file + style.END, e)
                importLoadCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"An error occurred: " + log_path_file,str(importLoadID)])
        if backup_days == -1 or fileCopied:
            try:
                remove(log_path_file)
                print(bg.CYAN + style.BRIGHT + "Deleted file : " + log_path_file + style.END)
            except Exception as e:
                print(bg.RED + style.BRIGHT + 'ERROR - An error occurred deleting file: ' + log_path_file + style.END, e)
                importLoadCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"An error occurred deleting file: " + log_path_file,str(importLoadID)])
    importFileCursor = conn.cursor()
    if errorlog == 1:
        errorlog_start = perf_counter()
        if errorlog_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting Error Logs processing | ' + datetime.now().strftime("%m/%d/%Y %H:%M:%S") + ' | Execution time: %s seconds' % round((perf_counter() - processLogs_start),2) + style.END)
        for errorFile in glob(errorlog_path, recursive=errorlog_recursive):
            errorFilesFound += 1
            errorLoadFile = errorFile.replace(sep, sep+sep)
            fileExistsSQL = "SELECT apache_logs.importFileExists('" + errorLoadFile + "', '"  + str(importDeviceID) + "');"
            try:
                importFileCursor.execute( fileExistsSQL )
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileExists(error_log) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Function apache_logs.importFileExists(error_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            fileExistsTuple = importFileCursor.fetchall()
            fileExists = fileExistsTuple[0][0]
            if fileExists is None:
                errorFilesLoaded += 1
                errorDataLoaded = 1
                if errorlog_log >= 2:
                    print('Loading Error log | ' + errorFile )
                fileInsertCreated = ctime(path.getctime(errorFile))
                fileInsertModified = ctime(path.getmtime(errorFile))
                fileInsertSize = str(path.getsize(errorFile))
                fileInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  errorLoadFile + 
                                  "', '" + fileInsertSize + 
                                  "', '"  + fileInsertCreated + 
                                  "', '"  + fileInsertModified + 
                                  "', '"  + str(importDeviceID) + 
                                  "', '"  + str(importLoadID) + 
                                  "', '5' );")
                try:
                    importFileCursor.execute( fileInsertSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileID(error_log) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["Function apache_logs.importFileID(error_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                fileInsertTupleID = importFileCursor.fetchall()
                fileInsertFileID = fileInsertTupleID[0][0]
                if errorlog_server and errorlog_serverport:
                  fileLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + errorlog_server + "', server_port=" + str(errorlog_serverport)
                elif errorlog_server:
                  fileLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + errorlog_server + "'"
                else:
                  fileLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)
                try:
                    importFileCursor.execute( fileLoadSQL )
                    importFileCursor.execute( "SELECT ROW_COUNT()" )
                    fileRecordsLoadedTuple = importFileCursor.fetchall()
                    # print(fileRecordsLoadedTuple)
                    fileRecordsLoaded = fileRecordsLoadedTuple[0][0]
                    errorRecordsLoaded = errorRecordsLoaded + fileRecordsLoaded
                    # print("fileRecordsLoaded:" + str(fileRecordsLoaded) + " - errorRecordsLoaded:" + str(errorRecordsLoaded))
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_error_default failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_error_default",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
            elif backup_days != 0:
               copy_backup_file(errorFile, fileExists)
        if errorlog_process >= 1 and errorDataLoaded == 1:
            errorParseCalled += 1
            errorlog_parse_start = perf_counter()
            if errorlog_log >= 1:
                print('*','Parsing Error Logs Start | ' + str(errorRecordsLoaded) + ' records ')
            try:
               importFileCursor.callproc("process_error_parse",["default",str(importLoadID)])
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_error_parse(default) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Stored Procedure process_error_parse(default)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if errorlog_log >= 1:
                print('*','Parsing Error Logs Complete | Executed in %s seconds' % round((perf_counter() - errorlog_parse_start),2))
            if errorlog_process >= 2:
                errorImportCalled += 1
                errorlog_import_start = perf_counter()
                if errorlog_log >= 1:
                    print('*','*','Importing Error Logs Start | ' + str(errorRecordsLoaded) + ' records')
                try:
                    importFileCursor.callproc("process_error_import",["default",str(importLoadID)])
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_error_import(default) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["Stored Procedure process_error_import(default)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                if errorlog_log >= 1:
                    print('*','*','Importing Error Logs Complete | Executed in %s seconds' % round((perf_counter() - errorlog_import_start),2))
        errorlog_duration = perf_counter() - errorlog_start            
        if errorlog_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed Error Logs processing | ' + str(errorFilesLoaded) + ' files loaded | Executed in %s seconds' % round(errorlog_duration,2) + style.END)
    if combined == 1:
        combined_start = perf_counter()
        if combined_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting Combined Access Logs processing | ' + datetime.now().strftime("%m/%d/%Y %H:%M:%S") + ' | Execution time: %s seconds' % round((perf_counter() - processLogs_start),2) + style.END)
        for combinedFile in glob(combined_path, recursive=combined_recursive):
            combinedFilesFound += 1
            combinedLoadFile = combinedFile.replace(sep, sep+sep)
            fileExistsSQL = "SELECT apache_logs.importFileExists('" + combinedLoadFile + "', '"  + str(importDeviceID) + "');"
            try:
                importFileCursor.execute( fileExistsSQL )
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileExists(combined_log) failed')
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Function apache_logs.importFileExists(combined_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            fileExistsTuple = importFileCursor.fetchall()
            fileExists = fileExistsTuple[0][0]
            if fileExists is None:
                combinedFilesLoaded += 1
                if combined_log >= 2:
                    print('Loading Combined Access Log | ' + combinedFile )
                combinedDataLoaded = 1
                fileInsertCreated = ctime(path.getctime(combinedFile))
                fileInsertModified = ctime(path.getmtime(combinedFile))
                fileInsertSize = str(path.getsize(combinedFile))
                fileInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  combinedLoadFile + 
                                  "', '" + fileInsertSize + 
                                  "', '"  + fileInsertCreated + 
                                  "', '"  + fileInsertModified + 
                                  "', '"  + str(importDeviceID) + 
                                  "', '"  + str(importLoadID) + 
                                  "', '2' );")
                try:
                    importFileCursor.execute( fileInsertSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileID(combined_log) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["Function apache_logs.importFileID(combined_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                fileInsertTupleID = importFileCursor.fetchall()
                fileInsertFileID = fileInsertTupleID[0][0]
                if combined_server and combined_serverport:
                  fileLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + combined_server + "', server_port=" + str(combined_serverport)
                elif combined_server:
                  fileLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + combined_server + "'"
                else:
                  fileLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)
                try:
                    importFileCursor.execute( fileLoadSQL )
                    importFileCursor.execute( "SELECT ROW_COUNT()" )
                    fileRecordsLoadedTuple = importFileCursor.fetchall()
                    # print(fileRecordsLoadedTuple)
                    fileRecordsLoaded = fileRecordsLoadedTuple[0][0]
                    combinedRecordsLoaded = combinedRecordsLoaded + fileRecordsLoaded
                    # print("fileRecordsLoaded:" + str(fileRecordsLoaded) + " - errorRecordsLoaded:" + str(errorRecordsLoaded))
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_combined failed')
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_access_combined",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
            elif backup_days != 0:
               copy_backup_file(combinedFile, fileExists)
        if combined_process >= 1 and combinedDataLoaded == 1:
            combined_parse_start = perf_counter()
            combinedParseCalled += 1
            if combined_log >= 1:
                print('*','Parsing Combined Access Logs Start | ' + str(combinedRecordsLoaded) + ' records')
            try:
                importFileCursor.callproc("process_access_parse",["combined",str(importLoadID)])
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_parse(combined) failed')
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Stored Procedure process_access_parse(combined)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if combined_log >= 1:
                print('*','Parsing Combined Access Logs Complete | Executed in %s seconds' % round((perf_counter() - combined_parse_start),2))
            if combined_process >= 2:
                combined_import_start = perf_counter()
                combinedImportCalled += 1
                if combined_log >= 1:
                    print('*','*','Importing Combined Access Logs Start | ' + str(combinedRecordsLoaded) + ' records')
                combinedProcedureCursor = conn.cursor()
                try:
                    combinedProcedureCursor.callproc("process_access_import",["combined",str(importLoadID)])
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_import(combined) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["Stored Procedure process_access_import(combined)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                combinedProcedureCursor.close()
                if combined_log >= 1:
                    print('*','*','Importing Combined Access Logs Complete | Executed in %s seconds' % round((perf_counter() - combined_import_start),2))
        combined_duration = perf_counter() - combined_start            
        if combined_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed Combined Access Logs processing | '+ str(combinedFilesLoaded) + ' files loaded | Executed in %s seconds' % round(combined_duration,4) + style.END)
    if vhost == 1:
        vhost_start = perf_counter()
        if vhost_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting Vhost Access Logs processing | ' + datetime.now().strftime("%m/%d/%Y %H:%M:%S") + ' | Execution time: %s seconds' % round((perf_counter() - processLogs_start),2) + style.END)
        for vhostFile in glob(vhost_path, recursive=vhost_recursive):
            vhostFilesFound += 1
            vhostLoadFile = vhostFile.replace(sep, sep+sep)
            fileExistsSQL = "SELECT apache_logs.importFileExists('" + vhostLoadFile + "', '"  + str(importDeviceID) + "');"
            try:
                importFileCursor.execute( fileExistsSQL )
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileExists(vhost_log) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Function apache_logs.importFileExists(vhost_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            fileExistsTuple = importFileCursor.fetchall()
            fileExists = fileExistsTuple[0][0]
            if fileExists is None:
                vhostFilesLoaded += 1
                if vhost_log >= 2:
                    print('Loading Vhost Access Log - ' + vhostFile)
                vhostDataLoaded = 1
                fileInsertCreated = ctime(path.getctime(vhostFile))
                fileInsertModified = ctime(path.getmtime(vhostFile))
                fileInsertSize = str(path.getsize(vhostFile))
                fileInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  vhostLoadFile + 
                                  "', '" + fileInsertSize + 
                                  "', '"  + fileInsertCreated + 
                                  "', '"  + fileInsertModified + 
                                  "', '"  + str(importDeviceID) + 
                                  "', '"  + str(importLoadID) + 
                                  "', '3' );")
                try:
                    importFileCursor.execute( fileInsertSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileID(vhost_log) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["Function apache_logs.importFileID(vhost_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                fileInsertTupleID = importFileCursor.fetchall()
                fileInsertFileID = fileInsertTupleID[0][0]
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + vhostLoadFile + "' INTO TABLE load_access_vhost FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)
                try:
                    importFileCursor.execute( fileLoadSQL )
                    importFileCursor.execute( "SELECT ROW_COUNT()" )
                    fileRecordsLoadedTuple = importFileCursor.fetchall()
                    # print(fileRecordsLoadedTuple)
                    fileRecordsLoaded = fileRecordsLoadedTuple[0][0]
                    vhostRecordsLoaded = vhostRecordsLoaded + fileRecordsLoaded
                    # print("fileRecordsLoaded:" + str(fileRecordsLoaded) + " - errorRecordsLoaded:" + str(errorRecordsLoaded))
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_vhost failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_access_vhost",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
            elif backup_days != 0:
               copy_backup_file(vhostFile, fileExists)
        if vhost_process >= 1 and vhostDataLoaded == 1:
            vhost_parse_start = perf_counter()
            vhostParseCalled += 1
            if vhost_log >= 1:
                print('*','Parsing Vhost Access Logs Start | ' + str(vhostRecordsLoaded) + ' records')
            try:
                importFileCursor.callproc("process_access_parse",["vhost",str(importLoadID)])
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_parse(vhost) failed')
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Stored Procedure process_access_parse(vhost)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if vhost_log >= 1:
                print('*','Parsing Vhost Access Logs Complete | Executed in %s seconds' % round((perf_counter() - vhost_parse_start),2))
            if vhost_process >= 2:
                vhost_import_start = perf_counter()
                vhostImportCalled += 1
                if vhost_log >= 1:
                    print('*','*','Importing Vhost Access Logs Start | ' + str(vhostRecordsLoaded) + ' records')
                vhostProcedureCursor = conn.cursor()
                try:
                    vhostProcedureCursor.callproc("process_access_import",["vhost",str(importLoadID)])
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_import(vhost) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["Stored Procedure process_access_import(vhost)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                vhostProcedureCursor.close()
                if vhost_log >= 1:
                    print('*','*','Importing Vhost Access Logs Complete | Executed in %s seconds' % round((perf_counter() - vhost_import_start),2))
        vhost_duration = perf_counter() - vhost_start            
        if vhost_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed Vhost Access Logs processing | Loaded '+ str(vhostFilesLoaded) + ' files | Executed in %s seconds' % round(vhost_duration,2) + style.END)
    if csv2mysql == 1:
        csv2mysql_start = perf_counter()
        if csv2mysql_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting Csv2mysql Access Logs processing | ' + datetime.now().strftime("%m/%d/%Y %H:%M:%S") + ' | Execution time: %s seconds' % round((perf_counter() - processLogs_start),2) + style.END)
        for csv2mysqlFile in glob(csv2mysql_path, recursive=csv2mysql_recursive):
            csv2mysqlFilesFound += 1
            csv2mysqlLoadFile = csv2mysqlFile.replace(sep, sep+sep)
            fileExistsSQL = "SELECT apache_logs.importFileExists('" + csv2mysqlLoadFile + "', '"  + str(importDeviceID) + "');"
            try:
                importFileCursor.execute( fileExistsSQL )
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileExists(csv2mysql_log) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Function apache_logs.importFileExists(csv2mysql_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            fileExistsTuple = importFileCursor.fetchall()
            fileExists = fileExistsTuple[0][0]
            if fileExists is None:
                csv2mysqlFilesLoaded += 1
                if csv2mysql_log >= 2:
                    print('Loading Csv2mysql Access Log - ' + csv2mysqlFile )
                csv2mysqlDataLoaded = 1
                fileInsertCreated = ctime(path.getctime(csv2mysqlFile))
                fileInsertModified = ctime(path.getmtime(csv2mysqlFile))
                fileInsertSize = str(path.getsize(csv2mysqlFile))
                fileInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  csv2mysqlLoadFile + 
                                  "', '" + fileInsertSize + 
                                  "', '"  + fileInsertCreated + 
                                  "', '"  + fileInsertModified + 
                                  "', '"  + str(importDeviceID) + 
                                  "', '"  + str(importLoadID) + 
                                  "', '4' );")
                try:
                    importFileCursor.execute( fileInsertSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileID(csv2mysql_log) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["Function apache_logs.importFileID(csv2mysql_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                fileInsertTupleID = importFileCursor.fetchall()
                fileInsertFileID = fileInsertTupleID[0][0]
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + csv2mysqlLoadFile + "' INTO TABLE load_access_csv2mysql FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)
                try:
                    importFileCursor.execute( fileLoadSQL )
                    importFileCursor.execute( "SELECT ROW_COUNT()" )
                    fileRecordsLoadedTuple = importFileCursor.fetchall()
                    # print(fileRecordsLoadedTuple)
                    fileRecordsLoaded = fileRecordsLoadedTuple[0][0]
                    csv2mysqlRecordsLoaded = csv2mysqlRecordsLoaded + fileRecordsLoaded
                    # print("fileRecordsLoaded:" + str(fileRecordsLoaded) + " - errorRecordsLoaded:" + str(errorRecordsLoaded))
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_csv2mysql failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_access_csv2mysql",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
            elif backup_days != 0:
                copy_backup_file(csv2mysqlFile, fileExists)
        if csv2mysql_process >= 1 and csv2mysqlDataLoaded == 1:
            csv2mysql_parse_start = perf_counter()
            csv2mysqlParseCalled += 1
            if csv2mysql_log >= 1:
                print('*','Parsing Csv2mysql Access Logs Start | ' + str(csv2mysqlRecordsLoaded) + ' records')
            try:
                importFileCursor.callproc("process_access_parse",["csv2mysql",str(importLoadID)])
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_parse(csv2mysql) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Stored Procedure process_access_parse(csv2mysql)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if csv2mysql_log >= 1:
                print('*','Parsing Csv2mysql Access Logs Complete | Executed in %s seconds' % round((perf_counter() - csv2mysql_parse_start),2))
            # Processing loaded data
            if csv2mysql_process >= 2:
                csv2mysql_import_start = perf_counter()
                csv2mysqlImportCalled += 1
                if csv2mysql_log >= 1:
                    print('*','*','Importing Csv2mysql Access Logs Start | ' + str(csv2mysqlRecordsLoaded) + ' records')
                try:
                    importFileCursor.callproc("process_access_import",["csv2mysql",str(importLoadID)])
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_import(csv2mysql) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importLoadCursor.callproc("errorLoad",["Stored Procedure process_access_import(csv2mysql)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                if csv2mysql_log >= 1:
                    print('*','*','Importing Csv2mysql Access Logs Complete | Executed in %s seconds' % round((perf_counter() - csv2mysql_import_start),2))
        csv2mysql_duration = perf_counter() - csv2mysql_start            
        if csv2mysql_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed Csv2mysql Access Logs processing | Loaded '+ str(csv2mysqlFilesLoaded) + ' files | Executed in %s seconds' % round(csv2mysql_duration,2) + style.END)
    # SECONDARY PROCESSES BELOW: Client Module UPLOAD is done with load, parse and import processes of access and error logs. The below processes enhance User Agent and Client IP log data.
    # Initially UserAgent and GeoIP2 processes were each in separate files. After much design consideration and application experience and Code Redundancy being problematic
    # the decision was made to encapsulate all processes within the same "Import Load" which captures and logs all execution metrics, notifications and errors
    # into MySQL tables for each execution. Every log data record can be tracked back to the file, folder, computer, load process, parse process and import process it came from.  
    # Processes may require individual execution even when NONE of above processes are executed. If this Module is run automatically on a client server to upload Apache Logs to centralized 
    # MySQL Server the processes below will never be executed. In some cases, only the processes below are needed for execution on MySQL Server or another centralized computer.
    # In some cases, ALL processes above and below will be executed in a single "Import Load" execution. Therefore, the encapsulation of all processes in a single module.
    if useragent == 1:
        useragent_start = perf_counter()
        if useragent_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting User Agent Information Parsing | Checking access_log_useragent TABLE | ' + datetime.now().strftime("%m/%d/%Y %H:%M:%S") + ' | Execution time: %s seconds' % round((perf_counter() - processLogs_start),2) + style.END)
        selectUserAgentCursor = conn.cursor()
        updateUserAgentCursor = conn.cursor()
        try:
            selectUserAgentCursor.execute("SELECT id, name FROM access_log_useragent WHERE ua_browser IS NULL")
        except:
            processError += 1
            print(bg.RED + style.BRIGHT + 'ERROR - SELECT id, name FROM access_log_useragent WHERE ua_browser IS NULL failed' + style.END)
            showWarnings = conn.show_warnings()
            print(showWarnings)
            importLoadCursor.callproc("errorLoad",["SELECT id, name FROM access_log_useragent WHERE ua_browser",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        for x in range(selectUserAgentCursor.rowcount):
            userAgentRecordsParsed += 1
            userAgent = selectUserAgentCursor.fetchone()
            recID = str(userAgent[0])
            ua = parse(userAgent[1])
            if useragent_log >= 2:
                print(fg.CYAN + style.DIM + 'Parsing information for User Agent | ' + str(ua) + style.END)
            strua = str(ua)
            strua = strua.replace('"', ' in.') # must replace " in string for error occurs
            br = str(ua.browser)  # returns Browser(family=u'Mobile Safari', version=(5, 1), version_string='5.1')
            br = br.replace('"', ' in.') # must replace " in string for error occurs
            br_family = str(ua.browser.family)  # returns 'Mobile Safari'
            br_family = br_family.replace('"', ' in.') # must replace " in string for error occurs
            #ua.browser.version  # returns (5, 1)
            br_version = ua.browser.version_string   # returns '5.1'
            br_version = br_version.replace('"', ' in.') # must replace " in string for error occurs
            # Accessing user agent's operating system properties
            os_str = str(ua.os)  # returns OperatingSystem(family=u'iOS', version=(5, 1), version_string='5.1')
            os_str = os_str.replace('"', ' in.') # must replace " in string for error occurs
            os_family = str(ua.os.family)  # returns 'iOS'
            os_family = os_family.replace('"', ' in.') # must replace " in string for error occurs
            #ua.os.version  # returns (5, 1)
            os_version = ua.os.version_string  # returns '5.1'
            os_version = os_version.replace('"', ' in.') # must replace " in string for error occurs
            # Accessing user agent's device properties
            dv = str(ua.device)  # returns Device(family=u'iPhone', brand=u'Apple', model=u'iPhone')
            dv = dv.replace('"', ' in.') # must replace " in string for error occurs
            dv_family = str(ua.device.family)  # returns 'iPhone'
            dv_family = dv_family.replace('"', ' in.') # must replace " in string for error occurs
            dv_brand = str(ua.device.brand) # returns 'Apple'
            dv_brand = dv_brand.replace('"', ' in.') # must replace " in string for error occurs
            dv_model = str(ua.device.model) # returns 'iPhone'
            dv_model = dv_model.replace('"', ' in.') # must replace " in string for error occurs
            updateSql = ('UPDATE access_log_useragent SET ua="'+ strua + 
                         '", ua_browser="' + br + 
                         '", ua_browser_family="' + br_family + 
                         '", ua_browser_version="' + br_version + 
                         '", ua_os="' + os_str + 
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
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - UPDATE access_log_useragent SET Statement failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["UPDATE access_log_useragent SET Statement",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        conn.commit()
        selectUserAgentCursor.close()
        updateUserAgentCursor.close()        
        if useragent_process >= 1 and userAgentRecordsParsed > 0:
            useragent_normalize_start = perf_counter()
            normalizeUserAgentCursor = conn.cursor()
            if useragent_log >= 1:
                print('*','*','Normalizing User Agent data Start |  ' + str(userAgentRecordsParsed) + ' records')
            try:
                normalizeUserAgentCursor.callproc("normalize_useragent",["Python Processed",str(importLoadID)])
                userAgentNormalizeCalled = 1
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure normalize_useragent(Python Processed) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Stored Procedure normalize_useragent(Python Processed)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            normalizeUserAgentCursor.close()
            if useragent_log >= 1:
                print('*','*','Normalizing User Agent data Complete | Executed in %s seconds' % round((perf_counter() - useragent_normalize_start),2))
        useragent_duration = perf_counter() - useragent_start            
        if useragent_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed User Agent data processing | ' + str(userAgentRecordsParsed) + ' records | Executed in %s seconds' % round(useragent_duration,2) + style.END)
    geoip2_city_file_exists = True
    geoip2_asn_file_exists = True
    if geoip2 == 1:
        geoip2_start = perf_counter()
        geoip2_city_file = geoip2_city.replace(sep, sep+sep)
        geoip2_asn_file = geoip2_asn.replace(sep, sep+sep)
        if not path.exists(geoip2_city_file):
            processError += 1
            geoip2_city_file_exists = False
            print(bg.RED + style.BRIGHT, 'ERROR - IP geolocation CITY database: ' + geoip2_city_file + ' not found.' + style.END)
            importLoadCursor.callproc("errorLoad",["IP geolocation CITY database not found",'1234',geoip2_city_file,str(importLoadID)])
        if not path.exists(geoip2_asn_file):
            processError += 1
            geoip2_asn_file_exists = False
            print(bg.RED + style.BRIGHT, 'ERROR - IP geolocation ASN database: ' + geoip2_asn_file + ' not found.' + style.END)
            importLoadCursor.callproc("errorLoad",["IP geolocation ASN database not found",'1234',geoip2_asn_file,str(importLoadID)])
    if geoip2 == 1 and geoip2_city_file_exists and geoip2_asn_file_exists:
        selectGeoIP2Cursor = conn.cursor()
        updateGeoIP2Cursor = conn.cursor()
        if geoip2_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting IP Address Information Retrieval | Checking log_client TABLE | ' + datetime.now().strftime("%m/%d/%Y %H:%M:%S") + ' | Execution time: %s seconds' % round((perf_counter() - processLogs_start),2) + style.END)
        try:
            selectGeoIP2Cursor.execute("SELECT id, name FROM log_client WHERE country_code IS NULL")
        except:
            processError += 1
            print(bg.RED + style.BRIGHT + 'ERROR - SELECT id, name FROM log_client WHERE ua_browser IS NULL failed' + style.END)
            showWarnings = conn.show_warnings()
            print(showWarnings)
            importLoadCursor.callproc("errorLoad",["SELECT id, name FROM log_client WHERE country_code IS NULL",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        try:
            cityReader = database.Reader(geoip2_city_file)
        except Exception as e:
            processError += 1
            print(bg.RED + style.BRIGHT + 'ERROR - cityReader = geoip2.database.Reader failed' + style.END, e)
            importLoadCursor.callproc("errorLoad",["cityReader = geoip2.database.Reader failed", '1111', e, str(importLoadID)])
        try:
            asnReader = database.Reader(geoip2_asn_file)
        except Exception as e:
            processError += 1
            print(bg.RED + style.BRIGHT + 'ERROR - cityReader = geoip2.database.Reader failed' + style.END, e)
            importLoadCursor.callproc("errorLoad",["cityReader = geoip2.database.Reader failed", '1111', e, str(importLoadID)])
        for x in range(selectGeoIP2Cursor.rowcount):
            ipAddressRecordsParsed += 1
            geoIP2 = selectGeoIP2Cursor.fetchone()
            recID = str(geoIP2[0])
            ipAddress = geoIP2[1]
            country_code = ''
            country = ''
            subdivision = ''
            city = ''
            latitude = 0.0
            longitude = 0.0
            organization = ''
            network = ''
            if geoip2_log >= 2:
                print(fg.CYAN + style.DIM + 'Retrieving information for IP Address | ' + ipAddress + style.END)
            try:
                cityData = cityReader.city(ipAddress)
                if cityData.country.iso_code is not None:
                    country_code = cityData.country.iso_code
                    country_code = country_code.replace('"', '')
                if cityData.country.name is not None:
                    country = cityData.country.name
                    country = country.replace('"', '')
                if cityData.city.name is not None:
                    city = cityData.city.name
                    city = city.replace('"', '')
                if cityData.subdivisions.most_specific.name is not None:
                    subdivision = cityData.subdivisions.most_specific.name
                    subdivision = subdivision.replace('"', '')
                if cityData.location.latitude is not None:
                    latitude = cityData.location.latitude
                if cityData.location.longitude is not None:
                    longitude = cityData.location.longitude
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - cityReader.city(' + ipAddress + ')' + style.END)
                importLoadCursor.callproc("errorLoad",["cityReader.city() failed", '1234', ipAddress, str(importLoadID)])
            try:
                asnData = asnReader.asn(ipAddress)
                if asnData.autonomous_system_organization is not None:
                    organization = asnData.autonomous_system_organization
                    organization = organization.replace('"', '')
                if asnData.network is not None:
                    network = asnData.network
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - asnReader.asn(' + ipAddress + ')' + style.END)
                importLoadCursor.callproc("errorLoad",["asnReader.asn() failed", '1234', ipAddress, str(importLoadID)])
            updateSql = ('UPDATE log_client SET country_code="'+ country_code + 
                       '", country="' + country + 
                       '", subdivision="' + subdivision + 
                       '", city="' + city + 
                       '", latitude=' + str(latitude) + 
                       ', longitude=' + str(longitude) + 
                       ', organization="' + organization + 
                       '", network="' + str(network) + 
                       '" WHERE id=' + recID + ';')
            try:
                updateGeoIP2Cursor.execute(updateSql)
            except:
              processError += 1
              print(bg.RED + style.BRIGHT + 'ERROR - UPDATE log_client SET Statement failed' + style.END)
              showWarnings = conn.show_warnings()
              print(showWarnings)
              importLoadCursor.callproc("errorLoad",["UPDATE log_client SET Statement",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        conn.commit()
        selectGeoIP2Cursor.close()
        updateGeoIP2Cursor.close()        
        if geoip2_process >= 1 and ipAddressRecordsParsed > 0:
            geoip2_normalize_start = perf_counter()
            normalizeGeoIP2Cursor = conn.cursor()
            if geoip2_log >= 1:
                print('*','*','Normalizing IP Address data Start | '+ str(ipAddressRecordsParsed) + ' records')
            try:
                normalizeGeoIP2Cursor.callproc("normalize_client",["Python Processed",str(importLoadID)])
                ipAddressNormalizeCalled = 1
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure normalize_client(Python Processed) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importLoadCursor.callproc("errorLoad",["Stored Procedure normalize_client(Python Processed)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            normalizeGeoIP2Cursor.close()
            if geoip2_log >= 1:
                print('*','*','Normalizing IP Address data Complete | Executed in %s seconds' % round((perf_counter() - geoip2_normalize_start),2))
        geoip2_duration = perf_counter() - geoip2_start            
        if geoip2_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed IP Address data processing | '+ str(ipAddressRecordsParsed) + ' records | Executed in %s seconds' % round(geoip2_duration,2) + style.END)
    processLogs_duration = perf_counter() - processLogs_start            
    loadUpdateSQL = ('UPDATE import_load SET errorFilesFound=' + str(errorFilesFound) + 
                  ', errorFilesLoaded=' + str(errorFilesLoaded) + 
                  ', errorRecordsLoaded=' + str(errorRecordsLoaded) + 
                  ', errorParseCalled=' + str(errorParseCalled) + 
                  ', errorImportCalled=' + str(errorImportCalled) + 
                  ', errorSeconds=' + str(round(errorlog_duration,0)) + 
                  ', combinedFilesFound=' + str(combinedFilesFound) + 
                  ', combinedFilesLoaded=' + str(combinedFilesLoaded) + 
                  ', combinedRecordsLoaded=' + str(combinedRecordsLoaded) + 
                  ', combinedParseCalled=' + str(combinedParseCalled) + 
                  ', combinedImportCalled=' + str(combinedImportCalled) + 
                  ', combinedSeconds=' + str(round(combined_duration,0)) + 
                  ', vhostFilesFound=' + str(vhostFilesFound) + 
                  ', vhostFilesLoaded=' + str(vhostFilesLoaded) + 
                  ', vhostRecordsLoaded=' + str(vhostRecordsLoaded) + 
                  ', vhostParseCalled=' + str(vhostParseCalled) + 
                  ', vhostImportCalled=' + str(vhostImportCalled) + 
                  ', vhostSeconds=' + str(round(vhost_duration,0)) + 
                  ', csv2mysqlFilesFound=' + str(csv2mysqlFilesFound) + 
                  ', csv2mysqlFilesLoaded=' + str(csv2mysqlFilesLoaded) + 
                  ', csv2mysqlRecordsLoaded=' + str(csv2mysqlRecordsLoaded) + 
                  ', csv2mysqlParseCalled=' + str(csv2mysqlParseCalled) + 
                  ', csv2mysqlImportCalled=' + str(csv2mysqlImportCalled) + 
                  ', csv2mysqlSeconds=' + str(round(csv2mysql_duration,0)) + 
                  ', userAgentRecordsParsed=' + str(userAgentRecordsParsed) + 
                  ', userAgentNormalizeCalled=' + str(userAgentNormalizeCalled) + 
                  ', userAgentSeconds=' + str(round(useragent_duration,0)) + 
                  ', ipAddressRecordsParsed=' + str(ipAddressRecordsParsed) + 
                  ', ipAddressNormalizeCalled=' + str(ipAddressNormalizeCalled) + 
                  ', ipAddressSeconds=' + str(round(geoip2_duration,0)) + 
                  ', errorOccurred=' + str(processError) + 
                  ', completed=now()' + 
                  ', processSeconds=' + str(round(processLogs_duration,0)) + ' WHERE id=' + str(importLoadID) +';')
    try:
        importLoadCursor.execute(loadUpdateSQL)
    except:
        processError += 1
        print(bg.RED + style.BRIGHT + 'ERROR - UPDATE import_load SET Statement failed' + style.END)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importLoadCursor.callproc("errorLoad",["UPDATE import_load SET Statement",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    conn.commit()
    importFileCursor.close()
    importLoadCursor.close()
    conn.close()
    print(fg.GREEN + style.BRIGHT + 'Import Load Summary | Log File & Record Counts and Process Metrics | ImportLoadID:' + str(importLoadID) + ' | ClientID:' + str(importClientID) + ' | DeviceID:' + str(importDeviceID) + ' | Errors Found:' + str(processError) + style.END)
    log_headers = ["Log Formats", "Files Found", "Files Loaded", "Records Loaded", "Data Parsed", "Data Imported", "Execution Time"]
    log_processes = [ 
    ["Error Logs", errorFilesFound, errorFilesLoaded, errorRecordsLoaded, bool(errorParseCalled), bool(errorImportCalled), round(errorlog_duration,2)], 
    ["Combined Access",combinedFilesFound, combinedFilesLoaded, combinedRecordsLoaded, bool(combinedParseCalled), bool(combinedImportCalled), round(combined_duration,2)], 
    ["Vhost Access", vhostFilesFound, vhostFilesLoaded, vhostRecordsLoaded, bool(vhostParseCalled), bool(vhostImportCalled), round(vhost_duration,2)], 
    ["Csv2mysql Access", csv2mysqlFilesFound, csv2mysqlFilesLoaded, csv2mysqlRecordsLoaded, bool(csv2mysqlParseCalled), bool(csv2mysqlImportCalled), round(csv2mysql_duration,2)] 
    ]
    # Print table headers
    print("Process".ljust(10), end = "")
    for col in log_headers:
        print(col.ljust(18), end="")
    print()
    # Print table rows
    for i, row in enumerate(log_processes, start = 1):
        print(str(i).ljust(10), end = "")                      
        for col in row:
            print(str(col).ljust(18), end = "")
        print()
    print(fg.GREEN + style.BRIGHT + 'Apache Log Data Enhancement Processes' + style.END)
    data_headers = ["Enhancement", "Records", "Data Normalized", "Execution Time"]
    data_enhancements = [ 
    ["User Agent data", userAgentRecordsParsed, bool(userAgentNormalizeCalled), round(useragent_duration,2)], 
    ["IP Address data", ipAddressRecordsParsed, bool(ipAddressNormalizeCalled), round(geoip2_duration,2)] 
    ]
    # Print table headers
    print("Process".ljust(10), end = "")
    for col in data_headers:
        print(col.ljust(18), end="")
    print()
    # Print table rows
    for i, row in enumerate(data_enhancements, start = 1):
        print(str(i).ljust(10), end = "")                      
        for col in row:
            print(str(col).ljust(18), end = "")
        print()
    print(fg.LIGHT_GREEN + style.NORMAL + 'ImportLoadID:' + str(importLoadID) + ' | ' + str(processError) + ' Errors Found | Import Load Summary Values added to apache_logs.import_load TABLE' + style.END)
    print(fg.YELLOW + style.BRIGHT + 'ProcessLogs complete: ' + datetime.now().strftime("%m/%d/%Y %H:%M:%S") + ' | Execution time: %s seconds' % round((perf_counter() - processLogs_start),2) + style.END)
if __name__ == "__main__":
    print("logs2mysql.py run directly")
    processLogs()
