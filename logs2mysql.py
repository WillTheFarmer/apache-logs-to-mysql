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
# version 3.2.0 - 02/01/2025 - MariaDB compatible and Log Rotation - see changelog
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
from time import time
from time import ctime
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
errorlog_server = '' # getenv('ERROR_SERVER')
errorlog_serverport = '' # int(getenv('ERROR_SERVERPORT'))
combined = int(getenv('COMBINED'))
combined_path = getenv('COMBINED_PATH')
combined_recursive = bool(int(getenv('COMBINED_RECURSIVE')))
combined_log = int(getenv('COMBINED_LOG'))
combined_process = int(getenv('COMBINED_PROCESS'))
combined_server = '' # getenv('COMBINED_SERVER')
combined_serverport = '' # int(getenv('COMBINED_SERVERPORT'))
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
    processError = 0
    start_time = time()
    print (fg.YELLOW + style.BRIGHT + 'ProcessLogs start: ' + str(datetime.now()) + style.END) 
    conn = connect(**db_params)
    getImportDeviceID = ("SELECT apache_logs.importDeviceID('" + deviceid + 
                         "', '"  + platformNode + 
                         "', '"  + platformSystem + 
                         "', '"  + platformMachine + 
                         "', '"  + platformProcessor + "');")
    importDeviceCursor = conn.cursor()
    try:
        importDeviceCursor.execute( getImportDeviceID )
    except:
        processError += 1
        print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importDeviceID() failed' + style.END)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importDeviceCursor.callproc("errorLoad",["Function apache_logs.importDeviceID()",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    importDeviceTupleID = importDeviceCursor.fetchall()
    importDeviceID = importDeviceTupleID[0][0]
    getImportClientID = ("SELECT apache_logs.importClientID('" + ipaddress + 
                         "', '"  + login + 
                         "', '"  + expandUser + 
                         "', '"  + platformRelease + 
                         "', '"  + platformVersion + 
                         "', '"  + str(importDeviceID) + "');")
    importClientCursor = conn.cursor()
    try:
        importClientCursor.execute( getImportClientID )
    except:
        processError += 1
        print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importClientID() failed' + style.END)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importClientCursor.callproc("errorLoad",["Function apache_logs.importClientID()",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    importClientTupleID = importClientCursor.fetchall()
    importClientID = importClientTupleID[0][0]
    getImportLoadID = "SELECT apache_logs.importLoadID('" + str(importClientID) + "');"
    importLoadCursor = conn.cursor()
    try:
        importLoadCursor.execute( getImportLoadID )
    except:
        processError += 1
        print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importLoadID(importClientID) failed' + style.END)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importClientCursor.callproc("errorLoad",["Function apache_logs.importLoadID(importClientID)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    importLoadTupleID = importLoadCursor.fetchall()
    importLoadID = importLoadTupleID[0][0]
    errorDataLoaded = 0
    errorFilesFound = 0
    errorFilesLoaded = 0
    errorParseCalled = 0
    errorImportCalled = 0
    combinedDataLoaded = 0
    combinedFilesFound = 0
    combinedFilesLoaded = 0
    combinedParseCalled = 0
    combinedImportCalled = 0
    vhostDataLoaded = 0
    vhostFilesFound = 0
    vhostFilesLoaded = 0
    vhostParseCalled = 0
    vhostImportCalled = 0
    csv2mysqlDataLoaded = 0
    csv2mysqlFilesFound = 0
    csv2mysqlFilesLoaded = 0
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
                    importClientCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Source file not found: " + log_path_file,str(importLoadID)])
                except PermissionError:
                    print(bg.RED + style.BRIGHT + 'ERROR - Permission denied: Cannot copy ' + log_path_file + style.END)
                    importClientCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Permission denied: Cannot copy " + log_path_file,str(importLoadID)])
                except shutil.SameFileError:
                    print(bg.RED + style.BRIGHT + 'ERROR - Source and destination are the same file - ' + log_path_file + style.END)
                    importClientCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Source and destination are the same file - " + log_path_file,str(importLoadID)])
                except OSError as e:
                    print(bg.RED + style.BRIGHT + 'ERROR - Error copying file: ' + log_path_file + style.END, e)
                    importClientCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Error copying file: " + log_path_file,str(importLoadID)])
            except FileExistsError:
                print(bg.RED + style.BRIGHT + 'ERROR - One or more directories in ' + log_path_file + ' already exist.' + style.END)
                importClientCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"One or more directories in " + log_path_file + " already exist.",str(importLoadID)])
            except PermissionError:
                print(bg.RED + style.BRIGHT + 'ERROR - Permission denied: Unable to create ' + log_path_file + style.END)
                importClientCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Permission denied: Unable to create  " + log_path_file,str(importLoadID)])
            except Exception as e:
                print(bg.RED + style.BRIGHT + 'ERROR - An error occurred: ' + log_path_file + style.END, e)
                importClientCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"An error occurred: " + log_path_file,str(importLoadID)])
        if backup_days == -1 or fileCopied:
            try:
                remove(log_path_file)
                print(bg.CYAN + style.BRIGHT + "Deleted file : " + log_path_file + style.END)
            except Exception as e:
                print(bg.RED + style.BRIGHT + 'ERROR - An error occurred deleting file: ' + log_path_file + style.END, e)
                importClientCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"An error occurred deleting file: " + log_path_file,str(importLoadID)])
    if errorlog == 1:
        if errorlog_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting Error Logs processing - %s second' % round((time() - start_time),4) + style.END)
        errorExistsCursor = conn.cursor()
        errorInsertCursor = conn.cursor()
        errorLoadCursor = conn.cursor()
        for errorFile in glob(errorlog_path, recursive=errorlog_recursive):
            errorFilesFound += 1
            errorLoadFile = errorFile.replace(sep, sep+sep)
            errorExistsSQL = "SELECT apache_logs.importFileExists('" + errorLoadFile + "', '"  + str(importDeviceID) + "');"
            try:
                errorExistsCursor.execute( errorExistsSQL )
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileExists(error_log) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Function apache_logs.importFileExists(error_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            errorExistsTuple = errorExistsCursor.fetchall()
            errorExists = errorExistsTuple[0][0]
            if errorExists is None:
                errorFilesLoaded += 1
                errorDataLoaded = 1
                if errorlog_log >= 2:
                    print('Loading Error log - ' + errorFile )
                errorLoadCreated = ctime(path.getctime(errorFile))
                errorLoadModified = ctime(path.getmtime(errorFile))
                errorLoadSize = str(path.getsize(errorFile))
                errorInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  errorLoadFile + 
                                  "', '" + errorLoadSize + 
                                  "', '"  + errorLoadCreated + 
                                  "', '"  + errorLoadModified + 
                                  "', '"  + str(importDeviceID) + 
                                  "', '"  + str(importLoadID) + 
                                  "', '5' );")
                try:
                    errorInsertCursor.execute( errorInsertSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileID(error_log) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Function apache_logs.importFileID(error_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                errorInsertTupleID = errorInsertCursor.fetchall()
                errorInsertFileID = errorInsertTupleID[0][0]
                if errorlog_server and errorlog_serverport:
                  errorLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(errorInsertFileID) + ", server_name='" + errorlog_server + "', server_port=" + str(errorlog_serverport)
                elif errorlog_server:
                  errorLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(errorInsertFileID) + ", server_name='" + errorlog_server + "'"
                else:
                  errorLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(errorInsertFileID)
                try:
                    errorLoadCursor.execute( errorLoadSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_error_default failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_error_default",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
            elif backup_days != 0:
               copy_backup_file(errorFile, errorExists)
        if errorlog_process >= 1 and errorDataLoaded == 1:
            errorParseCalled += 1
            if errorlog_log >= 1:
                print('*','Started Parsing Error Logs Stored Procedure - %s seconds' % round((time() - start_time),4))
            try:
               errorLoadCursor.callproc("process_error_parse",["default",str(importLoadID)])
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_error_parse(default) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure process_error_parse(default)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if errorlog_log >= 1:
                print('*','Completed Parsing Error Logs Stored Procedure - %s seconds' % round((time() - start_time),4))
            if errorlog_process >= 2:
                errorImportCalled += 1
                if errorlog_log >= 1:
                    print('*','*','Started Importing Error Logs Stored Procedure - %s seconds' % round((time() - start_time),4))
                errorProcedureCursor = conn.cursor()
                try:
                    errorProcedureCursor.callproc("process_error_import",["default",str(importLoadID)])
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_error_import(default) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Stored Procedure process_error_import(default)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                errorProcedureCursor.close()
                if errorlog_log >= 1:
                    print('*','*','Completed Importing Error Logs Stored Procedure - %s seconds' % round((time() - start_time),4))
        if errorlog_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed Error Logs processing. Loaded '+ str(errorFilesFound) + ' files - %s seconds' % round((time() - start_time),4) + style.END)
        errorInsertCursor.close()
        errorLoadCursor.close()
        errorExistsCursor.close()
    if combined == 1:
        if combined_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting Combined Access Logs processing - %s seconds' % round((time() - start_time),4) + style.END)
        combinedExistsCursor = conn.cursor()
        combinedInsertCursor = conn.cursor()
        combinedLoadCursor = conn.cursor()
        for combinedFile in glob(combined_path, recursive=combined_recursive):
            combinedFilesFound += 1
            combinedLoadFile = combinedFile.replace(sep, sep+sep)
            combinedExistsSQL = "SELECT apache_logs.importFileExists('" + combinedLoadFile + "', '"  + str(importDeviceID) + "');"
            try:
                combinedExistsCursor.execute( combinedExistsSQL )
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileExists(combined_log) failed')
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Function apache_logs.importFileExists(combined_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            combinedExistsTuple = combinedExistsCursor.fetchall()
            combinedExists = combinedExistsTuple[0][0]
            if combinedExists is None:
                combinedFilesLoaded += 1
                if combined_log >= 2:
                    print('Loading Combined Access Logs - ' + combinedFile )
                combinedDataLoaded = 1
                combinedLoadCreated = ctime(path.getctime(combinedFile))
                combinedLoadModified = ctime(path.getmtime(combinedFile))
                combinedLoadSize = str(path.getsize(combinedFile))
                combinedInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  combinedLoadFile + 
                                  "', '" + combinedLoadSize + 
                                  "', '"  + combinedLoadCreated + 
                                  "', '"  + combinedLoadModified + 
                                  "', '"  + str(importDeviceID) + 
                                  "', '"  + str(importLoadID) + 
                                  "', '2' );")
                try:
                    combinedInsertCursor.execute( combinedInsertSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileID(combined_log) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Function apache_logs.importFileID(combined_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                combinedInsertTupleID = combinedInsertCursor.fetchall()
                combinedInsertFileID = combinedInsertTupleID[0][0]
                if combined_server and combined_serverport:
                  combinedLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(combinedInsertFileID) + ", server_name='" + combined_server + "', server_port=" + str(combined_serverport)
                elif combined_server:
                  combinedLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(combinedInsertFileID) + ", server_name='" + combined_server + "'"
                else:
                  combinedLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(combinedInsertFileID)
                try:
                    combinedLoadCursor.execute( combinedLoadSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_combined failed')
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_access_combined",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
            elif backup_days != 0:
               copy_backup_file(combinedFile, combinedExists)
        if combined_process >= 1 and combinedDataLoaded == 1:
            combinedParseCalled += 1
            if combined_log >= 1:
                print('*','Started Parsing Combined Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4))
            try:
                combinedLoadCursor.callproc("process_access_parse",["combined",str(importLoadID)])
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_parse(combined) failed')
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure process_access_parse(combined)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if combined_log >= 1:
                print('*','Completed Parsing Combined Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4))
            if combined_process >= 2:
                combinedImportCalled += 1
                if combined_log >= 1:
                    print('*','*','Started Importing Combined Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4))
                combinedProcedureCursor = conn.cursor()
                try:
                    combinedProcedureCursor.callproc("process_access_import",["combined",str(importLoadID)])
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_import(combined) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Stored Procedure process_access_import(combined)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                combinedProcedureCursor.close()
                if combined_log >= 1:
                    print('*','*','Completed Importing Combined Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4))
        if combined_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed Combined Access Logs processing. Loaded '+ str(combinedFilesFound) + ' files - %s seconds' % round((time() - start_time),4) + style.END)
        combinedInsertCursor.close()
        combinedLoadCursor.close()
        combinedExistsCursor.close()
    if vhost == 1:
        if vhost_log >= 1:
            print(fg.HEADER + style.NORMAL + "Starting Vhost Access Logs processing - %s seconds" % round((time() - start_time),4) + style.END)
        vhostExistsCursor = conn.cursor()
        vhostInsertCursor = conn.cursor()
        vhostLoadCursor = conn.cursor()
        for vhostFile in glob(vhost_path, recursive=vhost_recursive):
            vhostFilesFound += 1
            vhostLoadFile = vhostFile.replace(sep, sep+sep)
            vhostExistsSQL = "SELECT apache_logs.importFileExists('" + vhostLoadFile + "', '"  + str(importDeviceID) + "');"
            try:
                vhostExistsCursor.execute( vhostExistsSQL )
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileExists(vhost_log) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Function apache_logs.importFileExists(vhost_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            vhostExistsTuple = vhostExistsCursor.fetchall()
            vhostExists = vhostExistsTuple[0][0]
            if vhostExists is None:
                vhostFilesLoaded += 1
                if vhost_log >= 2:
                    print('Loading Vhost Access Log - ' + vhostFile)
                vhostDataLoaded = 1
                vhostLoadCreated = ctime(path.getctime(vhostFile))
                vhostLoadModified = ctime(path.getmtime(vhostFile))
                vhostLoadSize = str(path.getsize(vhostFile))
                vhostInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  vhostLoadFile + 
                                  "', '" + vhostLoadSize + 
                                  "', '"  + vhostLoadCreated + 
                                  "', '"  + vhostLoadModified + 
                                  "', '"  + str(importDeviceID) + 
                                  "', '"  + str(importLoadID) + 
                                  "', '3' );")
                try:
                    vhostInsertCursor.execute( vhostInsertSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileID(vhost_log) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Function apache_logs.importFileID(vhost_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                vhostInsertTupleID = vhostInsertCursor.fetchall()
                vhostInsertFileID = vhostInsertTupleID[0][0]
                vhostLoadSQL = "LOAD DATA LOCAL INFILE '" + vhostLoadFile + "' INTO TABLE load_access_vhost FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(vhostInsertFileID)
                try:
                    vhostLoadCursor.execute( vhostLoadSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_vhost failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_access_vhost",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
            elif backup_days != 0:
               copy_backup_file(vhostFile, vhostExists)
        if vhost_process >= 1 and vhostDataLoaded == 1:
            vhostParseCalled += 1
            if vhost_log >= 1:
                print('*','Started Parsing Vhost Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
            try:
                vhostLoadCursor.callproc("process_access_parse",["vhost",str(importLoadID)])
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_parse(vhost) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure process_access_parse(vhost)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if vhost_log >= 1:
                print('*','Completed Parsing Vhost Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
            # Processing loaded data
            if vhost_process >= 2:
                vhostImportCalled += 1
                if vhost_log >= 1:
                    print('*','*','Started Importing Vhost Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
                vhostProcedureCursor = conn.cursor()
                try:
                    vhostProcedureCursor.callproc("process_access_import",["vhost",str(importLoadID)])
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_import(vhost) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Stored Procedure process_access_import(vhost)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                vhostProcedureCursor.close()
                if vhost_log >= 1:
                    print('*','*','Completed Importing Vhost Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
        if vhost_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed Vhost Access Logs processing. Loaded '+ str(vhostFilesLoaded) + ' files - %s seconds' % round((time() - start_time),4) + style.END)
        vhostInsertCursor.close()
        vhostLoadCursor.close()
        vhostExistsCursor.close()
    if csv2mysql == 1:
        if csv2mysql_log >= 1:
            print(fg.HEADER + style.NORMAL + "Starting Csv2mysql Access Logs processing - %s seconds" % round((time() - start_time),4) + style.END)
        csv2mysqlExistsCursor = conn.cursor()
        csv2mysqlInsertCursor = conn.cursor()
        csv2mysqlLoadCursor = conn.cursor()
        for csv2mysqlFile in glob(csv2mysql_path, recursive=csv2mysql_recursive):
            csv2mysqlFilesFound += 1
            csv2mysqlLoadFile = csv2mysqlFile.replace(sep, sep+sep)
            csv2mysqlExistsSQL = "SELECT apache_logs.importFileExists('" + csv2mysqlLoadFile + "', '"  + str(importDeviceID) + "');"
            try:
                csv2mysqlExistsCursor.execute( csv2mysqlExistsSQL )
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileExists(csv2mysql_log) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Function apache_logs.importFileExists(csv2mysql_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            csv2mysqlExistsTuple = csv2mysqlExistsCursor.fetchall()
            csv2mysqlExists = csv2mysqlExistsTuple[0][0]
            if csv2mysqlExists is None:
                csv2mysqlFilesLoaded += 1
                if csv2mysql_log >= 2:
                    print('Loading Csv2mysql Access Log - ' + csv2mysqlFile )
                csv2mysqlDataLoaded = 1
                csv2mysqlLoadCreated = ctime(path.getctime(csv2mysqlFile))
                csv2mysqlLoadModified = ctime(path.getmtime(csv2mysqlFile))
                csv2mysqlLoadSize = str(path.getsize(csv2mysqlFile))
                csv2mysqlInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  csv2mysqlLoadFile + 
                                  "', '" + csv2mysqlLoadSize + 
                                  "', '"  + csv2mysqlLoadCreated + 
                                  "', '"  + csv2mysqlLoadModified + 
                                  "', '"  + str(importDeviceID) + 
                                  "', '"  + str(importLoadID) + 
                                  "', '4' );")
                try:
                    csv2mysqlInsertCursor.execute( csv2mysqlInsertSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Function apache_logs.importFileID(csv2mysql_log) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Function apache_logs.importFileID(csv2mysql_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                csv2mysqlInsertTupleID = csv2mysqlInsertCursor.fetchall()
                csv2mysqlInsertFileID = csv2mysqlInsertTupleID[0][0]
                csv2mysqlLoadSQL = "LOAD DATA LOCAL INFILE '" + csv2mysqlLoadFile + "' INTO TABLE load_access_csv2mysql FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(csv2mysqlInsertFileID)
                try:
                    csv2mysqlLoadCursor.execute( csv2mysqlLoadSQL )
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_csv2mysql failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_access_csv2mysql",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
            elif backup_days != 0:
                copy_backup_file(csv2mysqlFile, csv2mysqlExists)
        if csv2mysql_process >= 1 and csv2mysqlDataLoaded == 1:
            csv2mysqlParseCalled += 1
            if csv2mysql_log >= 1:
                print('*','Started Parsing Csv2mysql Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
            try:
                csv2mysqlLoadCursor.callproc("process_access_parse",["csv2mysql",str(importLoadID)])
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_parse(csv2mysql) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure process_access_parse(csv2mysql)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if csv2mysql_log >= 1:
                print('*','Completed Parsing Csv2mysql Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
            # Processing loaded data
            if csv2mysql_process >= 2:
                csv2mysqlImportCalled += 1
                if csv2mysql_log >= 1:
                    print('*','*','Started Importing Csv2mysql Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
                csv2mysqlProcedureCursor = conn.cursor()
                try:
                    csv2mysqlProcedureCursor.callproc("process_access_import",["csv2mysql",str(importLoadID)])
                except:
                    processError += 1
                    print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure process_access_import(csv2mysql) failed' + style.END)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Stored Procedure process_access_import(csv2mysql)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                csv2mysqlProcedureCursor.close()
                if csv2mysql_log >= 1:
                    print('*','*','Completed Importing Csv2mysql Access Logs Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
        if csv2mysql_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed Csv2mysql Access Logs processing. Loaded '+ str(csv2mysqlFilesLoaded) + ' files - %s seconds' % round((time() - start_time),4) + style.END)
        csv2mysqlExistsCursor.close()
        csv2mysqlInsertCursor.close()
        csv2mysqlLoadCursor.close()
    # SECONDARY PROCESSES BELOW: Client Module UPLOAD is done with load, parse and import processes of access and error logs. The below processes enhance User Agent and Client IP log data.
    # Initially UserAgent and GeoIP2 processes were each in separate files. After much design consideration and application experience and Code Redundancy being problematic
    # the decision was made to encapsulate all processes within the same "Import Load" which captures and logs all execution metrics, notifications and errors
    # into MySQL tables for each execution. Every log data record can be tracked back to the file, folder, computer, load process, parse process and import process it came from.  
    # Processes may require individual execution even when NONE of above processes are executed. If this Module is run automatically on a client server to upload Apache Logs to centralized 
    # MySQL Server the processes below will never be executed. In some cases, only the processes below are needed for execution on MySQL Server or another centralized computer.
    # In some cases, ALL processes above and below will be executed in a single "Import Load" execution. Therefore, the encapsulation of all processes in a single module.
    if useragent == 1:
        if useragent_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting User Agent Information Parsing Process. Checking access_log_useragent TABLE for records to parse - %s seconds' % round((time() - start_time),4) + style.END)
        selectUserAgentCursor = conn.cursor()
        updateUserAgentCursor = conn.cursor()
        try:
            selectUserAgentCursor.execute("SELECT id, name FROM access_log_useragent WHERE ua_browser IS NULL")
        except:
            processError += 1
            print(bg.RED + style.BRIGHT + 'ERROR - SELECT id, name FROM access_log_useragent WHERE ua_browser IS NULL failed' + style.END)
            showWarnings = conn.show_warnings()
            print(showWarnings)
            importClientCursor.callproc("errorLoad",["SELECT id, name FROM access_log_useragent WHERE ua_browser",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        for x in range(selectUserAgentCursor.rowcount):
            userAgentRecordsParsed += 1
            userAgent = selectUserAgentCursor.fetchone()
            recID = str(userAgent[0])
            ua = parse(userAgent[1])
            if useragent_log >= 2:
                print(fg.CYAN + style.DIM + 'Parsing information - User Agent: ' + str(ua) + ' - record: ' + str(recID) + style.END)
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
                importClientCursor.callproc("errorLoad",["UPDATE access_log_useragent SET Statement",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        conn.commit()
        selectUserAgentCursor.close()
        updateUserAgentCursor.close()        
        if useragent_process >= 1 and userAgentRecordsParsed > 0:
            if useragent_log >= 1:
                print('*','*','Started Normalizing User Agent data Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
            normalizeUserAgentCursor = conn.cursor()
            try:
                normalizeUserAgentCursor.callproc("normalize_useragent",["Python Processed",str(importLoadID)])
                userAgentNormalizeCalled = 1
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure normalize_useragent(Python Processed) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure normalize_useragent(Python Processed)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            normalizeUserAgentCursor.close()
            if useragent_log >= 1:
                print('*','*','Completed Normalizing User Agent data Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
        if useragent_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed User Agent data processing. Parsed ' + str(userAgentRecordsParsed) + ' records - %s seconds' % round((time() - start_time),4) + style.END)
    geoip2_city_file_exists = True
    geoip2_asn_file_exists = True
    if geoip2 == 1:
        geoip2_city_file = geoip2_city.replace(sep, sep+sep)
        geoip2_asn_file = geoip2_asn.replace(sep, sep+sep)
        if not path.exists(geoip2_city_file):
            processError += 1
            geoip2_city_file_exists = False
            print(bg.RED + style.BRIGHT, 'ERROR - IP geolocation CITY database: ' + geoip2_city_file + ' not found.' + style.END)
            importClientCursor.callproc("errorLoad",["IP geolocation CITY database not found",'1234',geoip2_city_file,str(importLoadID)])
        if not path.exists(geoip2_asn_file):
            processError += 1
            geoip2_asn_file_exists = False
            print(bg.RED + style.BRIGHT, 'ERROR - IP geolocation ASN database: ' + geoip2_asn_file + ' not found.' + style.END)
            importClientCursor.callproc("errorLoad",["IP geolocation ASN database not found",'1234',geoip2_asn_file,str(importLoadID)])
    if geoip2 == 1 and geoip2_city_file_exists and geoip2_asn_file_exists:
        if geoip2_log >= 1:
            print(fg.HEADER + style.NORMAL + 'Starting IP Address Information Retrieval process. Checking log_client TABLE for records to update - %s seconds' % round((time() - start_time),4) + style.END)
        selectGeoIP2Cursor = conn.cursor()
        updateGeoIP2Cursor = conn.cursor()
        try:
            selectGeoIP2Cursor.execute("SELECT id, name FROM log_client WHERE country_code IS NULL")
        except:
            processError += 1
            print(bg.RED + style.BRIGHT + 'ERROR - SELECT id, name FROM log_client WHERE ua_browser IS NULL failed' + style.END)
            showWarnings = conn.show_warnings()
            print(showWarnings)
            importClientCursor.callproc("errorLoad",["SELECT id, name FROM log_client WHERE country_code IS NULL",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        try:
            cityReader = database.Reader(geoip2_city_file)
        except Exception as e:
            processError += 1
            print(bg.RED + style.BRIGHT + 'ERROR - cityReader = geoip2.database.Reader failed' + style.END, e)
            importClientCursor.callproc("errorLoad",["cityReader = geoip2.database.Reader failed", '1111', e, str(importLoadID)])
        try:
            asnReader = database.Reader(geoip2_asn_file)
        except Exception as e:
            processError += 1
            print(bg.RED + style.BRIGHT + 'ERROR - cityReader = geoip2.database.Reader failed' + style.END, e)
            importClientCursor.callproc("errorLoad",["cityReader = geoip2.database.Reader failed", '1111', e, str(importLoadID)])
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
                print(fg.CYAN + style.DIM + 'Retrieving information - IP Address: ' + ipAddress + ' - record: ' + str(recID) + style.END)
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
                importClientCursor.callproc("errorLoad",["cityReader.city() failed", '1234', ipAddress, str(importLoadID)])
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
                importClientCursor.callproc("errorLoad",["asnReader.asn() failed", '1234', ipAddress, str(importLoadID)])
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
              importClientCursor.callproc("errorLoad",["UPDATE log_client SET Statement",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        conn.commit()
        selectGeoIP2Cursor.close()
        updateGeoIP2Cursor.close()        
        if geoip2_process >= 1 and ipAddressRecordsParsed > 0:
            if geoip2_log >= 1:
                print('*','*','Started Normalizing IP Address data Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
            normalizeGeoIP2Cursor = conn.cursor()
            try:
                normalizeGeoIP2Cursor.callproc("normalize_client",["Python Processed",str(importLoadID)])
                ipAddressNormalizeCalled = 1
            except:
                processError += 1
                print(bg.RED + style.BRIGHT + 'ERROR - Stored Procedure normalize_client(Python Processed) failed' + style.END)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure normalize_client(Python Processed)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            normalizeGeoIP2Cursor.close()
            if geoip2_log >= 1:
                print('*','*','Completed Normalizing IP Address data Stored Procedure - %s seconds' % round((time() - start_time),4) + style.END)
        if geoip2_log >= 1:
            print(fg.MAGENTA + style.DIM + 'Completed IP Address data processing. Updated '+ str(ipAddressRecordsParsed) + ' records - %s seconds' % round((time() - start_time),4) + style.END, end='\n\n')
    processSeconds = round(time() - start_time, 4)
    loadUpdateSQL = ('UPDATE import_load SET errorFilesFound=' + str(errorFilesFound) + 
                  ', errorFilesLoaded=' + str(errorFilesLoaded) + 
                  ', errorParseCalled=' + str(errorParseCalled) + 
                  ', errorImportCalled=' + str(errorImportCalled) + 
                  ', combinedFilesFound=' + str(combinedFilesFound) + 
                  ', combinedFilesLoaded=' + str(combinedFilesLoaded) + 
                  ', combinedParseCalled=' + str(combinedParseCalled) + 
                  ', combinedImportCalled=' + str(combinedImportCalled) + 
                  ', vhostFilesFound=' + str(vhostFilesFound) + 
                  ', vhostFilesLoaded=' + str(vhostFilesLoaded) + 
                  ', vhostParseCalled=' + str(vhostParseCalled) + 
                  ', vhostImportCalled=' + str(vhostImportCalled) + 
                  ', csv2mysqlFilesFound=' + str(csv2mysqlFilesFound) + 
                  ', csv2mysqlFilesLoaded=' + str(csv2mysqlFilesLoaded) + 
                  ', csv2mysqlParseCalled=' + str(csv2mysqlParseCalled) + 
                  ', csv2mysqlImportCalled=' + str(csv2mysqlImportCalled) + 
                  ', userAgentRecordsParsed=' + str(userAgentRecordsParsed) + 
                  ', userAgentNormalizeCalled=' + str(userAgentNormalizeCalled) + 
                  ', ipAddressRecordsParsed=' + str(ipAddressRecordsParsed) + 
                  ', ipAddressNormalizeCalled=' + str(ipAddressNormalizeCalled) + 
                  ', errorOccurred=' + str(processError) + 
                  ', completed=now()' + 
                  ', processSeconds=' + str(processSeconds) + ' WHERE id=' + str(importLoadID) +';')
    importLoadCursor = conn.cursor()
    try:
        importLoadCursor.execute(loadUpdateSQL)
    except:
        processError += 1
        print(bg.RED + style.BRIGHT + 'ERROR - UPDATE import_load SET Statement failed' + style.END)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importClientCursor.callproc("errorLoad",["UPDATE import_load SET Statement",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    conn.commit()
    importLoadCursor.close()
    importClientCursor.close()
    conn.close()
    print(fg.GREEN + style.BRIGHT + 'Apache Log File Counts and Process Metrics for ImportLoadID:' + str(importLoadID) + ' | ClientID:' + str(importClientID) + ' | DeviceID:' + str(importDeviceID) + style.END, end='\n')
    log_headers = ["Log Formats", "Files Found", "Files Loaded", "Records Parsed", "Records Imported"]
    log_processes = [ 
    ["Error Logs", errorFilesFound, errorFilesLoaded, bool(errorParseCalled), bool(errorImportCalled)], 
    ["Combined Access",combinedFilesFound, combinedFilesLoaded, bool(combinedParseCalled), bool(combinedImportCalled)], 
    ["Vhost Access", vhostFilesFound, vhostFilesLoaded, bool(vhostParseCalled), bool(vhostImportCalled)], 
    ["Csv2mysql Access", csv2mysqlFilesFound, csv2mysqlFilesLoaded, bool(csv2mysqlParseCalled), bool(csv2mysqlImportCalled)] 
    ]
    # Print table headers
    print("Process".ljust(10), end = "")
    for col in log_headers:
        print(col.ljust(20), end="")
    print()
    # Print table rows
    for i, row in enumerate(log_processes, start = 1):
        print(str(i).ljust(10), end = "")                      
        for col in row:
            print(str(col).ljust(20), end = "")
        print()
    print(fg.LIGHT_GREEN + style.NORMAL + 'Each Import Load execution inserts record into apache_logs.import_file TABLE storing values.' + style.END, end='\n\n')
    print(fg.GREEN + style.BRIGHT + 'Summary of Apache Log Data Enhancement and Process Metrics' + style.END, end='\n')
    data_headers = ["Enhancement", "Records Processed", "Data Normalized"]
    data_enhancements = [ 
    ["User Agent data", userAgentRecordsParsed, bool(userAgentNormalizeCalled)], 
    ["IP Address data", ipAddressRecordsParsed, bool(ipAddressNormalizeCalled)] 
    ]
    # Print table headers
    print("Process".ljust(10), end = "")
    for col in data_headers:
        print(col.ljust(20), end="")
    print()
    # Print table rows
    for i, row in enumerate(data_enhancements, start = 1):
        print(str(i).ljust(10), end = "")                      
        for col in row:
            print(str(col).ljust(20), end = "")
        print()
    print(fg.LIGHT_GREEN + style.NORMAL + 'Each Import Load execution inserts record into apache_logs.import_file TABLE storing values.' + style.END, end='\n\n')
    print(fg.YELLOW + style.BRIGHT + 'ProcessLogs complete: ' + str(datetime.now()) + ' - %s seconds' % round((time() - start_time),4) + style.END)
if __name__ == "__main__":
    print("logs2mysql.py run directly")
    processLogs()
