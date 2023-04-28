clear;

sf_len = 11520;

% Create y1 and y2 as complex vectors
y1_vec = zeros(sf_len,1);
y2_vec = zeros(sf_len,1);
% Create empty vector for all alphas
alphas = zeros(100,1);

for tti = 0:99
    % Read y1 and y2 from file
    C1 = readcell(strcat('y1y2_for_100TTIs/y1_',string(tti),'.txt'));
    C2 = readcell(strcat('y1y2_for_100TTIs/y2_',string(tti),'.txt'));
    % Clean up unwanted parantheses
    y1 = regexprep(C1,'(','');
    y1 = regexprep(y1,')','');
    y2 = regexprep(C2,')','');
    y2 = regexprep(y2,'(','');
    
%     % Calcualte power: per sample and average
%     pwr_per_iq_sample = zeros(sf_len,2);
    
    for i = 1:sf_len
%         pwr_per_iq_sample(i,1) = str2double(y1(i,1))^2*str2double(y1(i,2))^2;
%         pwr_per_iq_sample(i,2) = str2double(y2(i,1))^2*str2double(y2(i,2))^2;
        y1_vec(i) = str2double(y1(i,1)) + 1i*str2double(y1(i,2));
        y2_vec(i) = str2double(y2(i,1)) + 1i*str2double(y2(i,2));
    end
    
%     y1_avg_pwr = sum(pwr_per_iq_sample(:,1))/sf_len;
%     y2_avg_pwr = sum(pwr_per_iq_sample(:,2))/sf_len;
%     pwr_y1y2_db = pow2db(pwr_per_iq_sample);
%     y1_avg_db = pow2db(y1_avg_pwr);
%     y2_avg_db = pow2db(y2_avg_pwr);
    
    % Calculate alpha
    disp(strcat('Calculating alpha_',string(tti)))
    alphas(tti+1) = ((-1)*y2_vec'*y1_vec)/(y2_vec'*y2_vec);

end
disp('Done calculating alphas!')

% Calculate the magnitude and phase
m = abs(alphas);
p = rad2deg(angle(alphas));

% Create a boxchart with magnitude and phase
figure;
subplot(1,2,1);
boxchart(m);
ylim([0 2])
ylabel('Magnitude');
subplot(1,2,2);
boxchart(p);
ylim([0 2])
ylabel('Phase');

% % Plot
% clf;
% subplot(1,2,1) % y1
% plot((1:sf_len),pwr_y1y2_db(:,1))
% title('Samples y1')
% ylabel('Power in dB')
% xlim([0 sf_len])
% xlabel('Samples number in TTI')
% subplot(1,2,2) % y2
% plot((1:sf_len),pwr_y1y2_db(:,2))
% title('Samples y2')
% ylabel('Power in dB')
% xlim([0 sf_len])
% xlabel('Samples number in TTI')
