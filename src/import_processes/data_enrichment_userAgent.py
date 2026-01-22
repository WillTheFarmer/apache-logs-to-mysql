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
:module: dataEnrichment_userAgent.py
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

from user_agents import parse
# variables used for summary of Import Load process - All import processes have the same variables.
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
    loadCursor = app.dbConnection.cursor()

    selectUserAgentCursor = app.dbConnection.cursor()
    updateUserAgentCursor = app.dbConnection.cursor()
    try:
        selectUserAgentCursor.execute("SELECT id, name FROM access_log_useragent WHERE ua_browser IS NULL")
    except Exception as e:
        processErrors += 1
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - SELECT id, name FROM access_log_useragent WHERE ua_browser IS NULL failed : {color.END}{e}")
        if app.error_details:
            print(f"Exception details: {e=}, {type(e)=}")        
        showWarnings = app.dbConnection.show_warnings()
        # print(showWarnings)
        loadCursor.callproc("errorLoad",
                            ["SELECT id, name FROM access_log_useragent WHERE ua_browser",
                             str(showWarnings[0][1]),
                             showWarnings[0][2],
                             str(app.importLoadID)])
    for x in range(selectUserAgentCursor.rowcount):
        recordsProcessed += 1
        userAgent = selectUserAgentCursor.fetchone()
        recID = str(userAgent[0])
        ua = parse(userAgent[1])
        if display_log >= 2:
            print(f"{color.fg.CYAN}{color.style.DIM}Parsing User Agent | {ua}{color.END}")
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
            except Exception as e:
                processErrors += 1
                print(f"{color.bg.RED}{color.style.BRIGHT}Error - UPDATE access_log_useragent failed : {color.END}{e}")
                if app.error_details:
                    print(f"Exception details: {e=}, {type(e)=}")        
                showWarnings = app.dbConnection.show_warnings()
                # print(showWarnings)
                loadCursor.callproc("errorLoad",
                                    ["UPDATE access_log_useragent SET Statement",
                                     str(showWarnings[0][1]),
                                     showWarnings[0][2],
                                     str(app.importLoadID)])
    app.dbConnection.commit()
    selectUserAgentCursor.close()
    updateUserAgentCursor.close()

    processSeconds = perf_counter() - processStart

    return process_report()
