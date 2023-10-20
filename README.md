# BeamArmor and MIMO-RIC

This is a wireless system build on top of srsRAN's 4G software RAN stack.
It contains an O-RAN driven RIC named MIMO-RIC that is specifically geared towards hosting MIMO-related xApps/μApps.
One of these Apps is BeamArmor, which is included in this repo. BeamArmor is a null-steering enabled anti-jamming application that can mitigate the interference effect of jamming signals in UL traffic.

## Installing the repo
Installation is done by building srsRAN in the default manner. Create a build directory inside srsRAN, run cmake ../ and make inside the build directory. The default configuration file enb.conf can be installed from the srsRAN/build/ directory by executing 'srsran_install_configs.sh'.

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
For demonstartion purposes, we recommend to add a timer element of e.g. 30 sec. into the source code and follow these steps:
1. The timer starts and the MIMO-RIC platform begins to regularly extract and send y1 and y2 to the controller. The controller will compute alpha and send the value back to the RAN stack, where it is not yet applied.
2. After alpha has been computed at least once (usually I wait for about 3-5 times to view and compare the output on the console), implement in the source code logic that stops the y1y2_send operation and simply keep the latest computed alpha value. Start the UE, await attachement of 
