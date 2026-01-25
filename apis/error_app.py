# version 4.0.1 - 01/24/2026 - Proper Python code, NGINX format support and Python/SQL repository separation - see changelog
# application-level properties and references shared across app modules (files) 
from apis.properties_app import app

# Color Class used app-wide for Message Readability in console
from apis.color_class import color

# used EXIT if missing required IDs : app.importDeviceID, app.importClientID and app.importLoadID    
import sys

def add_error(moduleName: str, exceptionType: str, message: str, data=None):

    app.errorCount += 1

    errorMessage = f"message - {message}"

    if exceptionType:
        errorMessage = f"Error exceptionType : {exceptionType} - {errorMessage}"
        
    #if data:
    #    print(f"Exception details: {data=}, {type(data)=}")        

    if app.error_details:
        """First MySQL error does not populate warnings. This is a known issue. Just checking behavior messaging"""
        print(f"module = {color.bg.YELLOW}{color.style.BRIGHT}{moduleName}{color.END} " \
              f"exceptionType = {color.bg.YELLOW}{color.style.BRIGHT}{exceptionType}{color.END} " \
              f"message = {color.bg.YELLOW}{color.style.BRIGHT}{message}{color.END} " \
              f"app.importLoadID = {color.bg.YELLOW}{color.style.BRIGHT}{app.importLoadID}{color.END} " \
              f"app.importProcessID = {color.bg.YELLOW}{color.style.BRIGHT}{app.importProcessID}{color.END}")

        # The first MySQL error does not populate warnings. This is a known issue. Just examining behavior
        showWarnings = app.dbConnection.show_warnings()
        showWarningsLen = len(showWarnings)

        if showWarningsLen == 0:
            print(f"errorMessage : {errorMessage}")
        else:
          print(f"Length: {color.bg.YELLOW}{showWarningsLen}{color.END} showWarnings : {color.bg.YELLOW}{showWarnings}{color.END}")

    try:
         app.cursor.callproc("errorLoad", [moduleName, errorMessage, str(app.importLoadID), str(app.importProcessID)])
        
    except Exception as e:
        print(f"Database permissions problem : {e}")
        sys.exit(1) # Exit with error code 1
