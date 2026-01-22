# Copyright 2024-2026 Will Raymond <farmfreshsoftware@gmail.com>
#
# Licensed under the http License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.http.org/licenses/LICENSE-2.0
#
# version 4.0.0 - 01/21/2026 - Proper Python code - converted script to application with factory method. - see changelog
#
# CHANGELOG.md in repository - https://github.com/WillTheFarmer/http-logs-to-mysql
"""
Processes Apache & NGINX http logs into normalized MySQL schema for httpLogs2MySQL application.
:module: main.py
:function: process_files()
:module: import_processes.py
:function: get_import_process()
:module: datFileLoader.py
:function: process()
:module: databaseModule.py
:function: process()
:module: dataEnrichment_geoIP.py
:function: process()
:module: dataEnrichment_userAgent.py
:function: process()
:synopsis: Executes Import Load ID parent process that executes child processes & watchdog objservers defined in config.json.
:author: Will Raymond <farmfreshsoftware@gmail.com>
"""
from os import path
from os import getlogin
# used to ID computer process is running on.
# this info is requred to get - importloadid
# importloadid is PARENT ID for transactions
from platform import processor
from platform import uname
from socket import gethostbyname
from socket import gethostname
from apis.device_id import get_device_id
# this handles the 4 modules - fileLoader, dbModuleExecutor, UserAgent module & GeoIP module.
from src.factories.import_processes import get_import_process
# application-level properties and references shared across app modules (files) 
from apis.app_settings import app
# Color Class used app-wide for Message Readability in console
from apis.color_class import color
# used process execution time calculations and displays
# from time import ctime
from time import perf_counter
from datetime import datetime
# Used to display dictionary lists.
from tabulate import tabulate
# config.json drives application loading import processes and watchDog observers. 
from config.app_config import load_file
# all starts here - json process file must exist - nothing works without it
config = load_file()
if config:
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

    # settings for shared functions
    app.backup_days = config["backup"].get("days")
    app.backup_path = config["backup"].get("path")

    app.host_name = config["mysql"].get("host")
    app.host_port = config["mysql"].get("port")

    # Two options for shared database connection to help install issues
    # and separate connction data from JSON app process settings.  
    # Option 1 - pymysql_env.py uses .env file for connection settings 
    from src.database.pymysql_env import getConnection
    # Option 2 - pymysql_json.py uses config.json file for connection settings
    # from src.database.pymysql_json import getConnection

def new_importProcessID():
    processCursor = app.dbConnection.cursor()
    getImportLoadID = "SELECT importLoadProcessID('" + str(app.importLoadID) + "');"
    # print(f"Settings Days:{config["backup"].get("days")} | backup_days: {processParms["backup_days"]}")
    try:
        processCursor.execute( getImportLoadID )
    except Exception as e:
        app.processErrors += 1
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - Function importLoadProcessID(importLoadID) failed'{color.END}{e}")
        if app.error_details:
            print(f"Exception details: {e=}, {type(e)=}")        

        showWarnings = app.dbConnection.show_warnings()
        # print(showWarnings)
        processCursor.callproc("errorLoad",
                              ["Function importLoadProcessID(importLoadID)",
                                str(showWarnings[0][1]),
                                showWarnings[0][2],str(app.importLoadID)])

    importLoadProcessTupleID = processCursor.fetchall()
    # import_process TABLE associates all "import processes" to a import_load OR import_server TABLE record
    # some import_process TABLE records are related to BOTH a import_load AND import_server TABLE record 
    # this important change to enable loosely coupled filtered processes a an import load execution.
    # this new version needs to be released on GitHub and out of my hands for paying projects have been  
    # patiently waiting to start... MLK DAY 2026, 6:25AM EST, 25 hours awake and long weekend at desk.
    return importLoadProcessTupleID[0][0]

def update_importProcess(data):
    print(f"UPDATE import_process with {data} where id = {app.importProcessID}")

