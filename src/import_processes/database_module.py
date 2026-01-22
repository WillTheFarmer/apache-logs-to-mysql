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
:module: databaseModule.py
:function: process()
:synopsis: processes HTTP access and error logs into MySQL or MariaDB for httpLogs2MySQL application.
:author: Will Raymond <farmfreshsoftware@gmail.com>
"""
# application-level properties and references shared across app modules (files) 
from apis.app_settings import app
# Color Class used app-wide for Message Readability in console
from apis.color_class import color
# used process execution time calculations and displays
# from time import ctime
from time import perf_counter
from datetime import datetime

filesFound = 0
filesProcessed = 0
recordsProcessed = 0
processErrors = 0
processSeconds = 0.000000
processStart = None
processStatus = None

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

def process(parms):
    global filesFound
    global filesProcessed
    global recordsProcessed
    global processErrors
    global processSeconds
    global processStart
    global processStatus

    processStart = perf_counter()

    display_log = parms.get("log")
    dbModuleName = parms.get("dbModuleName")
    dbModuleParm1 = parms.get("dbModuleParm1")
    
    fileCursor = app.dbConnection.cursor()
    loadCursor = app.dbConnection.cursor()

    try:
        fileCursor.callproc(dbModuleName,
                            [dbModuleParm1,
                            str(app.importProcessID)])
    except Exception as e:
        processErrors += 1
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR -  Stored Procedure failed : {color.END}{e}")
        if app.error_details:
            print(f"Exception details: {e=}, {type(e)=}")        
        showWarnings = app.dbConnection.show_warnings()
        # print(showWarnings)
        loadCursor.callproc("errorLoad",
                            ["Executing Stored Procedure Error",
                            str(showWarnings[0][1]),
                            showWarnings[0][2],
                            str(app.importProcessID)])

    app.dbConnection.commit()

    processSeconds = perf_counter() - processStart

    return process_report()
