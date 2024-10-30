#/* ApacheLogs2MySQL 1.0.x (10/19/2024, 7:28:03 AM) (c) http://farmfreshsoftware.com, farmfreshsoftware@gmail.com */
from dotenv import load_dotenv
import os

load_dotenv()  # Loads variables from .env into the environment

# Get the variables
mysql_host = os.getenv('MYSQL_HOST')
mysql_port = os.getenv('MYSQL_PORT')
mysql_user = os.getenv('MYSQL_USER')
mysql_password = os.getenv('MYSQL_PASSWORD')
mysql_schema = os.getenv('MYSQL_SCHEMA')

watch_path = os.getenv('WATCH_PATH')
watch_recursive = bool(int(os.getenv('WATCH_RECURSIVE')))

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


# Print the variables
print(f"Host: {mysql_host}")
print(f"Port: {mysql_port}")
print(f"UserName: {mysql_user}")
print(f"Password: {mysql_password}")
print(f"Schema: {mysql_schema}")

print(f"watch_path: {watch_path}")
print(f"watch_recursive: {watch_recursive}")
#print(watch_recursive)
#print(type(watch_recursive))
#print(int(watch_recursive))
#print(type(int(watch_recursive)))
#print(bool(watch_recursive))
#print(bool(int(watch_recursive)))

print(True)
print(type(True))

print(f"combined: {combined}")
print(f"combined_path: {combined_path}")
print(f"combined_recursive: {combined_recursive}")

print(f"vhost: {vhost}")
print(f"vhost_path: {vhost_path}")
print(f"vhost_recursive: {vhost_recursive}")

print(f"extended: {extended}")
print(f"extended_path: {extended_path}")
print(f"extended_recursive: {extended_recursive}")

print(f"errorlog: {errorlog}")
print(f"errorlog_path: {errorlog_path}")
print(f"errorlog_recursive: {errorlog_recursive}")
