# Copyright 2024-2026 Will Raymond <farmfreshsoftware@gmail.com>
#
# Licensed under the http License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.http.org/licenses/LICENSE-2.0
#
# version 4.0.0 - 01/18/2026 - Proper Python code - converted Python script to application with factory method. - see changelog
#
# CHANGELOG.md in repository - https://github.com/WillTheFarmer/http-logs-to-mysql
"""
:module: datFileLoader.py
:function: process_file()
:synopsis: each file is processed here. This is where LOAD DATA is done.
:function: process()
:synopsis: loops through files in parameterized directory and calls process_file().
:author: Will Raymond <farmfreshsoftware@gmail.com>
"""
# application-level properties and references shared across app modules (files) 
from apis.app_settings import app
# process-level properties and references shared across process app functions (def) 
from apis.process_settings import properties_dataFileLoader as mod
# Color Class used app-wide for Message Readability in console
from apis.color_class import color
# used process execution time calculations and displays
from time import ctime
from time import perf_counter
from datetime import datetime

from os import path
from os import sep

from glob import glob

from src.apis.utilities import copy_backup_file

# global variable used by process_file() and process() methods
backup_days = 0
log_format = "none"
load_table = "none"
log_path = "."
log_recursive = False
display_log = 1
log_process = 1
log_server = "mydomain.com"
log_serverport = 443

fileCursor = None
loadCursor = None

# variables used for sumary of Import Load process - All import processes have the same variables.
filesFound = 0
filesProcessed = 0
recordsProcessed = 0
processErrors = 0
processSeconds = 0.000000
processStart = None
processStatus = None

print(f"The initializing of file name = {__name__} in directory = {__file__} this is at top of file.")

def process_report():
    process_data = {
      "Files Found": filesFound,
      "Files Loaded": filesProcessed,
      "Records Loaded": recordsProcessed,
      "Process Errors":  processErrors,
      "Process Seconds":  processSeconds,
      "Started":  processStart,
      "Status":  processStatus
    }
    return process_data

def process_file(rawFile):
    global filesFound
    global filesProcessed
    global recordsProcessed
    global processErrors
    global processSeconds
    global processStart
    global processStatus
    
    if '\\' in rawFile:
        loadFile = rawFile.replace(sep, sep+sep)
    else:
        loadFile = rawFile
    # MySQL function importFilesExists returns number of days since file was INSERTED into TABLE import_file. 
    # value used in combination with config.json backup_days and backup_path settings to trigger:
    #  1) COPY to backup directory and DELETE file from current directory. 2)just DELETE file or 3) do NOTHING
    days_since_importedSQL = "SELECT importFileExists('" + loadFile + "', '"  + str(app.importDeviceID) + "');"

    try:
        fileCursor.execute( days_since_importedSQL )
    except Exception as e:
        processErrors += 1
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - Function importFileExists() failed : {color.END}{e}")
        if app.error_details:
            print(f"Exception details: {e=}, {type(e)=}")        
        showWarnings = app.dbConnection.show_warnings()
        # print(showWarnings)
        loadCursor.callproc("errorLoad", 
                            ["Function importFileExists() error", 
                             str(showWarnings[0][1]), 
                             showWarnings[0][2],
                             str(app.importLoadID)])
    days_since_importedTuple = fileCursor.fetchall()
    days_since_imported = days_since_importedTuple[0][0]
    if days_since_imported is None:
        filesProcessed += 1
        if display_log >= 2:
            print(f"Loading log file | {rawFile}")
        fileInsertCreated = ctime(path.getctime(rawFile))
        fileInsertModified = ctime(path.getmtime(rawFile))
        fileInsertSize = str(path.getsize(rawFile))
        fileInsertSQL = ("SELECT importFileID('" + 
                        loadFile + 
                        "', '" + fileInsertSize + 
                        "', '"  + fileInsertCreated + 
                        "', '"  + fileInsertModified + 
                        "', '"  + str(app.importDeviceID) + 
                        "', '"  + str(app.importLoadID) + 
                        "', '5' );")
        try:
            fileCursor.execute( fileInsertSQL )
        except Exception as e:
            processErrors += 1
            print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - Function importFileID() failed : {color.END}{e}")
            if app.error_details:
                print(f"Exception details: {e=}, {type(e)=}")        
            showWarnings = app.dbConnection.show_warnings()
            # print(showWarnings)
            loadCursor.callproc("errorLoad",
                                ["Function importFileID() error",
                                 str(showWarnings[0][1]),
                                 showWarnings[0][2],
                                 str(app.importLoadID)])
        fileInsertTupleID = fileCursor.fetchall()
        fileInsertFileID = fileInsertTupleID[0][0]
        fileLoadSQL = ""
        if log_format=="apacheError":
            if log_server and log_serverport:
