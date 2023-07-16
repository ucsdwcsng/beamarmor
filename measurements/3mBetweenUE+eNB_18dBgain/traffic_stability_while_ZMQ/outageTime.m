clear;

nof_ms = 5; % Number of measurements
nof_sets = 5; % Number of sets (different TTIs or no ZMQ)
outage_percentages = zeros(1,nof_sets);

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

    t_allMs = 0; % Accumulated time (sec) measured for one periodicity
    nof_outages = 0; % # of times BLER = 100%

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
        
        t_allMs = t_allMs+len_t;
        nof_outages = nof_outages+sum(bler==100);

    end
    outage_percentages(i) = (nof_outages/t_allMs)*100;
end

% y1_up_lim = round(max(max(sinr_avg_allMs))+3);
% y1_low_lim = round(min(min(sinr_avg_allMs))-3);

figure;
plot(outage_percentages,'-o')
xticks(1:1:5)
% if y1_low_lim < 0
%     ylim([0, y1_up_lim])
% else
%     ylim([y1_low_lim, y1_up_lim])
% end
% yticks(y1_low_lim:1:y1_up_lim)
ylim([0 50])
yticks(0:5:50)
ylabel('Outage time in %')
grid on
set(gca, 'xticklabel', {'No ZMQ Comm', '1 in 1000 TTI','1 in 100 TTI','1 in 10 TTI','1 in 5 TTI'})
% set(gca, 'xticklabel', {'No ZMQ Comm', '1 in 100 TTIs, no DS',...
%     '1 in 10 TTIs, 10x DS', '1 in 5 TTIs, 100x DS'})
% set(gca, 'xticklabel', {'No ZMQ Comm','1 in 10 TTIs, 10x DS',...
%     '1 in 5 TTIs, 100x DS','Every TTI, 1000x DS'})
%title('Amount of radio-link failure time')
% title('SINR for various ZMQ comm. periodicities')

plot_magic(gcf,gca,'aspect_ratio',[4 3],'pixelDensity',200,'lineWidth',2.6,'fontSize',16);
exportgraphics(gcf, 'figure.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');
%export_fig("outage",'-png','-pdf','-transparent', gcf)