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
:module: dataEnrichment_geoIP.py
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

import geoip2.database

from os import path
from os import sep

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

    display_log = parms.get("log")
    geoip_city = parms.get("city")
    geoip_asn = parms.get("asn")

    processStart = perf_counter()
    
    loadCursor = app.dbConnection.cursor()
      
    geoip_city_file_exists = True
    geoip_asn_file_exists = True
    processStart = perf_counter()
    if '\\' in geoip_city:
      geoip_city_file = geoip_city.replace(sep, sep+sep)
    else:
      geoip_city_file = geoip_city
    if '\\' in geoip_asn:
      geoip_asn_file = geoip_asn.replace(sep, sep+sep)
    else:
      geoip_asn_file = geoip_asn
    if not path.exists(geoip_city_file):
        processErrors += 1
        geoip_city_file_exists = False
        print(color.bg.RED + color.style.BRIGHT + 
              'ERROR - IP geolocation CITY database: ' + 
              geoip_city_file + 
              ' not found.' + 
              color.END)
        loadCursor.callproc("errorLoad",
                            ["IP geolocation CITY database not found",
                             '1234',
                             geoip_city_file,
                             str(app.importLoadID)])
    if not path.exists(geoip_asn_file):
        processErrors += 1
        geoip_asn_file_exists = False
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - IP geolocation ASN database: {geoip_asn_file} not found.{color.END}")
        loadCursor.callproc("errorLoad",
                            ["IP geolocation ASN database not found",
                            '1234',
                            geoip_asn_file,
                            str(app.importLoadID)])
    if geoip_city_file_exists and geoip_asn_file_exists:
        selectGeoIPCursor = app.dbConnection.cursor()
        updateGeoIPCursor = app.dbConnection.cursor()
        try:
            selectGeoIPCursor.execute("SELECT id, name FROM log_client WHERE country_code IS NULL")
        except Exception as e:
            processErrors += 1
            print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - SELECT FROM log_client WHERE ua_browser IS NULL failed : {color.END}{e}")
            if app.error_details:
                print(f"Exception details: {e=}, {type(e)=}")        
            showWarnings = app.dbConnection.show_warnings()
            # print(showWarnings)
            loadCursor.callproc("errorLoad",
                                ["SELECT id, name FROM log_client WHERE country_code IS NULL",
                                 str(showWarnings[0][1]),
                                 showWarnings[0][2],
                                 str(app.importLoadID)])
        try:
            cityReader = geoip2.database.Reader(geoip_city_file)
        except Exception as e:
            processErrors += 1
            print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - cityReader = geoip2.database.Reader failed : {color.END}{e}")
            if app.error_details:
                print(f"Exception details: {e=}, {type(e)=}")        
            showWarnings = app.dbConnection.show_warnings()
            # print(showWarnings)
            loadCursor.callproc("errorLoad",
                                ["cityReader = geoip2.database.Reader failed",
                                '1111',
                                e, 
                                str(app.importLoadID)])
        try:
            asnReader = geoip2.database.Reader(geoip_asn_file)
        except Exception as e:
            processErrors += 1
            print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - cityReader = geoip2.database.Reader failed : {color.END}{e}")
            if app.error_details:
                print(f"Exception details: {e=}, {type(e)=}")        
            showWarnings = app.dbConnection.show_warnings()
            # print(showWarnings)
            loadCursor.callproc("errorLoad",
                                ["cityReader = geoip2.database.Reader failed",
                                '1111',
                                e,
                                str(app.importLoadID)])
        for x in range(selectGeoIPCursor.rowcount):
            recordsProcessed += 1
            geoipRec = selectGeoIPCursor.fetchone()
            recID = str(geoipRec[0])
            ipAddress = geoipRec[1]
            country_code = ''
            country = ''
            subdivision = ''
            city = ''
            latitude = 0.0
            longitude = 0.0
            organization = ''
            network = ''
            if display_log >= 2:
                print(f"{color.fg.CYAN}{color.style.DIM}Retrieving data for IP Address | {ipAddress}{color.END}")
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
            except Exception as e:
                processErrors += 1
                print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - cityReader for IP : {ipAddress} failed: {color.END}{e}")
                if app.error_details:
                    print(f"Exception details: {e=}, {type(e)=}")        
                showWarnings = app.dbConnection.show_warnings()
                # print(showWarnings)
                loadCursor.callproc("errorLoad",
                                    ["cityReader.city() failed",
                                     '1234',
                                     ipAddress,
                                     str(app.importLoadID)])
            try:
                asnData = asnReader.asn(ipAddress)
                if asnData.autonomous_system_organization is not None:
                    organization = asnData.autonomous_system_organization
                    organization = organization.replace('"', '')
                asnData_network = asnData.network
                if asnData_network is not None:
                    network = str(asnData_network)
            except Exception as e:
                asnData = None
                network = str(e.network)
                processErrors += 1
                print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - asnReader for IP : {ipAddress} failed: {color.END}{e}")
                if app.error_details:
                    print(f"Exception details: {e=}, {type(e)=}")        
                showWarnings = app.dbConnection.show_warnings()
                # print(showWarnings)
                loadCursor.callproc("errorLoad",
                                    ["asnReader.asn() failed",
                                    '1234',
                                    ipAddress,
                                    str(app.importLoadID)])
            updateSql = ('UPDATE log_client SET country_code="'+ country_code + 
                       '", country="' + country + 
                       '", subdivision="' + subdivision + 
                       '", city="' + city + 
                       '", latitude=' + str(latitude) + 
                       ', longitude=' + str(longitude) + 
                       ', organization="' + organization + 
                       '", network="' + network + 
                       '" WHERE id=' + recID + ';')
            try:
                updateGeoIPCursor.execute(updateSql)
            except Exception as e:
              processErrors += 1
              print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - UPDATE log_client SET Statement failed: {color.END}{e}")
              if app.error_details:
                  print(f"Exception details: {e=}, {type(e)=}")        
              showWarnings = app.dbConnection.show_warnings()
              # print(showWarnings)
              loadCursor.callproc("errorLoad",
                                  ["UPDATE log_client SET Statement",
                                   str(showWarnings[0][1]),
                                   showWarnings[0][2],
                                   str(app.importLoadID)])
        app.dbConnection.commit()
        selectGeoIPCursor.close()
        updateGeoIPCursor.close()

    processSeconds = perf_counter() - processStart

    return process_report()
