% rx_tone_data_analysis.m

% Analyse the tone data for beam nulling verification


rx_filename = '/tmp/rx_tone_data.iq';

start = 2e6;
count = 180*1e4;
rx_samples = read_complex_binary(rx_filename, count, start);

figure(1); clf;
plot(db(rx_samples))
xlabel('Time samples')
ylabel('Rx signal power dB')