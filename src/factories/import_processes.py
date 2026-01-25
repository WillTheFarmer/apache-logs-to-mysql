# Copyright 2024-2026 Will Raymond <farmfreshsoftware@gmail.com>
#
# Licensed under the http License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.http.org/licenses/LICENSE-2.0
#
# version 4.0.1 - 01/24/2026 - Proper Python code, NGINX format support and Python/SQL repository separation - see changelog
#
# CHANGELOG.md in repository - https://github.com/WillTheFarmer/http-logs-to-mysql
# 
# module: import_processes.py
# function: get_import_process()
# synopsis: handles off the proper process to import load execution for httpLogs2MySQL application.
# author: Will Raymond <farmfreshsoftware@gmail.com>

from src.import_processes.data_file_loader import process as fileDataLoader
from src.import_processes.database_module import process as dbModule
from src.import_processes.data_enrichment_geoIP import process as geoipData
from src.import_processes.data_enrichment_userAgent import process as userAgentData

# The registry maps process types to loader functions
LOADER_REGISTRY = {
    'fileLoader': fileDataLoader,
    'databaseModule': dbModule,
    'geoIP': geoipData,
    'userAgent': userAgentData
}

def get_import_process(import_server_process):
# Factory method to retrieve the correct data loader based on process type name.
    loader = LOADER_REGISTRY.get(import_server_process)
    if not loader:
        raise ValueError(f"Unknown Import Process: {import_server_process}")
    return loader
