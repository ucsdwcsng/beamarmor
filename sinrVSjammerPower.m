clear;

sinr_avg = zeros(2,7);

for i = 1:2
    file_name = "sinrVSjammerPower/";
    switch i
        case 1
            sub_file_name = file_name+"UE_3and3dBTXandRXgain/";
        case 2
            sub_file_name = file_name+"UE_10and10dBTXandRXgain/";
    end
    for j = 1:7
        switch j
            case 1
                sub2_file_name = sub_file_name+"0dB";
            case 2
                sub2_file_name = sub_file_name+"6dB";
            case 3
                sub2_file_name = sub_file_name+"12dB";
            case 4
                sub2_file_name = sub_file_name+"18dB";
            case 5
                sub2_file_name = sub_file_name+"24dB";
            case 6
                sub2_file_name = sub_file_name+"30dB";
            case 7
                sub2_file_name = sub_file_name+"31_5dB";
        end    
    
        A = readmatrix(sub2_file_name);
        len_t = length(A)/3;
        B = reshape(A, 3, len_t);
        C = B';
        sinr = C(:,1);
        t = 0:1:len_t-1;

        sinr_avg(i,j) = round(mean(sinr,"omitnan")*100)/100;
    end
end
    
y_up_lim = round(max(max(sinr_avg))+1);

plot(sinr_avg(1,:))
hold on
plot(sinr_avg(2,:))

xlabel("Jammer power in dB")
xticklabels({'0 dB','6 dB','12 dB','18 dB','24 dB','30 dB','31.5 dB'})
xlim([1 7])
ylim([0, y_up_lim])
yticks(0:y_up_lim)
ylabel('SINR in dB')
grid on
legend('UE 3dB TX and RX Gain','UE 10dB TX and RX Gain')

plot_magic(gcf,gca,'aspect_ratio',[4 3],'pixelDensity',200,'lineWidth',2.6,'fontSize',21);
