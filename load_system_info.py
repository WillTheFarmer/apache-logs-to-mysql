import platform
import sys
import os
#import pwd
print("os.getlogin( )",  os.getlogin( ) )
print("os.path.expanduser('~')", os.path.expanduser('~'))
print("os.environ.get( ' USERNAME' )", os.environ.get( " USERNAME" ))

import subprocess
if platform.system() == 'Windows':
    current_machine_id = subprocess.check_output('wmic csproduct get uuid').decode().split('\n')[1].strip()
else:
    current_machine_id = subprocess.Popen('hal-get-property --udi /org/freedesktop/Hal/devices/computer --key system.hardware.uuid'.split())

print("current_machine_id", current_machine_id)

pid = os.getpid()
print("Process ID:", pid)

import uuid    
print("uuid.UUID(int=uuid.getnode())", uuid.UUID(int=uuid.getnode()))

computer_id = subprocess.check_output("wmic bios get serialnumber").decode().split()[1]
print("computer_id",computer_id)

print("platform.machine()", platform.machine())
print("platform.uname()", platform.uname())
print("platform.platform()", platform.platform())
print("platform.system()", platform.system())
print("platform.release()", platform.release())
print("platform.version()", platform.version())
print("platform.processor()", platform.processor())

def linux_distribution():
  try:
    return platform.linux_distribution()
  except:
    return "N/A"

def dist():
  try:
    return platform.dist()
  except:
    return "N/A"

print("""Python version: %s
dist: %s
linux_distribution: %s
system: %s
machine: %s
platform: %s
uname: %s
version: %s
mac_ver: %s
""" % (
sys.version.split('\n'),
str(dist()),
linux_distribution(),
platform.system(),
platform.machine(),
platform.platform(),
platform.uname(),
platform.version(),
platform.mac_ver(),
))

import socket    
hostname = socket.gethostname()    
IPAddr = socket.gethostbyname(hostname)    
print("Your Computer IP Address is:" + IPAddr) 

def get_device_id():
    system = platform.system()
    if system == "Windows":
        import winreg
        try:
            with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Cryptography") as key:
                return winreg.QueryValueEx(key, "MachineGuid")[0]
        except:
            return "Not Found"
    elif system == "Darwin":
        import subprocess
        return subprocess.check_output("system_profiler SPHardwareDataType | grep 'Serial Number (system)' | awk '{print $4}'", shell=True).decode().strip()
    elif system == "Linux":
        try:
            with open("/etc/machine-id", "r") as f:
                return f.read().strip()
        except:
            return "Not Found"
    else:
        return "Unsupported Platform"

device_id = get_device_id()
print("device_id", device_id)