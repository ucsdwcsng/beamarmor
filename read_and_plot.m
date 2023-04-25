clear;

figure;

for i = 1:4
    file_name = "beamarmorON_jammer5MHzwidth_31o5dbgain_udpUEtraffic/jammer_OFF_ON_beamarmor_OFF_ON/jammer10MHz/m" ...
    +num2str(i)+"_sinr_cqi.txt";
    A = readmatrix(file_name);
    len_t = length(A)/2;
    B = reshape(A, 2, len_t);
    C = B';
    cqi = C(:,1);
    sinr = C(:,2);
    t = 0:1:len_t-1;
    
    % Averages
    cqi_avg = round(mean(cqi)*100)/100;
    sinr_avg = round(mean(sinr)*100)/100;
    cqi_and_sinr_avg = "M"+num2str(i)+" | CQI mean: "+num2str(cqi_avg)+...
        " | SINR mean: "+num2str(sinr_avg);
    
    y1_up_lim = round(max(sinr)+3);
    y1_low_lim = round(min(sinr)-3);
    y2_up_lim = round(max(cqi)+1);
    y2_low_lim = round(min(cqi)-1);
    
    subplot(2,2,i);
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
    ylabel('SINR')
    yyaxis right
    plot(t, cqi);
    ylim([y2_low_lim, y2_up_lim])
    yticks(y2_low_lim:1:y2_up_lim)
    ylabel('CQI')
    grid on
    title(cqi_and_sinr_avg);
end