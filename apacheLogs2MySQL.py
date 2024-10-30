# coding: utf-8
# version 1.0.0 - 10/31/2024 - http://farmfreshsoftware.com
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
"""
:module: apacheLogs2MySQL
:function: processLogs()
:synopsis: processes apache access and error logs into MySQL.
:author: farmfreshsoftware@gmail.com (Will Raymond)
"""
import os
import pymysql
import glob
from dotenv import load_dotenv
from user_agents import parse
import time
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
combined = int(os.getenv('COMBINED'))
combined_path = os.getenv('COMBINED_PATH')
combined_recursive = bool(int(os.getenv('COMBINED_RECURSIVE')))
combined_log = int(os.getenv('COMBINED_LOG'))
vhost = int(os.getenv('VHOST'))
vhost_path = os.getenv('VHOST_PATH')
vhost_recursive = bool(int(os.getenv('VHOST_RECURSIVE')))
vhost_log = int(os.getenv('VHOST_LOG'))
extended = int(os.getenv('EXTENDED'))
extended_path = os.getenv('EXTENDED_PATH')
extended_recursive = bool(int(os.getenv('EXTENDED_RECURSIVE')))
extended_log = int(os.getenv('EXTENDED_LOG'))
useragent = int(os.getenv('USERAGENT'))
useragent_log = int(os.getenv('USERAGENT_LOG'))
# Database connection parameters
db_params = {
    'host': mysql_host,
    'port': mysql_port,
    'user': mysql_user,
    'password': mysql_password,
    'database': mysql_schema,
    'local_infile': True
 }
