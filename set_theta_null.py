"""
This script declares a set of angles which will one after the other be used as theta_null.
In equally long time intervals a value for theta_null will be written into "theta_null.txt".
"""
import time
import os
import subprocess

timestamps = []
time_0 = time.time()

for angle in range(-90,91):
    print("Setting angle to "+str(angle)+"°")
    with open('./srsRAN/srsenb/src/phy/lte/theta_null.txt', 'w') as f:
        f.write(str(angle))
    p = subprocess.Popen(["scp", "-i", "/home/wcsng-24/.ssh/id_rsa_measurements",
        "-P", "2022",
        "./srsRAN/srsenb/src/phy/lte/theta_null.txt",
        "wcsng-23@137.110.198.34:/home/wcsng-23/gitrepos/beam_armor/srsRAN/srsenb/src/phy/lte/theta_null.txt"])
    sts = os.waitpid(p.pid, 0)
    timestamps.append(time.time()-time_0)
    #time.sleep(0.1)

with open('timestamps.txt', 'w') as f:
    for timestamp in timestamps:
        f.write(str(timestamp)+',')