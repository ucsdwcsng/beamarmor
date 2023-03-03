% tx_tone_data_gen.m
% Generate iq data to transmit a single complex tone 
% Generate another tone with a phase modulation for 2nd antenna
%
% Author: Ish Jain
% Date created: 2/3/23

tone_freq = 1e6; % Tone frequency
samples_per_phase = 1e4;
N_angles=360;
N_samples = N_angles*samples_per_phase; %Num samples to transmit
fs = 10e6; % Sampling rate
Ts = 1/fs; % Sampling time
time_seq = (1:N_samples)*Ts;
tone_data1 = 0.3*exp(1j*2*pi*tone_freq*time_seq);



% Now generate second antenna data

phase_variation = 1:N_angles; %degree
% phase_modulated_wave = ones(samples_per_phase, N_angles)*
phase_modulated_wave = reshape(repmat(exp(1j*deg2rad(phase_variation)), samples_per_phase,1), N_samples,1);

tone_data2 = tone_data1.*phase_modulated_wave.';


write_complex_binary(tone_data1,'/tmp/tx_data1.iq')
write_complex_binary(tone_data2,'/tmp/tx_data2.iq')

figure(2); clf;
plot(rad2deg(angle(phase_modulated_wave)))