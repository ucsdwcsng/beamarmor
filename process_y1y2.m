clear;

% Read y1 and y2 from file
C1 = readcell('y1.txt');
C2 = readcell('y2.txt');
% Clean up unwanted parantheses
y1 = regexprep(C1,'(','');
y1 = regexprep(y1,')','');
y2 = regexprep(C2,')','');
y2 = regexprep(y2,'(','');

% Calcualte power: per sample and average
sf_len = size(y1,1);
pwr_per_iq_sample = zeros(sf_len,2);
for i = 1:sf_len
    pwr_per_iq_sample(i,1) = str2double(y1(i,1))^2*str2double(y1(i,2))^2;
    pwr_per_iq_sample(i,2) = str2double(y2(i,1))^2*str2double(y1(2,2))^2;
end
y1_avg_pwr = sum(pwr_per_iq_sample(:,1))/sf_len;
y2_avg_pwr = sum(pwr_per_iq_sample(:,2))/sf_len;
pwr_y1y2_db = pow2db(pwr_per_iq_sample);
y1_avg_db = pow2db(y1_avg_pwr);
y2_avg_db = pow2db(y2_avg_pwr);

% Plot
clf;
subplot(1,2,1) % y1
plot((1:sf_len),pwr_y1y2_db(:,1))
title('Samples y1')
ylabel('Power in dB')
xlim([0 sf_len])
xlabel('Samples number in TTI')
subplot(1,2,2) % y2
plot((1:sf_len),pwr_y1y2_db(:,2))
title('Samples y2')
ylabel('Power in dB')
xlim([0 sf_len])
xlabel('Samples number in TTI')
