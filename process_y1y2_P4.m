clear;

% Read y1 and y2 from file and write to complex vector
y1_cell = cellfun(@str2num, readcell('../y1.txt'), 'UniformOutput', false);
y2_cell = cellfun(@str2num, readcell('../y2.txt'), 'UniformOutput', false);
y1 = cell2mat(y1_cell);
y2 = cell2mat(y2_cell);

fs = 11.52e6;  % Sampling frequency

%% y1
% Compute FFT
N = length(y1);
Y1 = fft(y1)/N;
Y1mag = abs(Y1);  % Magnitude of complex spectrum
f = (0:N-1)*fs/N;  % Frequency vector

%% y2
% Compute FFT
N = length(y2);
Y2 = fft(y2)/N;
Y2mag = abs(Y1);  % Magnitude of complex spectrum
f = (0:N-1)*fs/N;  % Frequency vector

% Plot spectrum
figure;
subplot(1,2,1)
plot(f, Y1mag);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(1,2,2)
plot(f, Y2mag);
xlabel('Frequency (Hz)');
ylabel('Magnitude');