def execute_process(process):
    # process info to feed to processes
    moduleName  = process.get("moduleName")
    processParms = process["attributes"]
    processStart = perf_counter()

    # print(f"Settings Days:{config["backup"].get("days")} | backup_days: {processParms["backup_days"]}")

    if processParms.get("log") >= 1:
        print(f"{color.fg.PURPLE}{color.style.BRIGHT}{process.get("name")} | {datetime.now():%Y-%m-%d %H:%M:%S} | App execution: {perf_counter() - app.processStart:.4f} seconds.{color.END}")
    try:
        # gererate new primary ID for import_process table
        # each Import Load Child process gets ID. Stored Procudures UPDATE record totals with ID.
        app.importProcessID = new_importProcessID()
        # Use the factory to get the appropriate loader
        importProcess = get_import_process(moduleName)
        # import process does work are all modules return the same data list []
        data = importProcess(processParms)
        #gererate new primary ID for import_process table
        # update_importProcess(data)
        # processSeconds = perf_counter() - processStart
        if processParms.get("log") >= 1:
          # print(f"{color.fg.GREEN}{color.style.NORMAL}{process.get("name")} Complete | {data.get("Files Loaded")} files loaded | Process Execution: {perf_counter() - processStart:.4f} seconds{color.END}")
          print(f"{color.fg.GREEN}{color.style.NORMAL}{process.get('name')} Complete | {data.get('Files Loaded')} files loaded | Process Execution: {data.get('Process Seconds'):.4f} seconds{color.END}")
        return data

    except ValueError as e:
        print(f"Error processing file: {e}")
        if app.error_details:
            print(f"Exception details: {e=}, {type(e)=}")        

    except FileNotFoundError:
        print(f"Error: File not found at {moduleName}")

