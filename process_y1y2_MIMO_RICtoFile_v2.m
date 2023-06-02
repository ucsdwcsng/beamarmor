clearvars;

% Read y1 and y2 from file and write to complex vector
tti  = 2;
jammer_level_list = [0, 10, 20, 30];
jammer_folder = {"jammerOFF", "jammer10dB", "jammer20dB", "jammer30dB"};
y1vec=[];
y2vec=[];
for jid = 1:length(jammer_level_list)
    jammer_db = jammer_level_list(jid);
    fid = fopen(sprintf("y1y2_milcom/ueON_3and3dBTXandRXgain/"+jammer_folder{jid}+"/y1_%d.txt", tti), 'r');
    data = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    cell_array = data{1};
    y1 = cellfun(@str2num, cell_array, 'UniformOutput', false);
    y1= cat(1, y1{:});

    fid = fopen(sprintf("y1y2_milcom/ueON_3and3dBTXandRXgain/"+jammer_folder{jid}+"/y2_%d.txt", tti), 'r');
    data = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    cell_array = data{1};
    y2 = cellfun(@str2num, cell_array, 'UniformOutput', false);
    y2= cat(1, y2{:});
    
    assert(any(real(y1)<0.5), "Likely saturation y1")
    assert(any(real(y2)<0.5), "Likely saturation y2")
    y1vec(jid,:) = y1;
    y2vec(jid,:) = y2;
end

fs = 11.52e6;  % Sampling frequency


%% Visualize y1, y2: Requires ucsdwcang/utilities path setup correctly
figure(701); clf;
param = fftplot2_param_helper();
param.stft_flag = 0;
param.hold_flag = 1;
jammer_id = 1;
fftplot2(y1vec(jammer_id,:), param);
fftplot2(y2vec(jammer_id,:), param);

%% Compute and plot
% Compute FFT

for jid = 1:length(jammer_level_list)

    y1 = y1vec(jid,:);
    y2 = y2vec(jid,:);
    
    N = length(y1);
    Y1 = fftshift(fft(y1))/N;
    Y1db(jid,:) = db((Y1));  % Magnitude of complex spectrum
    % f1 = (0:N-1)*fs/N;  % Frequency vector

    %%--y2
    % Compute FFT
    N = length(y2);
    Y2 = fftshift(fft(y2))/N;
    Y2db(jid,:) = db((Y1));  % Magnitude of complex spectrum
    % f2 = (0:N-1)*fs/N;  % Frequency vector
    ff=(-N/2:N/2-1)*fs/N;
    leglist{jid} = sprintf("Jammer=%ddB", jammer_level_list(jid));
    % Plot spectrum
end
figure(6);clf;
% for jid = 1:length(jammer_level_list)
subplot(1,2,1)
plot(ff*1e-6, Y1db);
hold on; grid on;
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
title('Spectrum for y1')
legend(leglist)
set(gca, 'fontsize', 16)

subplot(1,2,2)
plot(ff*1e-6, Y2db);
hold on; grid on;
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
title('Spectrum for y2')
legend(leglist)
set(gca, 'fontsize', 16)
sgtitle("Spectrum for Rx samples y1, y2")

% end