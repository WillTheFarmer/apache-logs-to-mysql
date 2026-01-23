# Copyright 2024-2026 Will Raymond <farmfreshsoftware@gmail.com>
#
# Licensed under the http License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.http.org/licenses/LICENSE-2.0
#
# version 4.0.1 - 01/23/2026 - Proper Python code, NGINX format support and Python/SQL repository separation - see changelog
#
# CHANGELOG.md in repository - https://github.com/WillTheFarmer/http-logs-to-mysql
#
# module: datFileLoader.py
# function: process_file()
# synopsis: each file is processed here. This is where LOAD DATA is done.
# function: process()
# synopsis: loops through files in parameterized directory and calls process_file().
# author: Will Raymond <farmfreshsoftware@gmail.com>

# application-level properties and references shared across app modules (files) 
from apis.properties_app import app

# application-level error handle
from apis.error_app import add_error

# process-level properties and references shared across process app functions (def) 
from apis.properties_process import DataFileLoader as mod

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
mod.log_format = "none"
load_table = "none"
log_path = "."
log_recursive = False
display_log = 1
log_process = 1
mod.log_server = "mydomain.com"
mod.log_serverport = 443

print(f"The initializing of file name = {__name__} in directory = {__file__} this is at top of file.")

def process_file(rawFile):

    if '\\' in rawFile:
        loadFile = rawFile.replace(sep, sep+sep)
    else:
        loadFile = rawFile

    # MySQL function importFilesExists returns number of days since file was INSERTED into TABLE import_file. 
    # value used in combination with config.json backup_days and backup_path settings to trigger:
    #  1) COPY to backup directory and DELETE file from current directory. 2)just DELETE file or 3) do NOTHING
    days_since_importedSQL = f"SELECT importFileExists('{loadFile}', '{app.importDeviceID}');"

    try:
        mod.cursor.execute( days_since_importedSQL )
        days_since_importedTuple = mod.cursor.fetchall()
        days_since_imported = days_since_importedTuple[0][0]

    except Exception as e:
        mod.errorCount += 1
        add_error(f"Function importFileExists() failed", e)

    if days_since_imported is None:

        mod.filesProcessed += 1

        if display_log >= 2:
            print(f"Loading log file | {rawFile}")

        fileInsertCreated = ctime(path.getctime(rawFile))
        fileInsertModified = ctime(path.getmtime(rawFile))
        fileInsertSize = str(path.getsize(rawFile))

        fileInsertSQL = f"SELECT importFileID('{loadFile}', '{fileInsertSize}', '{fileInsertCreated}', '{fileInsertModified}', '{app.importDeviceID}', '{app.importLoadID}', '5' );"
        try:
            mod.cursor.execute( fileInsertSQL )
            fileInsertTupleID = mod.cursor.fetchall()
            fileInsertFileID = fileInsertTupleID[0][0]

        except Exception as e:
            mod.errorCount += 1
            add_error(f"Function importFileID() failed", e)

        fileLoadSQL = ""
        if mod.log_format=="apacheError":

            if mod.log_server and mod.log_serverport:
#                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_apache FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "', server_port=" + str(mod.log_serverport)
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE " + mod.load_table + " FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "', server_port=" + str(mod.log_serverport)

            elif mod.log_server:
#                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_apache FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "'"
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE " + mod.load_table + " FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "'"

            else:
#                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_apache FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE " + mod.load_table + " FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        elif mod.log_format=="apacheCommon" or mod.log_format=="apacheCombined":

            if mod.log_server and mod.log_serverport:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "', server_port=" + str(mod.log_serverport)

            elif mod.log_server:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "'"

            else:
              fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        elif mod.log_format=="apacheVhost":
            fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_vhost FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        elif mod.log_format=="apacheCsv":
            fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_csv FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        elif mod.log_format=="nginxCombined":

            if mod.log_server and mod.log_serverport:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_nginx FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "', server_port=" + str(mod.log_serverport)

            elif mod.log_server:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_nginx FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "'"

            else:
              fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_access_nginx FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        elif mod.log_format=="nginxError":

            if mod.log_server and mod.log_serverport:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_nginx FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "', server_port=" + str(mod.log_serverport)

            elif mod.log_server:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_nginx FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID) + ", server_name='" + mod.log_server + "'"

            else:
                fileLoadSQL = "LOAD DATA LOCAL INFILE '" + loadFile + "' INTO TABLE load_error_nginx FIELDS TERMINATED BY ']' ESCAPED BY '\r' SET importfileid=" + str(fileInsertFileID)

        else:
            mod.errorCount += 1
            add_error(f"Process Log Format={mod.log_format} not found")

        if fileLoadSQL:
            try:
                mod.cursor.execute( fileLoadSQL )
                mod.cursor.execute( "SELECT ROW_COUNT()" )
                fileRecordsLoadedTuple = mod.cursor.fetchall()
                fileRecordsLoaded = fileRecordsLoadedTuple[0][0]
                mod.recordsProcessed = mod.recordsProcessed + fileRecordsLoaded
                app.dbConnection.commit()

            except Exception as e:
                mod.errorCount += 1
                add_error(f"LOAD DATA LOCAL INFILE INTO TABLE failed", e)

        # print(f"process_file -END - mod.backup_path: {color.bg.GREEN}{color.style.BRIGHT}{mod.backup_path}{color.END}")

    elif backup_days != 0:
        copy_backup_file(rawFile, days_since_imported)
    return

def process(parms):
    # global mod
    # print(f"process - START - mod.backup_path: {color.bg.YELLOW}{color.style.BRIGHT}{mod.backup_path}{color.END}")

    mod.set_defaults()
    
    # print(f"process - AFTER RESET - mod.backup_path: {color.bg.RED}{color.style.BRIGHT}{mod.backup_path}{color.END}")

    # mod.backup_path = "Big Fish"
        
    # print(f"process - AFTER settttT - mod.backup_path: {color.bg.BLUE}{color.style.BRIGHT}{mod.backup_path}{color.END}")

    # shared connection for any database message logging done during file copy process.
    # mod.cursor = app.dbConnection.cursor()
    # app.cursor = app.dbConnection.cursor()
    mod.cursor = app.dbConnection.cursor()

    mod.backup_days = parms.get("backup_days")
    
    mod.log_format = parms.get("log_format")
    mod.load_table = parms.get("load_table")
    mod.log_path = parms.get("path")
    mod.log_recursive = parms.get("recursive")
    mod.display_log = parms.get("log")
#    mod.log_process = parms.get("process")
    mod.log_server = parms.get("server")
    mod.log_serverport = parms.get("serverport")
    
    # if log_file is passed - call process_file directly.
    log_file = parms.get("log_file")
#    print(f"log_file: {log_file}")

#    mod.processStart = perf_counter()
    mod.processStart = perf_counter()

    if log_file:
        mod.filesFound += 1
        process_file(log_file)
    else:        
        for rawFile in glob(log_path, recursive=log_recursive):

            mod.filesFound += 1

            try:
                process_file(rawFile)

            except Exception as e:
                mod.errorCount += 1
                add_error(f"Error processing {rawFile}: {e}", e)
                break  # Exit the loop entirely on error
                # continue  # Or skip this file and move to next

    mod.processSeconds = perf_counter() - mod.processStart

    return mod.process_report()