def process_files(processList=[]):
    # Get the current date and time
    print (f"{color.fg.YELLOW}{color.style.BRIGHT}ProcessLogs start: {datetime.now():%Y-%m-%d %H:%M:%S} | Host: {app.host_name} | Port: {app.host_port}{color.END}") 

    app.processErrors = 0
    app.processStart = perf_counter()
    app.processSeconds = 0 

    # shared connection for all app modules.
    app.dbConnection = getConnection()
    
    getImportDeviceID = ("SELECT importDeviceID('" + deviceid + 
                         "', '"  + platformNode + 
                         "', '"  + platformSystem + 
                         "', '"  + platformMachine + 
                         "', '"  + platformProcessor + "');")
    loadCursor = app.dbConnection.cursor()
    try:
        loadCursor.execute( getImportDeviceID )
    except Exception as e:
        app.processErrors += 1
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - Function importDeviceID() failed.{color.END}{e}")
        if app.error_details:
            print(f"Exception details: {e=}, {type(e)=}")        
        showWarnings = app.dbConnection.show_warnings()
        # print(showWarnings)
        loadCursor.callproc("errorLoad",
                            ["Function importDeviceID()",
                             str(showWarnings[0][1]),
                             showWarnings[0][2],
                             str(app.importLoadID)])
    importDeviceTupleID = loadCursor.fetchall()
    app.importDeviceID = importDeviceTupleID[0][0]
    getImportClientID = ("SELECT importClientID('" + ipaddress + 
                         "', '"  + login + 
                         "', '"  + expandUser + 
                         "', '"  + platformRelease + 
                         "', '"  + platformVersion + 
                         "', '"  + str(app.importDeviceID) + "');")
    try:
        loadCursor.execute( getImportClientID )
    except Exception as e:
        app.processErrors += 1
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - Function importClientID() failed : {color.END}{e}")
        if app.error_details:
            print(f"Exception details: {e=}, {type(e)=}")        
        showWarnings = app.dbConnection.show_warnings()
        # print(showWarnings)
        loadCursor.callproc("errorLoad",
                            ["Function importClientID()",
                            str(showWarnings[0][1]),
                            showWarnings[0][2],
                            str(app.importLoadID)])
    importClientTupleID = loadCursor.fetchall()
    app.importClientID = importClientTupleID[0][0]
    getImportLoadID = "SELECT importLoadID('" + str(app.importClientID) + "');"
    try:
        loadCursor.execute( getImportLoadID )
    except Exception as e:
        app.processErrors += 1
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - Function importLoadID(importClientID) failed : {color.END}{e}")
        if app.error_details:
            print(f"Exception details: {e=}, {type(e)=}")        
        showWarnings = app.dbConnection.show_warnings()
        # print(showWarnings)
        loadCursor.callproc("errorLoad",
                            ["Function importLoadID(importClientID)",
                            str(showWarnings[0][1]),
                            showWarnings[0][2],str(app.importLoadID)])

    importLoadTupleID = loadCursor.fetchall()
    app.importLoadID = importLoadTupleID[0][0]

    # list for adding each process execution information for summary report
    log_processes = []

    # starting collection to filter.A Parameter can be passed - processList - List[] of processids for flexibility.
    allProcesses = config['processes']

    # the default filter - if processList is EMPTY - only processes with status = "Active"
    # filtering options are endless. watchDog Observers pass List[] of processid to execute in the order to execute.
    log_file = ""
    if not processList:
        filteredProcesses = [logformat for logformat in allProcesses if logformat['status'] == 'Active']
    else:
        listItems = len(processList)
        # print(f"Process List: {processList} with count of {len(processList)}")
        # get the file and path to process. 
        log_file = processList[listItems-1]
        # this removes the file to be processed. 
        processList.pop(-1)
        # print(f"Process Filter: {processList} with count of {len(processList)} - file: {log_file}")
        filteredProcesses = [process for process in allProcesses if process["id"] in processList]

    for process in filteredProcesses:
        if log_file:
            process["attributes"]["log_file"] = log_file

        data = execute_process(process)
        # print(data)
        # add process information for summary report
        processInfo = {"id": process.get("id"), "Module": process.get("moduleName")}
        processInfo.update(data)
        log_processes.append(processInfo)

    loadUpdateSQL = ('UPDATE import_load SET ' +
                  ' errorCount=' + str(app.processErrors) + 
                  ', completed=now()' + 
                  ', processSeconds=' + 
                  str(round(app.processSeconds,0)) + 
                  ' WHERE id=' + str(app.importLoadID) +';')
    try:
        loadCursor.execute(loadUpdateSQL)
    except Exception as e:
        app.processErrors += 1
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - UPDATE import_load SET Statement failed : {color.END}{e}")
        if app.error_details:
            print(f"Exception details: {e=}, {type(e)=}")        
        showWarnings = app.dbConnection.show_warnings()
        # print(showWarnings)
        loadCursor.callproc("errorLoad",
                                  ["UPDATE import_load SET Statement",
                                   str(showWarnings[0][1]),
                                   showWarnings[0][2],
                                   str(app.importLoadID)])
    app.dbConnection.commit()
    loadCursor.close()
    # clear reference for shared connection
    app.dbConnection.close()
    app.dbConnection = None
 
    # Calculate the elapsed time
    app.processSeconds = perf_counter() - app.processStart            
    # Display the execution time using an f-string
    # The :.4f format specifier formats the float to 4 decimal places

    # Summary Report - import load process list display
    # List of all processes that executed with totals. 
    # import_load & import_load_process tables have parent and child data records.
    # Print report header
    print(f"{color.fg.GREEN}{color.style.NORMAL}Import Load Summary | Log File & Record Counts and Process Metrics | " \
          f"ImportLoadID: {app.importLoadID} | " \
          f"ClientID: {app.importClientID} | " \
          f"DeviceID:{app.importDeviceID} | " \
          f"Errors Found:{app.processErrors}{color.END}")

    # The 'keys' header option automatically uses dictionary keys as column headers
    print(tabulate(log_processes, headers='keys', tablefmt='github'))

    # Print summary bottom
    print(f"{color.fg.GREEN}{color.style.NORMAL}" \
          f"ImportLoadID: {app.importLoadID} | " \
          f"{app.processErrors} Errors Found | Import Load Summary Values added to import_load TABLE{color.END}")
   
    # Print report footer
    print(f"{color.fg.YELLOW}{color.style.BRIGHT}ProcessLogs complete: {datetime.now():%Y-%m-%d %H:%M:%S} | " \
          f"Execution time: {app.processSeconds:.4f} seconds{color.END}")

if __name__ == "__main__":
    process_files()
