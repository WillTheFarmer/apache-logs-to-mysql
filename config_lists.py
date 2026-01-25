# version 4.0.1 - 01/24/2026 - Proper Python code, NGINX format support and Python/SQL repository separation - see changelog
from tabulate import tabulate
# Message Readability in console
from apis.color_class import color
# all starts is here - json process file must exist
from config.config_app import load_file
config = load_file()

if config:
# Four Python modules are passed different parameters to import different log formats
    process_list = []

    print(f"{color.fg.GREEN}Process List{color.fg.YELLOW} - Each record is different parameters passed to 1 of 4 Python Modules - {color.fg.RED}(Module Name){color.END}")
    for process in config['processes']:
#        print(f"Process ID: {process.get("id")}. moduleName: {process.get("moduleName")}")
        attrValues = {}
        processInfo = {"Status": process.get("status"),
                       "Process id": process.get("id"),
                       "Process Group": process.get("group"),
                       "Process Name": process.get("name"),
                       "Module Name": process.get("moduleName")}

        attributes = process.get("attributes")
        if process.get("moduleName") == "fileLoader":
           attrValues = {"Parameter": attributes["path"]} 
#           attrValues = {"Path": attributes["path"],"Recursive": attributes["recursive"]} 
        elif process.get("moduleName") == "databaseModule":
           attrValues = {"Parameter": attributes["dbModuleName"] + " - " + attributes["dbModuleParm1"]} 
#           attrValues = {"Module": attributes["dbModuleName"],"Parameter": attributes["dbModuleParm1"]} 
        
        processInfo.update(attrValues)
        process_list.append(processInfo)

    print(tabulate(process_list, headers='keys', tablefmt='github'))

# Create any number of observers. Each log format will require a separate observer to associate proper import processes. Execute a single LOAD process. Other processes executed somewhere else.
    observer_list = []
    print(f"{color.fg.GREEN}Observer List{color.fg.YELLOW} - Each record is a watchDog Observer Schedule. Each Observer executes associated import processes - {color.fg.RED}(processList){color.END}")
    for observer in config['observers']:
        observerInfo = {"Status": observer.get("status"),
                        "id": observer.get("id"),
                        "name": observer.get("name"),
                        "path": observer.get("path"),
                        "recursive": observer.get("recursive"),
                        "interval":  observer.get("interval"),
                        "processList": observer.get("processList")}

        observer_list.append(observerInfo)

    print(tabulate(observer_list, headers='keys', tablefmt='github'))
