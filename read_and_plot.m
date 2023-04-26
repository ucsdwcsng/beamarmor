clear;

figure;

for i = 1:3
    file_name = "/home/wcsng-24/Frederik/measurements/ue_enb_various_gains/"...
        +"5db_gain/UDP10Mbits/1in100TTImsg/m"+num2str(i)+"_sinr_brate_bler.txt";
    A = readmatrix(file_name);
    len_t = length(A)/3;
    B = reshape(A, 3, len_t);
    C = B';
    sinr = C(:,1);
    bler = C(:,3);
    t = 0:1:len_t-1;
    
    % Averages
%     cqi_avg = round(mean(cqi)*100)/100;
    sinr_avg = round(mean(sinr,"omitnan")*100)/100;
    bler_avg = round(mean(bler)*100)/100;
    sinr_and_bler_avg = "M"+num2str(i)+" | SINR mean: "+num2str(sinr_avg)+...
        " | BLER mean: "+num2str(bler_avg);
    
    y1_up_lim = round(max(sinr)+3);
    y1_low_lim = round(min(sinr)-3);
%     y2_up_lim = round(max(cqi)+1);
%     y2_low_lim = round(min(cqi)-1);
    
    subplot(1,3,i);
    if len_t <= 16
        xticks(0:2:len_t-1)
    else
        xticks(0:5:len_t-1)
    end
    xlabel("time in seconds")
    yyaxis left
    plot(t, sinr);
    ylim([y1_low_lim, y1_up_lim])
    yticks(y1_low_lim:1:y1_up_lim)
    ylabel('SINR in dB')
    yyaxis right
%     plot(t, );
    scatter(t,bler,20,"red","filled")
%     ylim([y2_low_lim, y2_up_lim])
%     yticks(y2_low_lim:1:y2_up_lim)
    ylim([0, 100])
    yticks(0:5:100)
    ylabel('BLER in %')
    grid on
    legend('SINR','BLER')
    title(sinr_and_bler_avg);
end