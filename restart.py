import os
import psutil
import ctypes
import sys
  
kernel = ctypes.windll.kernel32
    
# Gracefully shut down the server
# pid = int(sys.argv[1])
# kernel.FreeConsole()
# kernel.AttachConsole(pid)
# kernel.SetConsoleCtrlHandler(None, 1)
# kernel.GenerateConsoleCtrlEvent(0, 0)
def main():
    # PROCNAME = 'VRisingServer.exe'
    for each_process in psutil.process_iter():
        print (each_process)
        # try:
        #     # Check if process name contains the given name string.
        #     if processName.lower() in proc.name().lower():
        #         print("exists")
        # except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
        #     pass

if __name__ == '__main__':
    main()