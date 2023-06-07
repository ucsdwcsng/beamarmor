clear;

nof_db_values = 7;
db_values = [0,5,10,15,20,25,30];
nof_gain_pairs = 1;
sinr_avg = zeros(nof_gain_pairs,nof_db_values);

for i = 1:nof_gain_pairs
    file_name = "sinrVSjammerPower/Setup2/";
    switch i
        case 1
            sub_file_name = file_name+"UE_12and12dBTXandRXgain/";
%         case 1
%             sub_file_name = file_name+"UE_3and3dBTXandRXgain/";
%         case 2
%             sub_file_name = file_name+"UE_10and10dBTXandRXgain/";
    end
    for j = 1:nof_db_values
        sub2_file_name = sub_file_name+num2str(db_values(j))+"dB";
    
        A = readmatrix(sub2_file_name);
        len_t = length(A)/3;
        B = reshape(A, 3, len_t);
        C = B';
        sinr = C(:,1);
        t = 0:1:len_t-1;

        sinr_avg(i,j) = round(mean(sinr,"omitnan")*100)/100;
    end
end
    
y_up_lim = round(max(max(sinr_avg))+2);

plot((1:1:nof_db_values),sinr_avg)
% hold on
% plot(sinr_avg(2,:))

xlabel("Jammer power in dB")
% xticklabels({'0 dB','6 dB','12 dB','18 dB','24 dB','30 dB','31.5 dB'})
xticks(1:1:nof_db_values)
xticklabels({'0','5','10','15','20','25','30'})
xlim([1 nof_db_values])
ylim([0 y_up_lim])
yticks(0:y_up_lim)
ylabel('SINR in dB')
grid on
% legend('UE 3dB TX and RX Gain','UE 10dB TX and RX Gain')
legend('UE 12 dB TX and RX Gain')
% title('UL SINR at basestation')

plot_magic(gcf,gca,'aspect_ratio',[4 3],'pixelDensity',200,'lineWidth',2.6,'fontSize',21);
% Export the figure as a PDF with a transparent background
exportgraphics(gcf, 'figure.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');
