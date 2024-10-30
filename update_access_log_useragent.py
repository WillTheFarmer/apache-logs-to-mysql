#/* ApacheLogs2MySQL 1.0.x (10/19/2024, 7:28:03 AM) (c) http://farmfreshsoftware.com, farmfreshsoftware@gmail.com */
import pymysql
from user_agents import parse
# Database connection parameters
db_params = {
#    'host': 'localhost',
    'host': 'localhost',
    'user': 'root',
    'password': 'password',
    'database': 'apache_logs'
}
# Connect to database
conn = pymysql.connect(**db_params)
with conn:
    with conn.cursor() as selectCursor:
        # Read a single record
        sql = "SELECT id, name FROM `access_log_useragent`"
        selectCursor.execute(sql)
        nRows = selectCursor.rowcount
        for x in range(selectCursor.rowcount):
            dataRecord = selectCursor.fetchone()
            recID = str(dataRecord[0])
            ua = parse(dataRecord[1])
            # Accessing user agent's browser attributes
            br = str(ua.browser)  # returns Browser(family=u'Mobile Safari', version=(5, 1), version_string='5.1')
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
            with conn.cursor() as updateCursor:
                updateCursor.execute(updateSql)
    # Commit and close
    conn.commit()
    selectCursor.close()
    updateCursor.close()
