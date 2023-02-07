# This script is run on machine wcsng-23.
# Run this FIRST and wait for srsenb to initialize
# Use script "measure_sgnl_pwr_and_incr_theta_null.sh" to start recording samples
# and advancing theta_null and iterate over a set of angles to measure.

# Start srsepc and srsenb. 
# srsenb will read theta_null to calculate pre-coding weight p2.
# theta_null is the angle at which we want to create a null/low signal power.

# Set first angle to 0.
echo "0" > /srsRAN/srsenb/src/phy/lte/theta_null.txt &
# Start srsenb and srsepc
sudo srsRAN/build/srsepc/src/srsepc &
sleep 3
sudo srsRAN/build/srsenb/src/srsenb &