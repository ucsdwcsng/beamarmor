clear;

nof_sets = 5; % Number of sets (different TTIs or no ZMQ)
nof_ms = 5; % Number of measurements
times_of_crash = cell(nof_sets,nof_ms);

file_name = "100xDS/";

t_max = 0;

for i = 1:nof_sets
    switch i
        case 1
            sub_file_name = "no_ZMQ_comm/";
        case 2
%             sub_file_name = "1_in_100_TTI_noDownsampling/";
            sub_file_name = file_name+"1_in_1000TTI/";
%             sub_file_name = "1_in_10_TTI/downsampled10x/";
        case 3
%             sub_file_name = "1_in_10_TTI/downsampled10x/";
            sub_file_name = file_name+"1_in_100TTI/";
%             sub_file_name = "1_in_5_TTI_downsampled100x/";
        case 4
%             sub_file_name = "1_in_5_TTI_downsampled100x/";
            sub_file_name = file_name+"1_in_10TTI/";
%             sub_file_name = "everyTTI_downsampled1000x/";
        case 5
            sub_file_name = file_name+"1_in_5TTI/";
    end

    for j = 1:nof_ms
        sub2_file_name = sub_file_name+"m"+num2str(j)+".txt";
        A = readmatrix(sub2_file_name);
        len_t = length(A)/3; 
        B = reshape(A, 3, len_t);
        C = B';
        bler = C(:,3); % Only BLER required for this plot
        
        % Update t_max
        if len_t > t_max
            t_max = len_t;
        end
        
        % Find the points in time where BLER = 100% 
        bler100_indices = find(bler == 100);
        if isempty(bler100_indices)
            % No crashes occurred in the ms
            times_of_crash{i,j} = []; % dummy value
        else
            % Keep points in time that indicate a new crash
            crash_indices = bler100_indices(1);
            for k = 3:length(bler100_indices)
                % More than 2 seconds between 100% BLER events counts as
                % new crash event
                if bler100_indices(k)-bler100_indices(k-1) > 2
                    crash_indices = [crash_indices, bler100_indices(k)];
                end
            end       
            times_of_crash{i,j} = crash_indices;
        end

    end
end

colors = ['r' 'g' 'b' 'm' 'y'];

figure;
hold on
for i = 1:nof_sets
    for j = 1:nof_ms
        if ~isempty(times_of_crash{i,j})
            y = repmat(i-0.5, size(times_of_crash{i,j}));
            scatter(times_of_crash{i,j},y,80,colors(j),'filled')
        else
            % Plot dummy value to keep legend and color in line
            scatter(99,99,80,colors(j),'filled')
        end
    end
end
hold off
xlabel('time in seconds')
xticks(0:5:80)
ylim([0 5])
yticks(0.5:1:4.5)
yticklabels({'No ZMQ Comm', '1 in 1000 TII','1 in 100 TTI','1 in 10 TTI','1 in 5 TTI'})
grid on
legend('Run 1','Run 2','Run 3','Run 4','Run 5')
title('Radio-link failure occurrences')

plot_magic(gcf,gca,'aspect_ratio',[4 3],'pixelDensity',200,'lineWidth',2.6,'fontSize',21);
export_fig("crash_events",'-png','-pdf','-transparent', gcf)