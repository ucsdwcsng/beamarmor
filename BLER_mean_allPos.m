clear;

% General
nof_positions = 3;
nof_ms = 5;
bler_avg = zeros(2,2,nof_ms*nof_positions);
file_name = "measurements/6mBetweenUE+eNB_18dBgain/";

for i = 1:2 % i = 1: singleTone. i = 2: wideBand
    if i == 2
        sub1_file_name = file_name+"5MHz30dBJammer/";
    else
        sub1_file_name = file_name+"singleTone30dBJammer/";
    end
    for j = 1:nof_positions
        sub2_file_name = sub1_file_name+"jammerPosition"+num2str(j)+"/";
        for k = 1:2 % k = 1: noBA. k = 2: with BA
            if k == 1
                sub3_file_name = sub2_file_name+"noBeamArmor/";
            else
                sub3_file_name = sub2_file_name+"withBeamArmor/";
            end        
            for m = 1:nof_ms
                sub4_file_name = sub3_file_name+"m"+num2str(m)+"_sinr_brate_bler.txt";
                A = readmatrix(sub4_file_name);
                len_t = length(A)/3;
                B = reshape(A, 3, len_t);
                C = B';
                bler = C(:,3);
                
                bler_avg(i,k,(j-1)*nof_ms+m) = round(mean(bler,"omitnan")*100)/100;
            end
        end
    end
end

% Ground truth
bler_gt_avg = zeros(nof_ms,1);
file_name2 = "measurements/6mBetweenUE+eNB_18dBgain/noJammer/";
for m = 1:nof_ms
    sub_file_name2 = file_name2+"m"+num2str(m)+"_sinr_brate_bler.txt";
    A = readmatrix(sub_file_name2);
    len_t = length(A)/3;
    B = reshape(A, 3, len_t);
    C = B';
    bler_gt = C(:,1);
    
    bler_gt_avg(m) = round(mean(bler,"omitnan")*100)/100;
end

runs = nof_ms*nof_positions;
x = 1;
y = [reshape(bler_avg(1,1,:),[],runs);reshape(bler_avg(1,2,:),[],runs);...
    reshape(bler_avg(2,1,:),[],runs);reshape(bler_avg(2,2,:),[],runs)];

boxplot(y')
% if y1_low_lim < 0
%   ylim([0, y1_up_lim])
% else
%     ylim([y1_low_lim, y1_up_lim])
% end
hold on
line([0, size(y,2)+1], [mean(bler_gt_avg), mean(bler_gt_avg)], 'color',...
    [0.4660 0.6740 0.1880], 'LineWidth', 2, 'linestyle', '--')
hold off
ylim([0, 70])
yticks(0:5:70)
ylabel('BLER in %')
set(gca, 'xticklabel', {'STJ no BA', 'STJ with BA',...
    'WBJ no BA', 'WBJ with BA'})
grid on
legend('No Jammer')
title("Average BLER")