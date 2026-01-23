# version 4.0.1 - 01/23/2026 - Proper Python code, NGINX format support and Python/SQL repository separation - see changelog
#
# function: copy_backup_file
# synopsis: if file already been imported but still found in a GLOB directory search repeatedly. This option removes it.
# author: Will Raymond <farmfreshsoftware@gmail.com>

from os import path
import shutil
from os import makedirs
from os import remove

# application-level properties and references shared across app modules (files) 
from apis.properties_app import app

# application-level error handle
from apis.error_app import add_error

# Color Class used app-wide for Message Readability in console
from apis.color_class import color

def test_message(messageFrom):
    print(f"From:{messageFrom} Backup Days:{app.backup_days} | DeviceID:{app.importDeviceID} | LoadID:{app.importLoadID} | Backup Path: {app.backup_path}")
    
def copy_backup_file(log_path_file, log_days):

    dbCursor = app.dbConnection.cursor()
    
    fileCopied = False
    if app.backup_days > 0 and log_days > app.backup_days:
        log_relpath = path.relpath(log_path_file, app.watch_path)
        copy_path =  path.join(app.backup_path, log_relpath)
        try:
            makedirs(path.dirname(copy_path), exist_ok=True)
       
            try:
                shutil.copy2(log_path_file, copy_path)
                print(color.fg.GREEN +
                      color.style.NORMAL +
                      "Copied file to : " +
                      copy_path +
                      color.END)
                fileCopied = True
            except FileNotFoundError:
                print(color.bg.RED + color.style.BRIGHT + 'ERROR - Source file not found: ' + log_path_file + color.END)
                dbCursor.callproc("errorLoad",
                                  ["copy_backup_file(log_path_file, log_days)",
                                   '8888',
                                   "Source file not found: " + log_path_file,
                                   str(app.importLoadID)])
            except PermissionError:
                print(color.bg.RED + 
                      color.style.BRIGHT + 
                      'ERROR - Permission denied: Cannot copy ' + 
                      log_path_file + 
                      color.END)
                dbCursor.callproc("errorLoad",
                                  ["copy_backup_file(log_path_file, log_days)",
                                   '8888',
                                   "Permission denied: Cannot copy " + log_path_file,
                                   str(app.importLoadID)])
            except shutil.SameFileError:
                print(color.bg.RED + color.style.BRIGHT + 'ERROR - Source and destination are the same file - ' + log_path_file + color.END)
                dbCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Source and destination are the same file - " + log_path_file,str(app.importLoadID)])
            except OSError as e:
                print(color.bg.RED + color.style.BRIGHT + 'ERROR - Error copying file: ' + log_path_file + color.END, e)
                dbCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Error copying file: " + log_path_file,str(app.importLoadID)])

        except FileExistsError:
             print(color.bg.RED + color.style.BRIGHT + 'ERROR - One or more directories in ' + log_path_file + ' already exist.' + color.END)
             dbCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"One or more directories in " + log_path_file + " already exist.",str(app.importLoadID)])
        except PermissionError:
             print(color.bg.RED + color.style.BRIGHT + 'ERROR - Permission denied: Unable to create ' + log_path_file + color.END)
             dbCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"Permission denied: Unable to create  " + log_path_file,str(app.importLoadID)])
        except Exception as e:
              print(color.bg.RED + color.style.BRIGHT + 'ERROR - An error occurred: ' + log_path_file + color.END, e)
              dbCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"An error occurred: " + log_path_file,str(app.importLoadID)])
    if app.backup_days == -1 or fileCopied:
        try:
            remove(log_path_file)
            print(color.bg.CYAN + color.style.BRIGHT + "Deleted file : " + log_path_file + color.END)
        except Exception as e:
            print(color.bg.RED + color.style.BRIGHT + 'ERROR - An error occurred deleting file: ' + log_path_file + color.END, e)
            dbCursor.callproc("errorLoad",["copy_backup_file(log_path_file, log_days)",'8888',"An error occurred deleting file: " + log_path_file,str(app.importLoadID)])
              
def update_value(current_value):
    # Do some operations
    current_value += 1
    return current_value