# coding: utf-8
# version 2.0.0 - 11/30/2024 - Comprehensive Update
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
# CHANGELOG.md in GitHub repository - https://github.com/WillTheFarmer/ApacheLogs2MySQL
"""
:module: apacheLogs2MySQL
:function: processLogs()
:synopsis: processes apache access and error logs into MySQL for apachelogs2MySQL application.
:author: farmfreshsoftware@gmail.com (Will Raymond)
"""
import os
import platform
import socket
import pymysql
import glob
from dotenv import load_dotenv
from user_agents import parse
import time
import datetime
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
errorlog_servername = '' # os.getenv('ERROR_SERVERNAME')
errorlog_serverport = '' # int(os.getenv('ERROR_SERVERPORT'))
combined = int(os.getenv('COMBINED'))
combined_path = os.getenv('COMBINED_PATH')
combined_recursive = bool(int(os.getenv('COMBINED_RECURSIVE')))
combined_log = int(os.getenv('COMBINED_LOG'))
combined_process = int(os.getenv('COMBINED_PROCESS'))
combined_servername = '' # os.getenv('COMBINED_SERVERNAME')
combined_serverport = '' # int(os.getenv('COMBINED_SERVERPORT'))
vhost = int(os.getenv('VHOST'))
vhost_path = os.getenv('VHOST_PATH')
vhost_recursive = bool(int(os.getenv('VHOST_RECURSIVE')))
vhost_log = int(os.getenv('VHOST_LOG'))
vhost_process = int(os.getenv('VHOST_PROCESS'))
csv2mysql = int(os.getenv('CSV2MYSQL'))
csv2mysql_path = os.getenv('CSV2MYSQL_PATH')
csv2mysql_recursive = bool(int(os.getenv('CSV2MYSQL_RECURSIVE')))
csv2mysql_log = int(os.getenv('CSV2MYSQL_LOG'))
csv2mysql_process = int(os.getenv('CSV2MYSQL_PROCESS'))
useragent = int(os.getenv('USERAGENT'))
useragent_log = int(os.getenv('USERAGENT_LOG'))
useragent_process = int(os.getenv('USERAGENT_PROCESS'))
# make error messages noticeable in console - all error messages start with 'ERROR - ' for keyword log search
class bcolors:
    ERROR = '\33[41m' # CREDBG - red background
    ENDC = '\033[0m'
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
    processError = 0
    start_time = time.time()
    print("ProcessLogs start: " + str(datetime.datetime.now()))
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
        processError += 1
        print(bcolors.ERROR + "ERROR - Function apache_logs.importClientID() failed" + bcolors.ENDC)
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
        print(bcolors.ERROR + "ERROR - Function apache_logs.importLoadID(importClientID) failed" + bcolors.ENDC)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importClientCursor.callproc("errorLoad",["Function apache_logs.importLoadID(importClientID)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    importLoadTupleID = importLoadCursor.fetchall()
    importLoadID = importLoadTupleID[0][0]
    errorDataLoaded = 0
    errorFileCount = 0
    errorFileLoaded = 0
    errorFileParsed = 0
    errorFileProcessed = 0
    combinedDataLoaded = 0
    combinedFileCount = 0
    combinedFileLoaded = 0
    combinedFileParsed = 0
    combinedFileProcessed = 0
    vhostDataLoaded = 0
    vhostFileCount = 0
    vhostFileLoaded = 0
    vhostFileParsed = 0
    vhostFileProcessed = 0
    csv2mysqlDataLoaded = 0
    csv2mysqlFileCount = 0
    csv2mysqlFileLoaded = 0
    csv2mysqlFileParsed = 0
    csv2mysqlFileProcessed = 0
    useragentFileProcessed = 0 
    if errorlog == 1:
        if errorlog_log >= 1:
            print('Checking for Error Logs to Import - %s seconds' % (time.time() - start_time))
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
                processError += 1
                print(bcolors.ERROR + "ERROR - Function apache_logs.importFileExists(error_log) failed" + bcolors.ENDC)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Function apache_logs.importFileExists(error_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
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
                errorInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  errorLoadFile + 
                                  "', '" + errorLoadSize + 
                                  "', '"  + errorLoadCreated + 
                                  "', '"  + errorLoadModified + 
                                  "', '"  + str(importLoadID) + "' );")
                try:
                    errorInsertCursor.execute( errorInsertSQL )
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - Function apache_logs.importFileID(error_log) failed" + bcolors.ENDC)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Function apache_logs.importFileID(error_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                errorInsertTupleID = errorInsertCursor.fetchall()
                errorInsertFileID = errorInsertTupleID[0][0]
                if errorlog_servername and errorlog_serverport:
                  errorLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(errorInsertFileID) + ", server_name='" + errorlog_servername + "', server_port=" + str(errorlog_serverport)
                elif errorlog_servername:
                  errorLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(errorInsertFileID) + ", server_name='" + errorlog_servername + "'"
                else:
                  errorLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE load_error_default FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(errorInsertFileID)
                try:
                    errorLoadCursor.execute( errorLoadSQL )
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_error_default failed" + bcolors.ENDC)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_error_default",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
        if errorlog_process >= 1 and errorDataLoaded == 1:
            errorFileParsed += 1
            if errorlog_log >= 1:
                print('Parsing Error Logs - %s seconds' % (time.time() - start_time))
            try:
               errorLoadCursor.callproc("process_error_parse",["default",str(importLoadID)])
            except:
                processError += 1
                print(bcolors.ERROR + "ERROR - Stored Procedure process_error_parse(default) failed" + bcolors.ENDC)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure process_error_parse(default)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if errorlog_log >= 1:
                print('Parsing Error Logs complete - %s seconds' % (time.time() - start_time))
            # Processing loaded data
            if errorlog_process >= 2:
                errorFileProcessed += 1
                if errorlog_log >= 1:
                    print('Importing Error Logs - %s seconds' % (time.time() - start_time))
                errorProcedureCursor = conn.cursor()
                try:
                    errorProcedureCursor.callproc("process_error_import",["default",str(importLoadID)])
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - Stored Procedure process_error_import(default) failed" + bcolors.ENDC)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Stored Procedure process_error_import(default)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                errorProcedureCursor.close()
                if errorlog_log >= 1:
                    print('Importing Error Logs complete - %s seconds' % (time.time() - start_time))
        errorInsertCursor.close()
        errorLoadCursor.close()
        errorExistsCursor.close()
    if combined == 1:
        # starting load and process of access logs - combined and common
        if combined_log >= 1:
            print('Checking for Combined Access Log to Import - %s seconds' % (time.time() - start_time))
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
                processError += 1
                print(bcolors.ERROR + "ERROR - Function apache_logs.importFileExists(combined_log) failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Function apache_logs.importFileExists(combined_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
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
                combinedInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  combinedLoadFile + 
                                  "', '" + combinedLoadSize + 
                                  "', '"  + combinedLoadCreated + 
                                  "', '"  + combinedLoadModified + 
                                  "', '"  + str(importLoadID) + "' );")
                try:
                    combinedInsertCursor.execute( combinedInsertSQL )
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - Function apache_logs.importFileID(combined_log) failed" + bcolors.ENDC)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Function apache_logs.importFileID(combined_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                combinedInsertTupleID = combinedInsertCursor.fetchall()
                combinedInsertFileID = combinedInsertTupleID[0][0]
                if combined_servername and combined_serverport:
                  combinedLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(combinedInsertFileID) + ", server_name='" + combined_servername + "', server_port=" + str(combined_serverport)
                elif combined_servername:
                  combinedLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(combinedInsertFileID) + ", server_name='" + combined_servername + "'"
                else:
                  combinedLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(combinedInsertFileID)
                try:
                    combinedLoadCursor.execute( combinedLoadSQL )
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_combined failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_access_combined",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
        if combined_process >= 1 and combinedDataLoaded == 1:
            combinedFileParsed += 1
            if combined_log >= 1:
                print('Parsing Combined Access Logs - %s seconds' % (time.time() - start_time))
            try:
                combinedLoadCursor.callproc("process_access_parse",["combined",str(importLoadID)])
            except:
                processError += 1
                print(bcolors.ERROR + "ERROR - Stored Procedure process_access_parse(combined) failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure process_access_parse(combined)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if combined_log >= 1:
                print('Parsing Combined Access Logs complete - %s seconds' % (time.time() - start_time))
            # Processing loaded data
            if combined_process >= 2:
                combinedFileProcessed += 1
                if combined_log >= 1:
                    print('Importing Combined Access Logs - %s seconds' % (time.time() - start_time))
                combinedProcedureCursor = conn.cursor()
                try:
                    combinedProcedureCursor.callproc("process_access_import",["combined",str(importLoadID)])
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - Stored Procedure process_access_import(combined) failed" + bcolors.ENDC)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Stored Procedure process_access_import(combined)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                combinedProcedureCursor.close()
                if combined_log >= 1:
                    print('Importing Combined Access Logs import complete - %s seconds' % (time.time() - start_time))
        combinedInsertCursor.close()
        combinedLoadCursor.close()
        combinedExistsCursor.close()
    if vhost == 1:
        # starting load and process of access logs - combined
        if vhost_log >= 1:
            print('Checking for vHost Access Logs to Import - %s seconds' % (time.time() - start_time))
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
                processError += 1
                print(bcolors.ERROR + "ERROR - Function apache_logs.importFileExists(vhost_log) failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Function apache_logs.importFileExists(vhost_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            vhostExistsTuple = vhostExistsCursor.fetchall()
            vhostExists = vhostExistsTuple[0][0]
            if vhostExists == 0:
                vhostFileLoaded += 1
                if vhost_log >= 2:
                    print('Loading Vhost Access Log - ' + vhostFile)
                vhostDataLoaded = 1
                vhostLoadCreated = time.ctime(os.path.getctime(vhostFile))
                vhostLoadModified = time.ctime(os.path.getmtime(vhostFile))
                vhostLoadSize     = str(os.path.getsize(vhostFile))
                vhostInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  vhostLoadFile + 
                                  "', '" + vhostLoadSize + 
                                  "', '"  + vhostLoadCreated + 
                                  "', '"  + vhostLoadModified + 
                                  "', '"  + str(importLoadID) + "' );")
                try:
                    vhostInsertCursor.execute( vhostInsertSQL )
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - Function apache_logs.importFileID(vhost_log) failed" + bcolors.ENDC)
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
                    print(bcolors.ERROR + "ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_vhost failed" + bcolors.ENDC)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_access_vhost",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
        if vhost_process >= 1 and vhostDataLoaded == 1:
            vhostFileParsed += 1
            if vhost_log >= 1:
                print('Parsing Vhost Access Logs - %s seconds' % (time.time() - start_time))
            try:
                vhostLoadCursor.callproc("process_access_parse",["vhost",str(importLoadID)])
            except:
                processError += 1
                print(bcolors.ERROR + "ERROR - Stored Procedure process_access_parse(vhost) failed" + bcolors.ENDC)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure process_access_parse(vhost)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if vhost_log >= 1:
                print('Parsing Vhost Access Logs complete - %s seconds' % (time.time() - start_time))
            # Processing loaded data
            if vhost_process >= 2:
                vhostFileProcessed += 1
                if vhost_log >= 1:
                    print('Importing Vhost Access Logs - %s seconds' % (time.time() - start_time))
                vhostProcedureCursor = conn.cursor()
                try:
                    vhostProcedureCursor.callproc("process_access_import",["vhost",str(importLoadID)])
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - Stored Procedure process_access_import(vhost) failed" + bcolors.ENDC)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Stored Procedure process_access_import(vhost)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                vhostProcedureCursor.close()
                if vhost_log >= 1:
                    print('Importing Vhost Access Logs complete - %s seconds' % (time.time() - start_time))
        vhostInsertCursor.close()
        vhostLoadCursor.close()
        vhostExistsCursor.close()
    if csv2mysql == 1:
        # starting load and process of access logs - csv2mysql
        if csv2mysql_log >= 1:
            print('Checking for Csv2mysql Access Logs to Import - %s seconds' % (time.time() - start_time))
        csv2mysqlExistsCursor = conn.cursor()
        csv2mysqlInsertCursor = conn.cursor()
        csv2mysqlLoadCursor = conn.cursor()
        for csv2mysqlFile in glob.glob(csv2mysql_path, recursive=csv2mysql_recursive):
            csv2mysqlFileCount += 1
            csv2mysqlLoadFile = csv2mysqlFile.replace(os.sep, os.sep+os.sep)
            csv2mysqlExistsSQL = "SELECT apache_logs.importFileExists('" + csv2mysqlLoadFile + "');"
            try:
                csv2mysqlExistsCursor.execute( csv2mysqlExistsSQL )
            except:
                processError += 1
                print(bcolors.ERROR + "ERROR - Function apache_logs.importFileExists(csv2mysql_log) failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Function apache_logs.importFileExists(csv2mysql_log)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            csv2mysqlExistsTuple = csv2mysqlExistsCursor.fetchall()
            csv2mysqlExists = csv2mysqlExistsTuple[0][0]
            if csv2mysqlExists == 0:
                csv2mysqlFileLoaded += 1
                if csv2mysql_log >= 2:
                    print('Loading Csv2mysql Access Log - ' + csv2mysqlFile )
                csv2mysqlDataLoaded = 1
                csv2mysqlLoadCreated = time.ctime(os.path.getctime(csv2mysqlFile))
                csv2mysqlLoadModified = time.ctime(os.path.getmtime(csv2mysqlFile))
                csv2mysqlLoadSize     = str(os.path.getsize(csv2mysqlFile))
                csv2mysqlInsertSQL = ("SELECT apache_logs.importFileID('" + 
                                  csv2mysqlLoadFile + 
                                  "', '" + csv2mysqlLoadSize + 
                                  "', '"  + csv2mysqlLoadCreated + 
                                  "', '"  + csv2mysqlLoadModified + 
                                  "', '"  + str(importLoadID) + "' );")
                try:
                    csv2mysqlInsertCursor.execute( csv2mysqlInsertSQL )
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - Function apache_logs.importFileID(csv2mysql_log) failed" + bcolors.ENDC)
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
                    print(bcolors.ERROR + "ERROR - LOAD DATA LOCAL INFILE INTO TABLE load_access_csv2mysql failed")
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["LOAD DATA LOCAL INFILE INTO TABLE load_access_csv2mysql",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
        # Commit and close
        if csv2mysql_process >= 1 and csv2mysqlDataLoaded == 1:
            csv2mysqlFileParsed += 1
            if csv2mysql_log >= 1:
                print('Parsing Csv2mysql Access Logs - %s seconds' % (time.time() - start_time))
            try:
                csv2mysqlLoadCursor.callproc("process_access_parse",["csv2mysql",str(importLoadID)])
            except:
                processError += 1
                print(bcolors.ERROR + "ERROR - Stored Procedure process_access_parse(csv2mysql) failed")
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure process_access_parse(csv2mysql)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            conn.commit()
            if csv2mysql_log >= 1:
                print('Parsing Csv2mysql Access Logs complete - %s seconds' % (time.time() - start_time))
            # Processing loaded data
            if csv2mysql_process >= 2:
                csv2mysqlFileProcessed += 1
                if csv2mysql_log >= 1:
                    print('Importing Csv2mysql Access Logs - %s seconds' % (time.time() - start_time))
                csv2mysqlProcedureCursor = conn.cursor()
                try:
                    csv2mysqlProcedureCursor.callproc("process_access_import",["csv2mysql",str(importLoadID)])
                except:
                    processError += 1
                    print(bcolors.ERROR + "ERROR - Stored Procedure process_access_import(csv2mysql) failed" + bcolors.ENDC)
                    showWarnings = conn.show_warnings()
                    print(showWarnings)
                    importClientCursor.callproc("errorLoad",["Stored Procedure process_access_import(csv2mysql)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
                conn.commit()
                csv2mysqlProcedureCursor.close()
                if csv2mysql_log >= 1:
                    print('Importing Csv2mysql Access Logs complete - %s seconds' % (time.time() - start_time))
        csv2mysqlExistsCursor.close()
        csv2mysqlInsertCursor.close()
        csv2mysqlLoadCursor.close()
    # done with load and process of access and error logs
    # if any access logs were processed check to update useragent if any records added
    # if useragent == 1 and (combinedDataLoaded == 1 or vhostDataLoaded == 1 or csv2mysqlDataLoaded ==1):
    if useragent == 1:
        if useragent_log >= 1:
            print('Checking for access_log_useragent data parsing to process - %s seconds' % (time.time() - start_time))
        selectUserAgentCursor = conn.cursor()
        updateUserAgentCursor = conn.cursor()
        try:
            selectUserAgentCursor.execute("SELECT id, name FROM access_log_useragent WHERE ua_browser IS NULL")
        except:
            processError += 1
            print(bcolors.ERROR + "ERROR - SELECT id, name FROM access_log_useragent WHERE ua_browser IS NULL failed" + bcolors.ENDC)
            showWarnings = conn.show_warnings()
            print(showWarnings)
            importClientCursor.callproc("errorLoad",["SELECT id, name FROM access_log_useragent WHERE ua_browser",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
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
                processError += 1
                print(bcolors.ERROR + "ERROR - UPDATE access_log_useragent SET Statement failed" + bcolors.ENDC)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["UPDATE access_log_useragent SET Statement",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
        conn.commit()
        selectUserAgentCursor.close()
        updateUserAgentCursor.close()        
        if useragent_log >= 1:
            print('Useragent data parsing complete - %s seconds' % (time.time() - start_time))
        if useragent_process == 1:
            if useragent_log >= 1:
                print('Normalizing UserAgent data to seperate tables - %s seconds' % (time.time() - start_time))
            normalizeCursor = conn.cursor()
            try:
                normalizeCursor.callproc("normalize_useragent",["Python Processed",str(importLoadID)])
            except:
                processError += 1
                print(bcolors.ERROR + "ERROR - Stored Procedure normalize_useragent(Python Processed) failed" + bcolors.ENDC)
                showWarnings = conn.show_warnings()
                print(showWarnings)
                importClientCursor.callproc("errorLoad",["Stored Procedure normalize_useragent(Python Processed)",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
            normalizeCursor.close()
            if useragent_log >= 1:
                print('Normalizing UserAgent data complete - %s seconds' % (time.time() - start_time))
    processSeconds = round(time.time() - start_time, 4)
    loadUpdateSQL = ('UPDATE import_load SET errorLogCount=' + str(errorFileCount) + 
                  ', errorLogLoaded=' + str(errorFileLoaded) + 
                  ', errorLogParsed=' + str(errorFileParsed) + 
                  ', errorLogProcessed=' + str(errorFileProcessed) + 
                  ', combinedLogCount=' + str(combinedFileCount) + 
                  ', combinedLogLoaded=' + str(combinedFileLoaded) + 
                  ', combinedLogParsed=' + str(combinedFileParsed) + 
                  ', combinedLogProcessed=' + str(combinedFileProcessed) + 
                  ', vhostLogCount=' + str(vhostFileCount) + 
                  ', vhostLogLoaded=' + str(vhostFileLoaded) + 
                  ', vhostLogParsed=' + str(vhostFileParsed) + 
                  ', vhostLogProcessed=' + str(vhostFileProcessed) + 
                  ', csv2mysqlLogCount=' + str(csv2mysqlFileCount) + 
                  ', csv2mysqlLogLoaded=' + str(csv2mysqlFileLoaded) + 
                  ', csv2mysqlLogParsed=' + str(csv2mysqlFileParsed) + 
                  ', csv2mysqlLogProcessed=' + str(csv2mysqlFileProcessed) + 
                  ', userAgentProcessed=' + str(useragentFileProcessed) + 
                  ', errorOccurred=' + str(processError) + 
                  ', processSeconds=' + str(processSeconds) + ' WHERE id=' + str(importLoadID) +';')
    importLoadCursor = conn.cursor()
    try:
        importLoadCursor.execute(loadUpdateSQL)
    except:
        processError += 1
        print(bcolors.ERROR + "ERROR - UPDATE import_load SET Statement failed" + bcolors.ENDC)
        showWarnings = conn.show_warnings()
        print(showWarnings)
        importClientCursor.callproc("errorLoad",["UPDATE import_load SET Statement",str(showWarnings[0][1]),showWarnings[0][2],str(importLoadID)])
    conn.commit()
    importLoadCursor.close()
    importClientCursor.close()
    conn.close()
    print('ProcessLogs complete: ' + str(datetime.datetime.now()) + ' - %s seconds' % (time.time() - start_time))
if __name__ == "__main__":
    # This will run if apacheLogs2MySQL.py is executed directly
    print("apacheLogs2MySQL.py is being run directly")
    processLogs()
