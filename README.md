# BeamArmor and MIMO-RIC

This is a wireless system build on top of srsRAN's 4G software RAN stack.
It contains an O-RAN driven RIC named MIMO-RIC that is specifically geared towards hosting MIMO-related xApps/μApps.
One of these Apps is BeamArmor, which is included in this repo. BeamArmor is a null-steering enabled anti-jamming application that can mitigate the interference effect of jamming signals in UL traffic.

## Installing the repo
Installation is done by building srsRAN in the default manner. Create a build directory inside srsRAN, run cmake ../ and make inside the build directory. cmake might output missing modules like for example, msgpack, that have to be installed first before running make. The default configuration file enb.conf can be installed from the srsRAN/build/ directory by executing 'srsran_install_configs.sh'.

## Preparing BeamArmor and MIMO-RIC
Before running the srsRAN base station with MIMO-RIC and BeamArmor, the operation mode of the srsenb must be set to MIMO and the number of ports must be specified. Set tm = 4 and nof_ports = 2 inside the [enb] paragraph of enb.conf (usually installed in home/.config/srsran/).

To turn the MIMO-RIC as well as the BeamArmor App on, one needs to modify the /srsRAN/srsenb/src/phy/txrx.cc source code file. Inisde the run_thread() method one can set the variables mimo_ric_on and beam_armor_on to true to activate the MIMO-RIC and BeamArmor systems respectively.

The controller itself is run in form of the Python script compute_alpha_server.py. Inside the script, one can activate the BeamArmor app by calling the compute_alpha function inside the main function of the script.

## Running the srsenb with MIMO-RIC and BeamArmor
The srsRAN base station can be run by executing the core application srsepc and the base station application srsenb. Execute 'sudo /srsRAN/build/srsepc/src/srsepc ~/.config/srsran/epc.conf' followed by 'sudo /srsRAN/build/srsenb/sc/srsenb ~/.config/srsran/enb.conf' in another terminal.
Execute the Python script inside a 3rd terminal to run the controller by executing 'python3 alpha_compute_server.py'. From now on, the srsenb program communicates at a set periodicity with the MIMO-RIC.

## Parameters of MIMO-RIC
To change the periodicity, look for the function calls 'send_y1y2' and 'poll_alpha' inside the run_thread() method (txrx.cc), and set the if-condition 'if (tti % 50 == 0)' to any value you prefer instead of every 50 TTI.
The MIMO-RIC logic includes sending the IQ samples recevied by antenna ports 1 and 2 of the srsenb to the controller. The down-sampling rate of these IQ samples can be adjusted inside the 'send_y1y2' function in /srsRAN/srsenb/src/phy/txrx.cc. To do so, adjust the increment value of the for-loop 'for (int i = 0; i < (int)sf_len; i += 40). Currently, the down-sampling rate is 40x. When adjusting the down-sampling rate, the variable 'int size = (int)sf_len/10;' must be adjusted accordingly.

## BeamArmor Demo - Best Practice
For demonstartion purposes, we recommend to add two timer elements of e.g. 10 and 30 sec. into the source code file txrx.cc and follow these steps:
1. Both timer start counting down and the MIMO-RIC platform begins to regularly extract and send y1 and y2 to the controller. The controller will compute alpha and send the value back to the RAN stack, where it is not yet applied.
2. After the first timer has elapsed, implement logic in txrx.cc that stops the y1y2_send operation and simply keeps the latest computed alpha value.
3. Start the UE, await attachement, and start UL traffic. When observing the traffic metrics on the console at this point, the jammer influence should be visible through bad SINR, BLER, and throughput.
4. After the second timer has elapsed, implement logic that starts applying the latest alpha value to the UL processing. Now, an impromvemet in the metrics should be visible and thus, verifying BeamArmors nulling effect.

## BeamArmor Demo - Automatic BeamArmor turn ON
In this demo setup, BeamArmor turn on time is set while running the RIC and BeamArmor will turn on automatically. 

### Setup
#### Basestation/eNB setup
eNB setup contains 4 components: 
1. Core network - Open5GS
2. Basestation RAN - srseNB
3. BeamArmor Real-time controller (RIC) - alpha_compute_server.py
4. Data exchange - iperf server

#### User/UE setup
UE setup contains 4 components: 
1. UE RAN - srsUE
2. Data exchange - iperf client

#### Jammer
Jammer setup uses one pendrive containing 5MHz OFDM IQ data which is transmitted continuously in the same UL frequency.

### Phases of Demo
There are three phases in the demo: 
1. Estimating the jammer channel co-efficients - Only basestation and jammer are running.
2. Demonstrating performance without applying beam-nulling - Basestation, jammer and user are running.
3. Demonstrating performance after applying beam-nulling - Basestation, jammer and user are running.

These phases will be controlled from the basestation setup with the BeamArmor RIC.

#### Demo procedure
1. Turn on the jammer and let it transmit data continuously.

2. On the UE PC, create a namespace for data transmission:  
`sudo ip netns add ue1`

This will be useful while trying to run iperf client through srsRAN from UE.

