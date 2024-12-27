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
#
# version 2.1.3 - 12/27/2024 - process improvements - see changelog
#
# Copyright 2024 Will Raymond <farmfreshsoftware@gmail.com>
#
# CHANGELOG.md in repository - https://github.com/WillTheFarmer/ApacheLogs2MySQL
"""
:module: watch4logs
:class:: importLogs
:function: processLogs()
:synopsis: Polling for apache logs and calls apacheLogs2MySQL.processLogs().
:author: Will Raymond <farmfreshsoftware@gmail.com>
"""
import time
import os
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from dotenv import load_dotenv
from apacheLogs2MySQL import processLogs
load_dotenv()  # Loads variables from .env into the environment
watch_path = os.getenv('WATCH_PATH')
watch_recursive = bool(int(os.getenv('WATCH_RECURSIVE')))
watch_interval = int(os.getenv('WATCH_INTERVAL'))
watch_log = int(os.getenv('WATCH_LOG'))
class importLogs(FileSystemEventHandler):
  processFiles = 0
  def on_any_event(self, event):
    if event.event_type == 'created' and event.is_directory == False:
      setattr(importLogs, 'processFiles', 1)
      if watch_log >= 1:
        print("@@@@@!!!!!-----File for processing -----!!!!!@@@@@")

if __name__ == "__main__":
  event_handler = importLogs()
  observer = Observer()
  observer.schedule(event_handler, watch_path, recursive=watch_recursive)
  observer.start()
  try:
    while True:
      if watch_log >= 2:
        print("checking for new files")
      if importLogs.processFiles == 1:
        setattr(importLogs, 'processFiles', 0)
        processLogs()
      time.sleep(watch_interval)
  except KeyboardInterrupt:
    observer.stop()
  observer.join()