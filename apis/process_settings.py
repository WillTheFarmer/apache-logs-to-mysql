class ProcessProperties:
    def __init__(self):
        self.set_defaults() # Initialize on creation

    def set_defaults(self):
        """Sets all instance attributes to their default values."""
        self.filesFound = 0
        self.filesProcessed = 0
        self.recordsProcessed = 0
        self.processErrors = 0
        self.processSeconds = 0.000000
        self.processStart = None
        self.processStatus = None
        # Add all other default attributes here

    def reset(self):
        """Resets the current instance to default values."""
        self.set_defaults()

# import process properties shared among all files in module defs
class properties_dataFileLoader:
    # variables used for sumary of Import Load process - All import processes have the same variables.
    filesFound = 0
    filesProcessed = 0
    recordsProcessed = 0
    processErrors = 0
    processSeconds = 0.000000
    processStart = None
    processStatus = None
    # if each file type requires different back properties this is where to do it.
    backup_days = 0
    backup_path = ''
    # variables used by process_file() and process() methods
    log_format = "none"
    load_table = "none"
    log_path = "."
    log_recursive = False
    display_log = 1
    log_server = "mydomain.com"
    log_serverport = 443
    fileCursor = None
    loadCursor = None

class properties_databaseModule:
    # variables used for sumary of Import Load process - All import processes have the same variables.
    filesFound = 0
    filesProcessed = 0
    recordsProcessed = 0
    processErrors = 0
    processSeconds = 0.000000
    processStart = None
    processStatus = None
    # if each file type requires different back properties this is where to do it.
    backup_days = 0
    backup_path = ''

class properties_dataEnrichment_geoIP:
    # variables used for sumary of Import Load process - All import processes have the same variables.
    filesFound = 0
    filesProcessed = 0
    recordsProcessed = 0
    processErrors = 0
    processSeconds = 0.000000
    processStart = None
    processStatus = None
    # if each file type requires different back properties this is where to do it.
    backup_days = 0
    backup_path = ''

class properties_dataEnrichment_userAgent:
    # variables used for sumary of Import Load process - All import processes have the same variables.
    filesFound = 0
    filesProcessed = 0
    recordsProcessed = 0
    processErrors = 0
    processSeconds = 0.000000
    processStart = None
    processStatus = None
    # if each file type requires different back properties this is where to do it.
    backup_days = 0
    backup_path = ''