4. Run Open5GS Core:  
`sudo /srsRAN/build/srsepc/src/srsepc ~/.config/srsran/epc.conf`

5. Run srseNB:  
`sudo /srsRAN/build/srsenb/sc/srsenb ~/.config/srsran/enb.conf`

Press 't' on the terminal to enable trace and display metrics.

7. Run BeamArmor RIC:  
`python3 alpha_compute_server.py <Timer 1> <Timer 2>`  

Here Timer 1 and Timer 2 are the wait times in seconds for turning on the three phases of BeamArmor Demo.
##### Timer 1
Only the eNB and jammer are running, UE should not be turned on yet. During this phase, the RIC estimates the channel co-efficients of the jammer given the UE is turned off. 
##### Timer 2
UE is turned on and it connects to the basestation. BeamArmor RIC does not apply beam-nulling yet. This is to demo the performance without BeamArmor. 

Once the Timer 2 expires, beam-nulling is applied and performance with BeamArmor is demostrated.

##### Example
`python3 alpha_compute_server.py 10 40` 

When the alpha_compute_server.py is run, the RIC estimates the channel for 10 seconds. After 10 seconds the UE should be turned on, and the performance without BeamArmor is demonstrated for 40 seconds. Then beam-nulling is applied and the performance improvement from BeamArmor is demonstrated. 

6. Run iperf server:  
`sudo iperf3 -s -i 1`

7. Wait for <Timer 1> seconds and run srsUE:  
`sudo /srsRAN/build/srsenb/sc/srsue ~/.config/srsran/ue.conf`

8. Once the UE connects to the eNB, run iperf client:  
`sudo ip netns exec ue1 iperf3 -c 172.16.0.1 -b 10M -i 1 -t 2000`

The improvement from BeamArmor must be visible once the Timer 2 expires. 

## BeamArmor Demo - Manual BeamArmor turn ON/OFF
In this demo setup, BeamArmor can be turned ON/OFF with a GUI. 

### Setup
#### Basestation/eNB setup
eNB setup contains 4 components: 
1. Core network - Open5GS
2. Basestation RAN - srseNB
3. BeamArmor Real-time controller (RIC) - alpha_compute_server.py
4. Data exchange - iperf server

#### User/UE setup
UE setup contains 4 components: 
1. UE RAN - srsUE
2. Data exchange - iperf client

#### Jammer
Jammer setup uses one pendrive containing 5MHz OFDM IQ data which is transmitted continuously in the same UL frequency.

### Phases of Demo
There are three phases in the demo: 
1. Estimating the jammer channel co-efficients - Only basestation and jammer are running.
2. Demonstrating performance without applying beam-nulling - Basestation, jammer and user are running.
3. Demonstrating performance after applying beam-nulling - Basestation, jammer and user are running.

These phases will be controlled from the basestation setup with the BeamArmor RIC and control GUI.

#### Demo procedure
1. Turn on the jammer and let it transmit data continuously.

2. On the UE PC, create a namespace for data transmission:  
`sudo ip netns add ue1`

This will be useful while trying to run iperf client through srsRAN from UE.

4. Run Open5GS Core:  
`sudo /srsRAN/build/srsepc/src/srsepc ~/.config/srsran/epc.conf`

5. Run srseNB:  
`sudo /srsRAN/build/srsenb/sc/srsenb ~/.config/srsran/enb.conf`

7. Run BeamArmor RIC:  
`python3 alpha_compute_server.py <Timer 1> <Timer 2>`  

Here Timer 1 is the wait times in seconds for estimating the channel of jammer.
##### Timer 1
Only the eNB and jammer are running, UE should not be turned on yet. During this phase, the RIC estimates the channel co-efficients of the jammer given the UE is turned off. 

**Note: A GUI window will open from which BeamArmor can be turned ON or OFF. Try to arrange the GUI at the bottom corner, so that it does not overlap with the metric plots which is programmed to be displayed in the top half of the computer screen.

##### Example
`python3 alpha_compute_server_toggle.py 10` 

When the alpha_compute_server_toggle.py is run, the RIC estimates the channel for 10 seconds. After 10 seconds the UE should be turned on, and the performance without BeamArmor is demonstrated for 40 seconds. Then beam-nulling is applied and the performance improvement from BeamArmor is demonstrated. 

Press 't' in the eNB terminal window to open up metrics from srsRAN and display plots.

**Note: The plots refresh everytime there is a new data point and they plot windows come into focus everytime they refresh, so it might be difficult to access other windows. So try to turn on the metrics after all the necessary commands are run and you need not access the basestation for a significant duration.

6. Run iperf server:  
`sudo iperf3 -s -i 1`

7. Wait for <Timer 1> seconds and run srsUE:  
`sudo /srsRAN/build/srsenb/sc/srsue ~/.config/srsran/ue.conf`

8. Once the UE connects to the eNB, run iperf client:  
`sudo ip netns exec ue1 iperf3 -c 172.16.0.1 -b 10M -i 1 -t 2000`

A GUI should be open up with BeamArmor. You can turn ON/OFF BeamArmor with the button and the metrics should reflect the effect of BeamArmor being ON/OFF. 


