# Copyright 2024-2026 Will Raymond <farmfreshsoftware@gmail.com>
#
# Licensed under the http License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.http.org/licenses/LICENSE-2.0
#
# version 4.0.1 - 01/24/2026 - Proper Python code, NGINX format support and Python/SQL repository separation - see changelog
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

import pymysql

from src.apis.utilities import copy_backup_file

# Define specific MySQL error codes for conditional handling
# Example error codes: 1045 (Access denied), 1062 (Duplicate entry), 1146 (No such table)
# You might need to adjust these based on your specific error handling needs.
ERROR_ACCESS_DENIED = 1045
ERROR_NO_SUCH_TABLE = 1146

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
        add_error({__name__},{type(e).__name__}, {e}, e)

    if days_since_imported is None:

        print(f"load_table : {mod.load_table} log_format : {mod.log_format} server_name : {mod.log_server} server_name : {mod.log_server} days_since_imported : {days_since_imported} loadFile : {loadFile}")

        mod.filesProcessed += 1

        if mod.display_log >= 2:
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
            add_error({__name__},{type(e).__name__}, {e}, e)

        # LOAD DATA SQL String
        fileLoadSQL = ""
        
        #  SQL String Component variables - in order
        fileLoadSQL_tables = ""
        fileLoadSQL_format = ""
        fileLoadSQL_importFileID = ""
        fileLoadSQL_serverInfo = ""

        # build LOAD DATA string - it all depends on log format being setup below - app settings (config.json)
        print(f"load_table : {mod.load_table} log_format : {mod.log_format} server_name : {mod.log_server} server_name : {mod.log_server} loadFile : {loadFile}")

        if mod.log_format=="apacheError" or mod.log_format=="nginxError":
          fileLoadSQL_format = f" FIELDS TERMINATED BY ']' ESCAPED BY '\r'"

        elif mod.log_format=="apacheCommon" or mod.log_format=="apacheCombined" or mod.log_format=="apacheVhost" or mod.log_format=="nginxCombined":
            fileLoadSQL_format = " FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r'"

        elif mod.log_format=="apacheCsv":
            fileLoadSQL_format = " FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\r'"

        else:
            mod.errorCount += 1
            add_error({__name__},{type(e).__name__}, f"Process Log Format={mod.log_format} not found")

        if fileLoadSQL_format:
            # format is excepted - based on other app settings (config.json) figure out if server info components required for LOAD DATA string build
            fileLoadSQL_tables = f"LOAD DATA LOCAL INFILE '{loadFile}' INTO TABLE {mod.load_table}"

            # import_file TABLE Primary ID - this relates TEXT FILES to RELATIONAL TABLE DATA 
            fileLoadSQL_importFileID = f" SET importfileid={fileInsertFileID}"

            # if the string is set check is server and server port are populated. If YES add the string
            if mod.log_server and mod.log_serverport:
                 fileLoadSQL_serverInfo = f", server_name='{mod.log_server}', server_port={mod.log_serverport}"

            elif mod.log_server:
                 fileLoadSQL_serverInfo = f", server_name='{mod.log_server}'"

            # build LOAD DATA string
            fileLoadSQL = f"{fileLoadSQL_tables}{fileLoadSQL_format}{fileLoadSQL_importFileID}{fileLoadSQL_serverInfo}"
            print(f"fileLoadSQL : {fileLoadSQL}")

            try:
                mod.cursor.execute( fileLoadSQL )
                mod.cursor.execute( "SELECT ROW_COUNT()" )
                fileRecordsLoadedTuple = mod.cursor.fetchall()
                fileRecordsLoaded = fileRecordsLoadedTuple[0][0]
                mod.recordsProcessed = mod.recordsProcessed + fileRecordsLoaded

            except pymysql.Error as e:
                mod.errorCount += 1
                add_error({__name__},{type(e).__name__}, {e}, e)

    elif mod.backup_days != 0:
        copy_backup_file(rawFile, days_since_imported)

    return

def process(parms):

    mod.set_defaults()

    # shared application-level connection for any database message logging done during file copy process.
    mod.cursor = app.dbConnection.cursor()

    mod.backup_days = parms.get("backup_days")
    
    mod.log_format = parms.get("log_format")
    mod.load_table = parms.get("load_table")
    mod.log_path = parms.get("path")
    mod.log_recursive = parms.get("recursive")
    mod.display_log = parms.get("log")
    mod.log_server = parms.get("server")
    mod.log_serverport = parms.get("serverport")
    
    # watchDog observers pass each file as a parameter. 
    # if log_file is passed - call process_file directly.
    log_file = parms.get("log_file")
    if app.error_details and log_file:
        print(f"File passed : {log_file}")

    if log_file:
        mod.filesFound += 1
        process_file(log_file)
    else:        
        for rawFile in glob(mod.log_path, recursive=mod.log_recursive):

            filename = path.basename(rawFile)
            print(f"Processing file: {filename}")
            mod.filesFound += 1

            try:
              fileStatus = process_file(rawFile)
              if fileStatus:
                  print(f"Status for {filename}: {fileStatus}")
              else:
                  print(f"No record found for {filename}")

            except pymysql.Error as e:
                add_error({__name__},{type(e).__name__}, {e})
                mod.errorCount += 1

        # Commit changes if the loop completes without a breaking error
        else:
            app.dbConnection.commit()
            print("All files processed successfully (or continued past errors). Changes committed.")

    return mod.process_report()
