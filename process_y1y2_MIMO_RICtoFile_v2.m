clearvars;

% Read y1 and y2 from file and write to complex vector
tti  = 2;
% jammer_level_list = [-1, 0, 30];
jammer_level_list = [0,5,10,15,20,25,30];
% jammer_folder = {"noise_level", "jammerOFF", "jammer30dB"}
jammer_folder = {"jammer0dB","jammer5dB","jammer10dB","jammer15dB","jammer20dB","jammer25dB","jammer30dB"};
y1vec=[];
y2vec=[];
for jid = 1:length(jammer_level_list)
%     switch jid
%         case 1
            jammer_db = jammer_level_list(jid);
            % fid = fopen(sprintf("y1y2_milcom/Setup2/"+jammer_folder{jid}+"/y1_%d.txt", tti), 'r');
            fid = fopen(sprintf("y1y2_milcom/Setup2/ueOFF/"+jammer_folder{jid}+"/y1_%d.txt", tti), 'r');
            data = textscan(fid, '%s', 'Delimiter', '\n');
            fclose(fid);
            cell_array = data{1};
            y1 = cellfun(@str2num, cell_array, 'UniformOutput', false);
            y1= cat(1, y1{:});
        
            % fid = fopen(sprintf("y1y2_milcom/Setup2/"+jammer_folder{jid}+"/y2_%d.txt", tti), 'r');
            fid = fopen(sprintf("y1y2_milcom/Setup2/ueOFF/"+jammer_folder{jid}+"/y2_%d.txt", tti), 'r');
            data = textscan(fid, '%s', 'Delimiter', '\n');
            fclose(fid);
            cell_array = data{1};
            y2 = cellfun(@str2num, cell_array, 'UniformOutput', false);
            y2= cat(1, y2{:});
%         otherwise
%             jammer_db = jammer_level_list(jid);
%             fid = fopen(sprintf("y1y2_milcom/Setup2/ueON_12and12dBTXandRXgain/"+jammer_folder{jid}+"/y1_%d.txt", tti), 'r');
%             data = textscan(fid, '%s', 'Delimiter', '\n');
%             fclose(fid);
%             cell_array = data{1};
%             y1 = cellfun(@str2num, cell_array, 'UniformOutput', false);
%             y1= cat(1, y1{:});
%         
%             fid = fopen(sprintf("y1y2_milcom/Setup2/ueON_12and12dBTXandRXgain/"+jammer_folder{jid}+"/y2_%d.txt", tti), 'r');
%             data = textscan(fid, '%s', 'Delimiter', '\n');
%             fclose(fid);
%             cell_array = data{1};
%             y2 = cellfun(@str2num, cell_array, 'UniformOutput', false);
%             y2= cat(1, y2{:});
%     end
    
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
    Y2db(jid,:) = db((Y2));  % Magnitude of complex spectrum
    % f2 = (0:N-1)*fs/N;  % Frequency vector
    ff=(-N/2:N/2-1)*fs/N;
%     switch jid
%         case 1
%             leglist{jid} = sprintf("Noise Level");
%         case 2
%             leglist{jid} = sprintf("UE UL traffic on, Jammer off");
%         otherwise
            leglist{jid} = sprintf("UE UL traffic on, Jammer=%ddB", jammer_level_list(jid));
%     end
    
    % Plot spectrum
end
figure(6);clf;
% Set the background color of the figure to be transparent
% set(gcf, 'color', 'none');
% for jid = 1:length(jammer_level_list)
subplot(1,2,1)
plot(ff*1e-6, Y1db);
hold on; grid on;
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
title('Spectrum for y1')
legend(leglist)
set(gca, 'fontsize', 16)
ylim([-130 -40])

plot_magic(gcf,gca,'aspect_ratio',[8 3],'pixelDensity',200,'lineWidth',1.6,'fontSize',21);

subplot(1,2,2)
plot(ff*1e-6, Y2db);
hold on; grid on;
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
title('Spectrum for y2')
legend(leglist)
set(gca, 'fontsize', 16)
ylim([-130 -40])
%sgtitle("Spectrum for Rx samples y1, y2")

% end
plot_magic(gcf,gca,'aspect_ratio',[8 3],'pixelDensity',200,'lineWidth',1.6,'fontSize',21);

% Export the figure as a PDF with a transparent background
% exportgraphics(gcf, 'figure.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');