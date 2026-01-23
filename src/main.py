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
# Processes Apache & NGINX logs into normalized MySQL schema for httpLogs2MySQL application.
# module: main.py
# function: process_files()
# module: import_processes.py
# function: get_import_process()
# module: datFileLoader.py
# function: process()
# module: databaseModule.py
# function: process()
# module: dataEnrichment_geoIP.py
# function: process()
# module: dataEnrichment_userAgent.py
# function: process()
# synopsis: main:process_files (import_load table) executes child processes (import_process table) & watchdog observers defined in config.json.
# author: Will Raymond <farmfreshsoftware@gmail.com>

# used everywhere
from os import path

# used to ID computer process is running on.
from os import getlogin
from platform import processor
from platform import uname
from socket import gethostbyname
from socket import gethostname
from apis.device_id import get_device_id

# this handles the 4 modules - fileLoader, dbModuleExecutor, UserAgent module & GeoIP module.
from src.factories.import_processes import get_import_process

# application-level properties and references shared across app modules (files) 
from apis.properties_app import app

# application-level error handle
from apis.error_app import add_error

# Color Class used app-wide for Message Readability in console
from apis.color_class import color

# used process execution time calculations and displays
# from time import ctime
from time import perf_counter
from datetime import datetime

# Used to display dictionary lists.
from tabulate import tabulate

# config.json drives application loading import processes and watchDog observers. 
from config.config_app import load_file

# used EXIT if missing required IDs : app.importDeviceID, app.importClientID and app.importLoadID    
import sys

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

    getImportLoadID = "SELECT importLoadProcessID('" + str(app.importLoadID) + "');"

    try:
        app.cursor.execute( getImportLoadID )
        importLoadProcessTupleID = app.cursor.fetchall()
        # import_process TABLE associates all "import processes" to a import_load OR import_server TABLE record
        # some import_process TABLE records are related to BOTH a import_load AND import_server TABLE record 
        # this important change to enable loosely coupled filtered processes a an import load execution.
        # this new version needs to be released on GitHub and out of my hands for paying projects have been  
        # patiently waiting to start... MLK DAY 2026, 6:25AM EST, 25 hours awake and long weekend at desk.
        return importLoadProcessTupleID[0][0]

    except Exception as e:
        add_error("Function importLoadProcessID(importLoadID) failed", e)
        return None

def update_importProcess(data):

    # update import_process record ID = app.importProcessID
    if data.get("ProcessErrors") == 0: 
       """ update import_process.completed = now() """

    print(f"UPDATE import_process with {data} where id = {app.importProcessID}")

def execute_process(process):
    # process info to feed to processes
    moduleName  = process.get("moduleName")
    processParms = process["attributes"]

    processInfo = {}

    # used for calcuations and log messaging to main:process_files
    app.executeStart = perf_counter()

    if processParms.get("log") >= 1:
        print(f"{color.fg.GREEN}{color.style.NORMAL}Start{color.END} | {process.get("name")} | {datetime.now():%Y-%m-%d %H:%M:%S} | {color.fg.GREEN}{color.style.NORMAL}App execution: {app.executeStart - app.processStart:.4f} seconds.{color.END}")

    try:
        # gererate new primary ID for import_process table
        # each Import Load Child process gets ID. Stored Procudures UPDATE record totals with ID.
        app.importProcessID = new_importProcessID()

        # Use the factory to get the appropriate loader
        importProcess = get_import_process(moduleName)
        #gererate new primary ID for import_process table

        try:
            # import process does work are all modules return the same data list []
            data = importProcess(processParms)

            if data:
                app.executeSeconds = perf_counter() - app.executeStart

                print(data)
        
                update_importProcess(data)

                # print(data)
                # add import process information for summary report
                processInfo = {"importProcessID": app.importProcessID, "executeSeconds": app.executeSeconds}
                processInfo.update(data)
  
        except Exception as e:
            add_error(f"Error processing {process.get("name")}", e)
            print(f"Error processing {process.get("name")}: {e}")
            return None

        if processParms.get("log") >= 1:
          print(f"{color.fg.GREENI}{color.style.NORMAL}End{color.END} | {process.get('name')} | {color.fg.GREENI}{color.style.NORMAL}Process ID: {processInfo.get('importProcessID'):.4f} | {processInfo.get('Files Loaded')} files loaded | time: {processInfo.get('executeSeconds'):.4f} seconds{color.END}")

        # return dictionary {} to main:process_files for process_list to append for Import Load summary log message
        return processInfo

    except ValueError as e:
        add_error(f"Error processing file: {e}", e)

    except FileNotFoundError:
        add_error(f"Error: File not found at {moduleName}")

