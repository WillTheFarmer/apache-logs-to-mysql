# version 4.0.1 - 01/23/2026 - Proper Python code, NGINX format support and Python/SQL repository separation - see changelog
# application-level properties and references shared across app modules (files) 
from apis.properties_app import app

# Color Class used app-wide for Message Readability in console
from apis.color_class import color

def add_error(message, data):

    app.errorCount += 1

    if data is None:
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - {message}{color.END}")
    else:
        print(f"{color.bg.RED}{color.style.BRIGHT}ERROR - {message}{color.END} : {data}")
        if app.error_details:
            print(f"Exception details: {data=}, {type(data)=}")        

    showWarnings = app.dbConnection.show_warnings()
    # print(showWarnings)
    app.cursor.callproc("errorLoad", [message, str(showWarnings[0][1]), showWarnings[0][2], str(app.importLoadID)])
