"""
This script declares a set of angles which will one after the other be used as theta_null.
In equally long time intervals a value for theta_null will be written into "theta_null.txt".
"""
import time

for angle in range(0,359):
    print("Setting angle to "+str(angle)+"°")
    with open('./srsRAN/lib/src/phy/mimo/theta_null.txt', 'w') as f:
        f.write(str(angle))
    time.sleep(1)