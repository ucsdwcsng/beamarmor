# This script is run on machine wcsng-24.
# Run this SECOND
# Use script "start_srs.sh" to start transmission from srsenb.

# Start collecting samples at a USRP with srsRAN DL center frequency (2.68 GHz)
# and 10 MHz BW (50 PRB) and advance theta_null. Python script will iterate 
# over all angles 1° apart at once per second frequency. Wait 1 second (10 M samples)
# before iterating theta_null.

# Start recording samples
uhd_rx_cfile -f 2680M -r 10M -N 3610M pwr_measure_all_angles &
# Wait long enough for USRP to initialize
sleep 4
# Start python script to increment over angles of theta_null
python3 set_theta_null.py