clear;

nof_ms = 5; % Number of measurements
nof_sets = 5; % Number of sets (different TTIs or no ZMQ)
sinr_avg_allMs = zeros(nof_sets,nof_ms);
brate_avg_allMs = zeros(nof_sets,nof_ms);
bler_avg_allMs = zeros(nof_sets,nof_ms);

file_name = "100xDS/";

for i = 1:nof_sets
    switch i
        case 1
            sub_file_name = "no_ZMQ_comm/";
        case 2
%             sub_file_name = "1_in_100_TTI_noDownsampling/";
            sub_file_name = file_name+"1_in_1000TTI/";
%             sub_file_name = "1_in_10_TTI/downsampled10x/";
        case 3
%             sub_file_name = "1_in_10_TTI/downsampled10x/";
            sub_file_name = file_name+"1_in_100TTI/";
%             sub_file_name = "1_in_5_TTI_downsampled100x/";
        case 4
%             sub_file_name = "1_in_5_TTI_downsampled100x/";
            sub_file_name = file_name+"1_in_10TTI/";
%             sub_file_name = "everyTTI_downsampled1000x/";
        case 5
            sub_file_name = file_name+"1_in_5TTI/";
    end
    for j = 1:nof_ms
        sub2_file_name = sub_file_name+"m"+num2str(j)+".txt";
        A = readmatrix(sub2_file_name);
        len_t = length(A)/3; 
        B = reshape(A, 3, len_t);
        C = B';
        sinr = C(:,1);
        brate = C(:,2);
        bler = C(:,3);
        t = 0:1:len_t-1;
        
        % Averages
        sinr_avg = round(mean(sinr,"omitnan")*100)/100;
        brate_avg = round(mean(brate))/1e6;
        bler_avg = round(mean(bler)*100)/100;
%         sinr_and_bler_avg = "M"+num2str(j)+" | SINR mean: "+num2str(sinr_avg)+...
%             " | BLER mean: "+num2str(bler_avg);
        sinr_avg_allMs(i,j) = sinr_avg;
        brate_avg_allMs(i,j) = brate_avg;
        bler_avg_allMs(i,j) = bler_avg;
    end
end

y1_up_lim = round(max(max(sinr_avg_allMs))+3);
y1_low_lim = round(min(min(sinr_avg_allMs))-3);

figure;
boxplot(sinr_avg_allMs')
if y1_low_lim < 0
    ylim([0, y1_up_lim])
else
    ylim([y1_low_lim, y1_up_lim])
end
yticks(y1_low_lim:2:y1_up_lim)
ylabel('SINR in dB')
grid on
set(gca, 'xticklabel', {'No ZMQ Comm', '1 in 1000 TTI','1 in 100 TTI','1 in 10 TTI','1 in 5 TTI'})
% set(gca, 'xticklabel', {'No ZMQ Comm', '1 in 100 TTIs, no DS',...
%     '1 in 10 TTIs, 10x DS', '1 in 5 TTIs, 100x DS'})
% set(gca, 'xticklabel', {'No ZMQ Comm','1 in 10 TTIs, 10x DS',...
%     '1 in 5 TTIs, 100x DS','Every TTI, 1000x DS'})
title('SINR for various ZMQ comm. periodicities')
% title('SINR for various ZMQ comm. periodicities')

plot_magic(gcf,gca,'aspect_ratio',[4 3],'pixelDensity',200,'lineWidth',2.6,'fontSize',21);
export_fig("sinr",'-png','-pdf','-transparent', gcf)

figure;
boxplot(brate_avg_allMs')
ylim([0, 14])
yticks(0:1:14)
ylabel('Throughput in Mbit/s')
grid on
set(gca, 'xticklabel', {'No ZMQ Comm', '1 in 1000 TTI','1 in 100 TTI','1 in 10 TTI','1 in 5 TTI'})
% set(gca, 'xticklabel', {'No ZMQ Comm', '1 in 100 TTIs, no DS',...
%     '1 in 10 TTIs, 10x DS', '1 in 5 TTIs, 100x DS'})
% set(gca, 'xticklabel', {'No ZMQ Comm','1 in 10 TTIs, 10x DS',...
%     '1 in 5 TTIs, 100x DS','Every TTI, 1000x DS'})
title('Throughput for various ZMQ comm. periodicities')
% title('Throughput for various ZMQ comm. periodicities')

plot_magic(gcf,gca,'aspect_ratio',[4 3],'pixelDensity',200,'lineWidth',2.6,'fontSize',21);
export_fig("throughput",'-png','-pdf','-transparent', gcf)

figure;
boxplot(bler_avg_allMs')
ylim([0, 100])
yticks(0:10:100)
ylabel('BLER in %')
grid on
set(gca, 'xticklabel', {'No ZMQ Comm', '1 in 1000 TTI','1 in 100 TTI','1 in 10 TTI','1 in 5 TTI'})
% set(gca, 'xticklabel', {'No ZMQ Comm', '1 in 100 TTIs, no DS',...
%     '1 in 10 TTIs, 10x DS', '1 in 5 TTIs, 100x DS'})
% set(gca, 'xticklabel', {'No ZMQ Comm','1 in 10 TTIs, 10x DS',...
%     '1 in 5 TTIs, 100x DS','Every TTI, 1000x DS'})
title('BLER for various ZMQ comm. periodicities')
% title('BLER for various ZMQ comm. periodicities')

plot_magic(gcf,gca,'aspect_ratio',[4 3],'pixelDensity',200,'lineWidth',2.6,'fontSize',21);
export_fig("bler",'-png','-pdf','-transparent', gcf)


% title(sinr_and_bler_avg);
