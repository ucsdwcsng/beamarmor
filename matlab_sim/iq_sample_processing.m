% total number of samples measured
n = 1e6+3*3.6e6;
samp_rate = 10e6;
start=1e6;
% Read the complex I/Q samples from file 
iq_samples = read_complex_binary('../../single_tone_rx_samples', n, start);

%
% figure(1); clf;
% plot(abs(iq_samples))
% fftplot2(iq_samples)
%

% Read timestamps from file and save to 1x(#ofangles) matrix
% timestamps = readmatrix('timestamps.txt');
% nof_angles = numel(timestamps);
nof_angles = 360;

% convert seconds count into samples count
% Multiply by 10,000,000 samples/second
% sample_count = round(timestamps*10000000);

% Carries the indexes of samples after which the measurement is split into
% the next angle measurement. Add 100,000,000 because of the 10 sec delay
% after calling uhd_rx_cfile. Subtract 1 to get the sample index at which
% one maseurment ends (not the one where the next begins).
% split_points = sample_count+(100000000-1);
split_points = (10e3:10e3:n-start);

% test_array = zeros(1,300000000);

% Split array of all samples into samples per measured angle
per_angle_samples_count = diff([0;split_points';numel(iq_samples)]);

% cell array holding all sampling points, where one cell is the collection 
% of sampling points for one measured angle
C = mat2cell(iq_samples,per_angle_samples_count,1);

% Save number of samples per angle in this matrix
% nof_samples_per_angle = zeros(1,nof_angles);
% Save average signal power per angle
avg_pwr_per_angle = {zeros(1,nof_angles),zeros(1,nof_angles),zeros(1,nof_angles)};

% for i = 2:(nof_angles)
%     nof_samples_per_angle(i-1) = numel(C{i});
%     avg_pwr_per_angle(i-1) = pow2db(sum(abs(C{i}).^2)/numel(C{i}));
% end
for i = 0:2
    for j = 1:nof_angles
        avg_pwr_per_angle{i+1}(j) = pow2db(sum(abs(C{(i*nof_angles)+j}).^2)/10e3);
    end
end

% avg_nof_samples_per_angle = round(mean(nof_samples_per_angle));

% samples_last_angle = C{nof_angles+1}(1:avg_nof_samples_per_angle);
% avg_pwr_per_angle(nof_angles) = pow2db(sum(abs(samples_last_angle).^2)/numel(samples_last_angle));

% plot((-90:90), avg_pwr_per_angle)
figure(1); clf;
for i = 1:3
    [min_val, min_idx] = min(avg_pwr_per_angle{i});
    [max_val, max_idx] = max(avg_pwr_per_angle{i});
    subplot(1,3,i)
    plot((1:360), avg_pwr_per_angle{i})
    hold on
    plot(min_idx,avg_pwr_per_angle{i}(min_idx),'*r')
    text(min_idx,min_val, strcat('\leftarrow Min at',{' '},mat2str(min_idx),'°'), "FontSize", 12)
    hold off
    xlabel('Phase Shift at Antenna 2 in Degrees')
    ylabel('Relative power received at 90°')
    ylim([round(min_val-3) round(max_val+3)])
    xlim([0 360])
    yticks(round(min_val-3):2:round(max_val+3))
    grid on
end



% plot(power_db)

% power = abs(iq_samples).^2;
% power_db = db(iq_samples);
% average_power = sum(power)/n;
% average_power_db = pow2db(average_power);