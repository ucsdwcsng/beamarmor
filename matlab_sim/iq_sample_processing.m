% total number of samples measured
n = 10e6;
start=10e6;
% Read the complex I/Q samples from file 
iq_samples = read_complex_binary('pwr_measure_all_angles', n, start);

%
% figure(1); clf;
% plot(abs(iq_samples))
% fftplot2(iq_samples)
%

% Read timestamps from file and save to 1x(#ofangles) matrix
timestamps = readmatrix('timestamps.txt');
nof_angles = numel(timestamps);

% convert seconds count into samples count
% Multiply by 10,000,000 samples/second
sample_count = round(timestamps*10000000); 

% Carries the indexes of samples after which the measurement is split into
% the next angle measurement. Add 100,000,000 because of the 10 sec delay
% after calling uhd_rx_cfile. Subtract 1 to get the sample index at which
% one maseurment ends (not the one where the next begins).
split_points = sample_count+(100000000-1); 


% test_array = zeros(1,300000000);

% Split array of all samples into samples per measured angle
per_angle_samples_count = diff([0;split_points';numel(iq_samples)]);

% cell array holding all sampling points, where one cell is the collection 
% of sampling points for one measured angle
C = mat2cell(iq_samples,per_angle_samples_count,1);

% Save number of samples per angle in this matrix
nof_samples_per_angle = zeros(1,nof_angles);
% Save average signal power per angle
avg_pwr_per_angle = zeros(1,nof_angles);

for i = 2:(nof_angles)
    nof_samples_per_angle(i-1) = numel(C{i});
    avg_pwr_per_angle(i-1) = pow2db(sum(abs(C{i}).^2)/numel(C{i}));
end

avg_nof_samples_per_angle = round(mean(nof_samples_per_angle));

samples_last_angle = C{nof_angles+1}(1:avg_nof_samples_per_angle);
avg_pwr_per_angle(nof_angles) = pow2db(sum(abs(samples_last_angle).^2)/numel(samples_last_angle));

plot((-90:90), avg_pwr_per_angle)
xlabel('Angle of theta null')
ylabel('Relative power received at 0°')
ylim([-40 -25])

% plot(power_db)

% power = abs(iq_samples).^2;
% power_db = db(iq_samples);
% average_power = sum(power)/n;
% average_power_db = pow2db(average_power);