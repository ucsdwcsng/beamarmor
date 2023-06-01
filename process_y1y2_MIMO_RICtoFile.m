clear;

% Read y1 and y2 from file and write to complex vector
fid = fopen('y1y2_milcom/ueON_3and3dBTXandRXgain/jammer30dB/y1_0.txt', 'r');
data = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
cell_array = data{1};
y1 = cellfun(@str2num, cell_array, 'UniformOutput', false);
y1= cat(1, y1{:});

fid = fopen('y1y2_milcom/ueON_3and3dBTXandRXgain/jammer30dB/y2_0.txt', 'r');
data = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
cell_array = data{1};
y2 = cellfun(@str2num, cell_array, 'UniformOutput', false);
y2= cat(1, y2{:});

fs = 11.52e6;  % Sampling frequency

%% y1
% Compute FFT
N = length(y1);
Y1 = fft(y1)/N;
Y1mag = abs(Y1);  % Magnitude of complex spectrum
f1 = (0:N-1)*fs/N;  % Frequency vector

%% y2
% Compute FFT
N = length(y2);
Y2 = fft(y2)/N;
Y2mag = abs(Y1);  % Magnitude of complex spectrum
f2 = (0:N-1)*fs/N;  % Frequency vector

% Plot spectrum
figure;
subplot(1,2,1)
plot(f1, Y1mag);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(1,2,2)
plot(f2, Y2mag);
xlabel('Frequency (Hz)');
ylabel('Magnitude');