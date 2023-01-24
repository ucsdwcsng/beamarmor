# Start collecting samples at a USRP with srsRAN DL center frequency (2.68 GHz)
# and 10 MHz BW (50 PRB) and advance theta_null. Python script will iterate 
# over all angles 1° apart at once per second frequency. Wait 1 second (10 M samples)
# before iterating theta_null.

# Set first angle to 0.
echo "0" > srsRAN/lib/src/phy/mimo/theta_null.txt &
# Start srsenb and srsepc
sudo srsRAN/build/srsepc/src/srsepc &
sleep 2
sudo srsRAN/build/srsenb/src/srsenb &
sleep 3
# Start recording samples
uhd_rx_cfile -f 2680M -r 10M -N 3610M pwr_measure_all_angles &
sleep 1
python3 set_theta_null.py