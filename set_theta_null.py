"""
This script declares a set of angles which will one after the other be used as theta_null.
In equally long time intervals a value for theta_null will be written into "theta_null.txt".
"""
import time
import os
import subprocess

for angle in range(-90,90):
    print("Setting angle to "+str(angle)+"°")
    with open('./srsRAN/lib/src/phy/mimo/theta_null.txt', 'w') as f:
        f.write(str(angle))
    p = subprocess.Popen(["scp", "./srsRAN/lib/src/phy/mimo/theta_null.txt",
     "wcsng-23@137.110.198.34:/home/wcsng-23/gitrepos/beam_armor/srsRAN/lib/src/phy/mimo/theta_null.txt",
      "-P 2022",
       "-i ~/.ssh/id_rsa_measurements"])
    sts = os.waitpid(p.pid, 0)
    time.sleep(1)