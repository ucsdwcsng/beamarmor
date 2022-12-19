% beam nulling to avoid interference
%
% Author: Ish Jain
% Date created: 12/16/2022

clearvars;
% create beam null and plot the pattern

N = 2; %number of antennas
theta_null = -30; %angle for creating null in degree

if(sind(theta_null)>0)
theta_beam = asind(sind(theta_null)-1); %deg beam direction
else
theta_beam = asind(sind(theta_null)+1); %deg beam direction
end
theta = -90:90; %for plotting
array = 1:N;
weights = exp(1j*pi*sind(theta_beam)*array);
array_manifold = exp(-1j*pi*sind(theta).'*array);

B = array_manifold*weights.';

figure(1); clf;
plot((theta),abs(B))
hold on;grid on;
xline((theta_null))
xline((theta_beam), 'r-')


