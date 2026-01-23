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
# module: databaseModule.py
# function: process()
# synopsis: processes HTTP access and error logs into MySQL or MariaDB for httpLogs2MySQL application.
# author: Will Raymond <farmfreshsoftware@gmail.com>

# application-level properties and references shared across app modules (files) 
from apis.properties_app import app

# application-level error handle
from apis.error_app import add_error

# process-level properties and references shared across process app functions (def) 
from apis.properties_process import DatabaseModule as mod

# Color Class used app-wide for Message Readability in console
# from apis.color_class import color

def process(parms):

    mod.set_defaults()

    display_log = parms.get("log")
    dbModuleName = parms.get("dbModuleName")
    dbModuleParm1 = parms.get("dbModuleParm1")
    
    mod.cursor = app.dbConnection.cursor()

    try:
        mod.cursor.callproc(dbModuleName,
                            [dbModuleParm1,
                            str(app.importProcessID)])
    except Exception as e:
        errorCount += 1
        add_error(f"Stored Procedure : {dbModuleName} with Parms : {dbModuleParm1} failed", e)

    app.dbConnection.commit()

    return mod.process_report()
