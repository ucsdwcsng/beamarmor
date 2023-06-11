clearvars;

% Read y1 and y2 from file and write to complex vector
% tti  = 23;
% jammer_level_list = [-1, 0, 30];
jammer_level_list = [0,5,10,15,20,25,30];
% jammer_folder = {"noise_level", "jammerOFF", "jammer30dB"}
jammer_folder = {"jammer0dB","jammer5dB","jammer10dB","jammer15dB","jammer20dB","jammer25dB","jammer30dB"};

alphas = zeros(100,length(jammer_level_list));
y1_avg_db = zeros(100,length(jammer_level_list));
y2_avg_db = zeros(100,length(jammer_level_list));
y_ba_avg_db = zeros(100,length(jammer_level_list));

for tti = 0:99
    disp("TTI: "+num2str(tti))
    y1vec=[];
    y2vec=[];
    for jid = 1:length(jammer_level_list)
        jammer_db = jammer_level_list(jid);
        % fid = fopen(sprintf("y1y2_milcom/Setup2/"+jammer_folder{jid}+"/y1_%d.txt", tti), 'r');
        fid = fopen(sprintf("y1y2_milcom/Setup2/ueOFF/singleToneJammer/"+jammer_folder{jid}+"/y1_%d.txt", tti), 'r');
        data = textscan(fid, '%s', 'Delimiter', '\n');
        fclose(fid);
        cell_array = data{1};
        y1 = cellfun(@str2num, cell_array, 'UniformOutput', false);
        y1= cat(1, y1{:});
    
        % fid = fopen(sprintf("y1y2_milcom/Setup2/"+jammer_folder{jid}+"/y2_%d.txt", tti), 'r');
        fid = fopen(sprintf("y1y2_milcom/Setup2/ueOFF/singleToneJammer/"+jammer_folder{jid}+"/y2_%d.txt", tti), 'r');
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
    
%     fs = 11.52e6;  % Sampling frequency
    
    %% Visualize y1, y2: Requires ucsdwcsng/utilities path setup correctly
    % figure(701); clf;
    % param = fftplot2_param_helper();
    % param.stft_flag = 0;
    % param.hold_flag = 1;
    % jammer_id = 1;
    % fftplot2(y1vec(jammer_id,:), param);
    % fftplot2(y2vec(jammer_id,:), param);
    
    %% Compute and plot
    % Compute FFT
    % Y1db_means = zeros(1,length(jammer_level_list));
    % Y2db_means = zeros(1,length(jammer_level_list));
    % Y_ba_db_means = zeros(1,length(jammer_level_list));
    
    for jid = 1:length(jammer_level_list)
    
        y1 = y1vec(jid,:);
        y2 = y2vec(jid,:);
        
        N = length(y1);
        pwr_per_iq_sample = zeros(3,N);
    %     Y1 = fftshift(fft(y1))/N;
    %     Y1db(jid,:) = db((Y1));  % Magnitude of complex spectrum
    %     Y1db_means(jid) = mean(Y1db(jid,:));
    %     % f1 = (0:N-1)*fs/N;  % Frequency vector
    % 
    %     %%--y2
    %     % Compute FFT
    %     N = length(y2);
    %     Y2 = fftshift(fft(y2))/N;
    %     Y2db(jid,:) = db((Y2));  % Magnitude of complex spectrum
    %     Y2db_means(jid) = mean(Y2db(jid,:));
    %     f2 = (0:N-1)*fs/N;  % Frequency vector
    %     ff=(-N/2:N/2-1)*fs/N;
    
        % Compute alpha
        alphas(tti+1,jid) = ((-1)*y2*y1')/(y2*y2');
        % Apply alpha
        y_ba = (y1+alphas(tti+1,jid)*y2);
    
        for i = 1:N
            pwr_per_iq_sample(1,i) = abs(y1(i))^2;
%             pwr_per_iq_sample(2,i) = abs(y2(i))^2;
            pwr_per_iq_sample(3,i) = abs(y_ba(i))^2;
        end
        
        y1_avg_pwr = sum(pwr_per_iq_sample(1,:))/N;
%         y2_avg_pwr = sum(pwr_per_iq_sample(2,:))/N;
        y_ba_avg_pwr = sum(pwr_per_iq_sample(3,:))/(N*(1+abs(alphas(tti+1,jid))^2));
    %     pwr_y1y2_db = pow2db(pwr_per_iq_sample);
        y1_avg_db(tti+1,jid) = pow2db(y1_avg_pwr);
%         y2_avg_db(tti+1,jid) = pow2db(y2_avg_pwr);
        y_ba_avg_db(tti+1,jid) = pow2db(y_ba_avg_pwr);
        
    
    %     % Compute power and mean
    %     N = length(y_ba);
    %     Y_ba = fftshift(fft(y_ba))/N;
    %     Y_ba_db(jid,:) = db((Y_ba));  % Magnitude of complex spectrum
    %     Y_ba_db_means(jid) = mean(Y_ba_db(jid,:));
    end
end

means = [mean(y1_avg_db,1);mean(y_ba_avg_db,1)];
std_vals = [std(y1_avg_db,0,1);std(y_ba_avg_db,0,1)];

figure(6);clf;
% Set the background color of the figure to be transparent
% set(gcf, 'color', 'none');
% for jid = 1:length(jammer_level_list)
% subplot(1,2,1)
% plot(1:length(jammer_level_list), y);
errorbar(1:length(jammer_level_list),means,std_vals,'LineWidth',2)
hold on; grid on;
xlabel('Jammer levels (dB)');
xlim([1 length(jammer_level_list)])
xticks(1:length(jammer_level_list))
xticklabels({'0','5','10','15','20','25','30'})
ylabel('Mean Magnitude (dB)');
title('Single Tone Jammer')
% legend(leglist)
legend('y no BeamArmor','y with BeamArmor')
set(gca, 'fontsize', 16)
% ylim([min(min(y))-10 max(max(y))+10])

plot_magic(gcf,gca,'aspect_ratio',[4 3],'pixelDensity',200,'lineWidth',2.6,'fontSize',21);

% subplot(1,2,2)
% plot(1:length(jammer_level_list), Y2db_means);
% hold on; grid on;
% xlabel('Jammer levels (dB)');
% xlim([1 length(jammer_level_list)])
% xticks(1:length(jammer_level_list))
% xticklabels({'0','5','10','15','20','25','30'})
% ylabel('Mean Magnitude (dB)');
% title('y2')
% % legend(leglist)
% set(gca, 'fontsize', 16)
% ylim([-110 -80])
% %sgtitle("Spectrum for Rx samples y1, y2")

% end
% plot_magic(gcf,gca,'aspect_ratio',[8 3],'pixelDensity',200,'lineWidth',1.6,'fontSize',21);

% Export the figure as a PDF with a transparent background
% exportgraphics(gcf, 'figure.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');