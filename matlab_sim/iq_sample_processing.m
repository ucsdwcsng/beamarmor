n = 1000000;    % number of samples
iq_samples = read_complex_binary('bad_angle', n);

power = abs(iq_samples).^2;
power_db = db(iq_samples);
average_power = sum(power)/n;
average_power_db = pow2db(average_power);

% plot((1:50000), log_power)

plot(power_db)