#                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_apache FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "', server_port=" + str(log_serverport)
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE " + load_table + " FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "', server_port=" + str(log_serverport)
            elif log_server:
#                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_apache FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "'"
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE " + load_table + " FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "'"
            else:
#                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_apache FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE " + load_table + " FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)
        elif log_format=="apacheCommon" or log_format=="apacheCombined":
            if log_server and log_serverport:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "', server_port=" + str(log_serverport)
            elif log_server:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "'"
            else:
              fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        elif log_format=="apacheVhost":
            fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_vhost FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        elif log_format=="apacheCsv":
            fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_csv FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        elif log_format=="nginxCombined":
            if log_server and log_serverport:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_nginx FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "', server_port=" + str(log_serverport)
            elif log_server:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_nginx FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "'"
            else:
              fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_nginx FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        elif log_format=="nginxError":
            if log_server and log_serverport:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_nginx FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "', server_port=" + str(log_serverport)
            elif log_server:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_nginx FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + log_server + "'"
            else:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_nginx FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        else:
            loadCursor.callproc("errorLoad",
                                ["Process Log Format=" + log_format + " not found",
                                 str(611),
                                 "Invalid Log Format",
                                 str(app.importLoadID)])
        try:
            fileCursor.execute( fileLoadSQL )
            fileCursor.execute( "SELECT ROW_COUNT()" )
            fileRecordsLoadedTuple = fileCursor.fetchall()
            fileRecordsLoaded = fileRecordsLoadedTuple[0][0]
            recordsProcessed = recordsProcessed + fileRecordsLoaded
        except Exception as e:
            processErrors += 1
            print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - LOAD DATA LOCAL INFILE INTO TABLE failed : {color.END}{e}")
            if app.error_details:
                print(f"Exception details: {e=}, {type(e)=}")        
            showWarnings = app.dbConnection.show_warnings()
            # print(showWarnings)
            loadCursor.callproc("errorLoad",
                                 ["LOAD DATA LOCAL INFILE INTO TABLE error",
                                  str(showWarnings[0][1]),
                                  showWarnings[0][2],
                                  str(app.importLoadID)])
        app.dbConnection.commit()

    elif backup_days != 0:
        copy_backup_file(rawFile, days_since_imported)
    return

def process(parms):
    global filesFound
    global filesProcessed
    global recordsProcessed
    global processErrors
    global processSeconds
    global processStart
    global processStatus

    # If a function needs to modify a global variable, 
    # it must use the 'global' keyword. This is clear.
    # not sure this is best way to handle variables 
    # shared between process and process_file functions.
    global backup_days
    global log_format
    global load_table

    global log_path
    global log_recursive
    global display_log
    global log_process

    global log_server
    global log_serverport

    global fileCursor
    global loadCursor

    # shared connection for any database message logging done during file copy process.
    fileCursor = app.dbConnection.cursor()
    loadCursor = app.dbConnection.cursor()

    backup_days = parms.get("backup_days")
    log_format = parms.get("log_format")
    load_table = parms.get("load_table")

    log_path = parms.get("path")
    log_recursive = parms.get("recursive")
    display_log = parms.get("log")
    log_process = parms.get("process")
    log_server = parms.get("server")
    log_serverport = parms.get("serverport")
    
    # if log_file is passed - call process_file directly.
    log_file = parms.get("log_file")
#    print(f"log_file: {log_file}")

    processStart = perf_counter()

    if log_file:
        filesFound += 1
        process_file(log_file)
    else:        
        for rawFile in glob(log_path, recursive=log_recursive):
            filesFound += 1
            process_file(rawFile)

    processSeconds = perf_counter() - processStart

    return process_report()