def process_files(processList=[]):
    # display console message log header
    print (f"{color.fg.YELLOW}{color.style.BRIGHT}ProcessLogs start: {datetime.now():%Y-%m-%d %H:%M:%S} | Host: {app.host_name} | Port: {app.host_port}{color.END}") 

    # reset application-level calcualtion properties
    app.errorCount = 0
    app.processStart = perf_counter()
    app.processSeconds = 0 

    # shared connection for all app modules
    app.dbConnection = getConnection()
    # shared cursor for app-level functions
    app.cursor = app.dbConnection.cursor()

    # if any of the 3 MySQL function calls fail process is aborted 
    sqlImportDeviceID = f"SELECT importDeviceID('{deviceid}', '{platformNode}', '{platformSystem}', '{platformMachine}', '{platformProcessor}');"
    try:
        app.cursor.execute( sqlImportDeviceID )
        importDeviceTupleID = app.cursor.fetchall()
        # app.importDeviceID identifies the computer executing this application
        app.importDeviceID = importDeviceTupleID[0][0]

        sqlImportClientID = f"SELECT importClientID('{ipaddress}', '{login}', '{expandUser}', '{platformRelease}', '{platformVersion}', '{app.importDeviceID}');"
        try:
            app.cursor.execute( sqlImportClientID )
            importClientTupleID = app.cursor.fetchall()
            # app.importClientID identifies the login information about computer executing this application
            app.importClientID = importClientTupleID[0][0]

            getImportLoadID = "SELECT importLoadID('" + str(app.importClientID) + "');"
            try:
                app.cursor.execute( getImportLoadID )
                importLoadTupleID = app.cursor.fetchall()
                # app.importloadID relates back to all data imported by this application
                app.importLoadID = importLoadTupleID[0][0]

            except Exception as e:
                add_error(f"Function importLoadID(importClientID) failed.", e)

        except Exception as e:
            add_error(f"Function importClientID() failed.", e)

    except Exception as e:
        add_error(f"Function importDeviceID() failed.", e)

    if app.errorCount > 0:
        print("Error has already occurred and nothing was done yet!")
        sys.exit(1) # Exit with error code 1
     
    print(f"Processing with is a starting... please wait")

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

        processInfo = {"id": process.get("id"), "Module": process.get("moduleName")}
   
        try:
            data = execute_process(process)
            # print(data)
            # add process information for summary report
            if data:
                processInfo.update(data)
                log_processes.append(processInfo)
    
        except Exception as e:
            add_error(f"Error processing {processInfo}: {e}", e)
            # print(f"Error processing {processInfo}: {e}")
            break  # Exit the loop entirely on error
            # continue  # Or skip this process and move to next


    loadUpdateSQL = f"UPDATE import_load SET errorCount={app.errorCount}, completed=now(), processSeconds={app.processSeconds} WHERE id={app.importLoadID}"

    try:
        app.cursor.execute(loadUpdateSQL)

    except Exception as e:
        app.errorCount += 1
        add_error(f"UPDATE import_load SET Statement failed.", e)

    # commit and close 
    app.dbConnection.commit()
    app.cursor.close()

    # clear reference for shared connection
    app.dbConnection.close()
    app.dbConnection = None
 
    # Calculate the elapsed time
    app.processSeconds = perf_counter() - app.processStart            

    # Summary Report - import load process list display
    # List of all processes that executed with totals. 
    # import_load & import_load_process tables have parent and child data records.
    # Print report header
    print(f"{color.fg.GREEN}{color.style.NORMAL}Import Load Summary | Log File & Record Counts and Process Metrics | " \
          f"ImportLoadID: {app.importLoadID} | " \
          f"ClientID: {app.importClientID} | " \
          f"DeviceID:{app.importDeviceID} | " \
          f"Errors Found:{app.errorCount}{color.END}")

    # The 'keys' header option automatically uses dictionary keys as column headers
    print(tabulate(log_processes, headers='keys', tablefmt='github'))

    # Print summary bottom
    print(f"{color.fg.GREEN}{color.style.NORMAL}" \
          f"ImportLoadID: {app.importLoadID} | " \
          f"{app.errorCount} Errors Found | Import Load Summary Values added to import_load TABLE{color.END}")
   
    # Print report footer
    print(f"{color.fg.YELLOW}{color.style.BRIGHT}ProcessLogs complete: {datetime.now():%Y-%m-%d %H:%M:%S} | " \
          f"Execution time: {app.processSeconds:.4f} seconds{color.END}")

if __name__ == "__main__":
    process_files()