def processLogs():
    import os # module is not accessible from import above. for some reason... module is not available inside function.  
    start_time = time.time()
    conn = pymysql.connect(**db_params)
    errorDataLoaded = 0
    combinedDataLoaded = 0
    vhostDataLoaded = 0
    extendedDataLoaded = 0
    if errorlog == 1:
        print('Checking for Error Logs to Import...')
        errorExistsCursor = conn.cursor()
        errorInsertCursor = conn.cursor()
        errorLoadCursor = conn.cursor()
        for errorFile in glob.glob(errorlog_path, recursive=errorlog_recursive):
            errorLoadFile = errorFile.replace(os.sep, os.sep+os.sep)
            errorExistsSQL = "SELECT apache_logs.importFileExists('" + errorLoadFile + "');"
            errorExistsCursor.execute( errorExistsSQL )
            errorExistsTuple = errorExistsCursor.fetchall()
            errorExists = errorExistsTuple[0][0]
            if errorExists == 0:
                errorDataLoaded = 1
                print('Loading Error log - ' + errorFile )
                errorLoadSQL = "LOAD DATA LOCAL INFILE '" + errorLoadFile + "' INTO TABLE error_log_default FIELDS TERMINATED BY ']' ESCAPED BY '\\\\'"
                errorLoadCursor.execute( errorLoadSQL )
                errorInsertSQL = "SELECT apache_logs.importFileID('" + errorLoadFile + "');"
                errorInsertCursor.execute( errorInsertSQL )
                errorInsertTupleID = errorInsertCursor.fetchall()
                errorInsertFileID = errorInsertTupleID[0][0]
                errorLoadCursor.execute("UPDATE error_log_default SET importfileid=" + str(errorInsertFileID) + " WHERE importfileid IS NULL")
                conn.commit()
        if errorDataLoaded == 1:
            errorLoadCursor.execute("update apache_logs.error_log_default SET module = SUBSTR(log_mod_level,3,(POSITION(':' IN log_mod_level)-3))")
            errorLoadCursor.execute("update apache_logs.error_log_default SET loglevel = SUBSTR(log_mod_level,(POSITION(':' IN log_mod_level)+1))")
            errorLoadCursor.execute("update apache_logs.error_log_default SET processid = SUBSTR(log_processid_threadid,(POSITION('pid' IN log_processid_threadid)+4),(POSITION(':' IN log_processid_threadid)-(POSITION('pid' IN log_processid_threadid)+4)))")
            errorLoadCursor.execute("update apache_logs.error_log_default SET threadid = SUBSTR(log_processid_threadid,(POSITION('tid' IN log_processid_threadid)+4))")
            errorLoadCursor.execute("update apache_logs.error_log_default SET apachecode = SUBSTR(log_parse1,2,(POSITION(':' IN log_parse1)-2)) WHERE LEFT(log_parse1,2)=' A'")
            errorLoadCursor.execute("update apache_logs.error_log_default SET apachemessage = SUBSTR(log_parse1,(POSITION(':' IN log_parse1)+1)) WHERE LEFT(log_parse1,2)=' A'")
            errorLoadCursor.execute("update apache_logs.error_log_default SET apachecode = SUBSTR(log_parse2,2,(POSITION(':' IN log_parse2)-2)) WHERE LEFT(log_parse2,2)=' A'")
            errorLoadCursor.execute("update apache_logs.error_log_default SET apachemessage = SUBSTR(log_parse2,(POSITION(':' IN log_parse2)+1)) WHERE LEFT(log_parse2,2)=' A' and POSITION('referer:' IN log_parse2)=0")
            errorLoadCursor.execute("update apache_logs.error_log_default SET apachemessage = SUBSTR(log_parse2,(POSITION(':' IN log_parse2)+1),POSITION(', referer:' IN log_parse2)-(POSITION(':' IN log_parse2)+1)) WHERE LEFT(log_parse2,2)=' A' and POSITION(', referer:' IN log_parse2)>0")
            errorLoadCursor.execute("update apache_logs.error_log_default SET apachecode = SUBSTR(log_parse1,(POSITION(': AH' IN log_parse1)+2),LOCATE(':',log_parse1,(POSITION(': AH' IN log_parse1)+2))-(POSITION(': AH' IN log_parse1)+2)) WHERE POSITION(': AH' IN log_parse1)>0")
            errorLoadCursor.execute("update apache_logs.error_log_default SET apachemessage = SUBSTR(log_parse1,LOCATE(':',log_parse1,POSITION(': AH' IN log_parse1)+2)+2) WHERE POSITION(': AH' IN log_parse1)>0")
            errorLoadCursor.execute("update apache_logs.error_log_default SET reqclient = SUBSTR(log_parse1,(POSITION('[client' IN log_parse1)+8)) WHERE POSITION('[client' IN log_parse1)>0")
            errorLoadCursor.execute("update apache_logs.error_log_default SET systemcode = SUBSTR(log_parse1,POSITION('(' IN log_parse1),LOCATE(':',log_parse1,POSITION('(' IN log_parse1))-POSITION('(' IN log_parse1)) WHERE POSITION('(' IN log_parse1)>0 AND LOCATE(':',log_parse1,POSITION('(' IN log_parse1))-POSITION('(' IN log_parse1)>0")
            errorLoadCursor.execute("update apache_logs.error_log_default SET systemmessage = SUBSTR(log_parse1,POSITION(':' IN log_parse1) + 1) WHERE POSITION('(' IN log_parse1)>0 AND LOCATE(':',log_parse1,POSITION('(' IN log_parse1))-POSITION('(' IN log_parse1)>0 AND apachecode IS NULL")
            errorLoadCursor.execute("update apache_logs.error_log_default SET log_message_nocode = log_parse1 WHERE systemcode IS NULL and apachecode IS NULL")
            errorLoadCursor.execute("update apache_logs.error_log_default SET module = SUBSTR(log_parse1,2,(POSITION(':' IN log_parse1)-2)) WHERE systemcode IS NULL and apachecode IS NULL and LENGTH(module)=0 AND POSITION(':' IN log_parse1)>0 AND LOCATE(' ',log_parse1,2)>POSITION(':' IN log_parse1)")
            errorLoadCursor.execute("update apache_logs.error_log_default SET logmessage = SUBSTR(log_parse1,(POSITION(':' IN log_parse1)+1)) WHERE systemcode IS NULL and apachecode IS NULL AND POSITION(':' IN log_parse1)>0 AND LOCATE(' ',log_parse1,2)>POSITION(':' IN log_parse1)")
            errorLoadCursor.execute("update apache_logs.error_log_default SET logmessage = log_message_nocode WHERE logmessage IS NULL and log_message_nocode IS NOT NULL")
            errorLoadCursor.execute("update apache_logs.error_log_default SET referer = SUBSTR(log_parse2,(POSITION('referer:' IN log_parse2)+8)) WHERE POSITION('referer:' IN log_parse2)>0")
            errorLoadCursor.execute("update apache_logs.error_log_default SET logtime = STR_TO_DATE(SUBSTR(log_time,2,31),'%a %b %d %H:%i:%s.%f %Y')")
            errorLoadCursor.execute("update apache_logs.error_log_default SET module=TRIM(module), loglevel=TRIM(loglevel), processid=TRIM(processid), threadid=TRIM(threadid), apachecode=TRIM(apachecode), systemcode=TRIM(systemcode), systemmessage = TRIM(systemmessage), logmessage=TRIM(logmessage), reqclient=TRIM(reqclient), referer=TRIM(referer)")
            conn.commit()
            # Processing loaded data
            print('Processing Error Logs...')
            errorProcedureCursor = conn.cursor()
            errorProcedureCursor.callproc("import_error_log",["default"])
            print(conn.show_warnings())
            # Commit and close
            conn.commit()
            errorProcedureCursor.close()
            print('Error Logs import completed.')
        errorInsertCursor.close()
        errorLoadCursor.close()
        errorExistsCursor.close()
    if combined == 1:
        # starting load and process of access logs - combined and common
        print('Checking for Combined Access Log to Import...')
        combinedExistsCursor = conn.cursor()
        combinedInsertCursor = conn.cursor()
        combinedLoadCursor = conn.cursor()
        for combinedFile in glob.glob(combined_path, recursive=combined_recursive):
            combinedLoadFile = combinedFile.replace(os.sep, os.sep+os.sep)
            combinedExistsSQL = "SELECT apache_logs.importFileExists('" + combinedLoadFile + "');"
            combinedExistsCursor.execute( combinedExistsSQL )
            combinedExistsTuple = combinedExistsCursor.fetchall()
            combinedExists = combinedExistsTuple[0][0]
            if combinedExists == 0:
                print('Loading Combined Access Log - ' + combinedFile )
                combinedDataLoaded = 1
                combinedLoadSQL = "LOAD DATA LOCAL INFILE '" + combinedLoadFile + "' INTO TABLE access_log_combined FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\\\\'"
                combinedLoadCursor.execute( combinedLoadSQL )
                combinedInsertSQL = "SELECT apache_logs.importFileID('" + combinedLoadFile + "');"
                combinedInsertCursor.execute( combinedInsertSQL )
                combinedInsertTupleID = combinedInsertCursor.fetchall()
                combinedInsertFileID = combinedInsertTupleID[0][0]
                combinedLoadCursor.execute("UPDATE access_log_combined SET importfileid=" + str(combinedInsertFileID) + " WHERE importfileid IS NULL")
                conn.commit()
        if combinedDataLoaded == 1:
            combinedLoadCursor.execute("update apache_logs.access_log_combined SET req_method = SUBSTR(first_line_request,1,(POSITION(' ' IN first_line_request)-1)) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
            combinedLoadCursor.execute("update apache_logs.access_log_combined SET req_uri = SUBSTR(first_line_request,(POSITION(' ' IN first_line_request)+1),LOCATE(' ',first_line_request,(POSITION(' ' IN first_line_request)+1))-(POSITION(' ' IN first_line_request)+1)) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
            combinedLoadCursor.execute("update apache_logs.access_log_combined SET req_protocol = SUBSTR(first_line_request,LOCATE(' ',first_line_request,(POSITION(' ' IN first_line_request)+1))) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
            combinedLoadCursor.execute("update apache_logs.access_log_combined SET req_uri = SUBSTR(req_uri,1,(POSITION('?' IN req_uri)-1)) WHERE POSITION('?' IN req_uri)>0")
            combinedLoadCursor.execute("update apache_logs.access_log_combined SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request' WHERE LEFT(first_line_request,1) NOT RLIKE '^[A-Z]|-'")
            combinedLoadCursor.execute("update apache_logs.access_log_combined SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request' WHERE LEFT(first_line_request,1) RLIKE '^-'")
            conn.commit()
            # Processing loaded data
            print('Processing Combined Access Logs...')
            combinedProcedureCursor = conn.cursor()
            combinedProcedureCursor.callproc("import_access_log",["combined"])
            print(conn.show_warnings())
            # Commit and close
            conn.commit()
            combinedProcedureCursor.close()
            print('Combined Access Logs import completed.')
        combinedInsertCursor.close()
        combinedLoadCursor.close()
        combinedExistsCursor.close()
    if vhost == 1:
        # starting load and process of access logs - combined
        print('Checking for vHost Access Logs to Import...')
        vhostExistsCursor = conn.cursor()
        vhostInsertCursor = conn.cursor()
        vhostLoadCursor = conn.cursor()
        for vhostFile in glob.glob(vhost_path, recursive=vhost_recursive):
            vhostLoadFile = vhostFile.replace(os.sep, os.sep+os.sep)
            vhostExistsSQL = "SELECT apache_logs.importFileExists('" + vhostLoadFile +"');"
            vhostExistsCursor.execute( vhostExistsSQL )
            vhostExistsTuple = vhostExistsCursor.fetchall()
            vhostExists = vhostExistsTuple[0][0]
            if vhostExists == 0:
                print('Loading Vhost Access Log - '+vhostFile)
                vhostDataLoaded = 1
                vhostLoadSQL = "LOAD DATA LOCAL INFILE '" + vhostLoadFile + "' INTO TABLE access_log_vhost FIELDS TERMINATED BY ' ' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\\\\'"
                vhostLoadCursor.execute( vhostLoadSQL )
                vhostInsertSQL = "SELECT apache_logs.importFileID('" + vhostLoadFile + "');"
                vhostInsertCursor.execute( vhostInsertSQL )
                vhostInsertTupleID = vhostInsertCursor.fetchall()
                vhostInsertFileID = vhostInsertTupleID[0][0]
                vhostLoadCursor.execute("UPDATE access_log_vhost SET importfileid=" + str(vhostInsertFileID) + " WHERE importfileid IS NULL")
                conn.commit()
        if vhostDataLoaded == 1:
            vhostLoadCursor.execute("update apache_logs.access_log_vhost SET server_name = SUBSTR(server_name,1,(POSITION(':' IN server_name)-1)) WHERE POSITION(':' IN server_name)>0")
            vhostLoadCursor.execute("update apache_logs.access_log_vhost SET req_method = SUBSTR(first_line_request,1,(POSITION(' ' IN first_line_request)-1)) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
            vhostLoadCursor.execute("update apache_logs.access_log_vhost SET req_uri = SUBSTR(first_line_request,(POSITION(' ' IN first_line_request)+1),LOCATE(' ',first_line_request,(POSITION(' ' IN first_line_request)+1))-(POSITION(' ' IN first_line_request)+1)) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
            vhostLoadCursor.execute("update apache_logs.access_log_vhost SET req_protocol = SUBSTR(first_line_request,LOCATE(' ',first_line_request,(POSITION(' ' IN first_line_request)+1))) WHERE LEFT(first_line_request,1) RLIKE '^[A-Z]'")
            vhostLoadCursor.execute("update apache_logs.access_log_vhost SET req_uri = SUBSTR(req_uri,1,(POSITION('?' IN req_uri)-1)) WHERE POSITION('?' IN req_uri)>0")
            vhostLoadCursor.execute("update apache_logs.access_log_vhost SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request' WHERE LEFT(first_line_request,1) NOT RLIKE '^[A-Z]|-'")
            vhostLoadCursor.execute("update apache_logs.access_log_vhost SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request' WHERE LEFT(first_line_request,1) RLIKE '^-'")
            conn.commit()
            # Processing loaded data
            print('Processing Vhost Access Logs...')
            vhostProcedureCursor = conn.cursor()
            vhostProcedureCursor.callproc("import_access_log",["vhost"])
            print(conn.show_warnings())
            # Commit and close
            conn.commit()
            vhostProcedureCursor.close()
            print('Vhost Access Logs import completed.')
        vhostInsertCursor.close()
        vhostLoadCursor.close()
        vhostExistsCursor.close()
    if extended == 1:
        # starting load and process of access logs - extended
        print('Checking for Extended Access Logs to Import...')
        extendedExistsCursor = conn.cursor()
        extendedInsertCursor = conn.cursor()
        extendedLoadCursor = conn.cursor()
        for extendedFile in glob.glob(extended_path, recursive=extended_recursive):
            extendedLoadFile = extendedFile.replace(os.sep, os.sep+os.sep)
            extendedExistsSQL = "SELECT apache_logs.importFileExists('" + extendedLoadFile + "');"
            extendedExistsCursor.execute( extendedExistsSQL )
            extendedExistsTuple = extendedExistsCursor.fetchall()
            extendedExists = extendedExistsTuple[0][0]
            if extendedExists == 0:
                print('Loading Extended Access Log - ' + extendedFile )
                extendedDataLoaded = 1
                extendedLoadSQL = "LOAD DATA LOCAL INFILE '" + extendedLoadFile + "' INTO TABLE access_log_extended FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\\\\'"
                extendedLoadCursor.execute( extendedLoadSQL )
                extendedInsertSQL = "SELECT apache_logs.importFileID('" + extendedLoadFile + "');"
                extendedInsertCursor.execute( extendedInsertSQL )
                extendedInsertTupleID = extendedInsertCursor.fetchall()
                extendedInsertFileID = extendedInsertTupleID[0][0]
                extendedLoadCursor.execute("UPDATE access_log_extended SET importfileid=" + str(extendedInsertFileID) + " WHERE importfileid IS NULL")
                conn.commit()
        # Commit and close
        if extendedDataLoaded == 1:
            print('Processing Extended Access Logs...')
            extendedProcedureCursor = conn.cursor()
            extendedProcedureCursor.callproc("import_access_log",["extended"])
            print(conn.show_warnings())
            # Commit and close
            conn.commit()
            extendedProcedureCursor.close()
            print('Extended Access Logs import completed.')
        extendedExistsCursor.close()
        extendedInsertCursor.close()
        extendedLoadCursor.close()
    # done with load and process of access and error logs
    # if any access logs were processed check to update useragent if any records added
    if  useragent == 1 and (combinedDataLoaded == 1 or vhostDataLoaded == 1 or extendedDataLoaded ==1):
        print('Checking for access_log_useragent data parsing to process...')
        selectUserAgentCursor = conn.cursor()
        updateUserAgentCursor = conn.cursor()
        selectUserAgentCursor.execute("SELECT id, name FROM `access_log_useragent` WHERE ua_browser IS NULL")
        for x in range(selectUserAgentCursor.rowcount):
            userAgent = selectUserAgentCursor.fetchone()
            recID = str(userAgent[0])
            ua = parse(userAgent[1])
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
            updateSql = 'UPDATE access_log_useragent SET ua="'+str(ua) + '", ua_browser="'+br_family+'", ua_browser_family="'+br_family+'", ua_browser_version="'+br_version+'", ua_os="'+os+'", ua_os_family="'+os_family+'", ua_os_version="'+os_version+'", ua_device="'+dv+'", ua_device_family="'+dv_family+'", ua_device_brand="'+dv_brand+'", ua_device_model="'+dv_model+'" WHERE id='+recID+';'
            updateUserAgentCursor.execute(updateSql)
        # Commit and close
        conn.commit()
        selectUserAgentCursor.close()
        updateUserAgentCursor.close()        
        print('Useragent data parsing completed.')
    conn.close()
    print('Importing of Apache Logs to MySQL completed in %s seconds!' % (time.time() - start_time))

if __name__ == "__main__":
    # This will run if load_and_process.py is executed directly
    print("apacheLogs2MySQL.py is being run directly")
    processLogs()
