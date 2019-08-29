
%% laptime sim
clearvars -except track_data ggv_const F
clc
close all

if ~exist('ggv_const','var')
    load('GGV/205_rfs.mat', 'ggv_const'); 
end

load('Z:\JJ_Documents\MATLAB\Laptime simulation\tracks\zandvoort_fit.mat')
% load('Z:\JJ_Documents\MATLAB\Laptime simulation\session_zandvoort_laps36-52_20130627_0931_v1.mat')


% b = linspace(0, max(track_data.spline.breaks), 1000);
% xy = fnval(track_data.spline,b);
% [t, results] = laptime_sim(track_data, ggv_const, F);
[laptime, results] = laptime_sim(track_data, ggv_const);
% [xy, ds, dds]


x = results.xy(1,:);
y = results.xy(2,:);
a_lon = results.a_lon;

% a_lat = 


%% plot baseline


% disp(['Laptime in simulated lap = ' num2str(track_data.lap_length / mean(ds))]) 
disp(['Laptime in simulated lap = ' num2str(laptime)]) 

figure
color_line(x, y, a_lon');
% color_line(xy(1,:), xy(2,:), [0 ds']);
axis equal
% colormap prism

map = [1000:-1:1; 1:1000; zeros(1,1000)]' ./ 1000;

colormap(map)

% simuld_vel = timeseries(ds, s);

% quiver(xy(1,:), xy(2,:), 

% plot(simuld_vel,'k','LineWidth',2); hold off


%% plot results 
% 
figure
% subplot(2,2,1)
plot(results.s, results.v, 'k'); hold on
plot(results.s, results.v, 'k', 'LineWidth', 2); hold on
axis manual
plot(results.s, results.v_a,'--'); 
plot(results.s, results.v_b,'--');
% plot(results.s, v_max);

figure
subplot(3,1,1)
plot(results.a_lat,results.a_lon)
axis equal;
% grid on; 

subplot(3,1,2)
plot(results.v,results.a_lon)
grid on

subplot(3,1,3)
plot(results.v,results.a_lat)
grid on

hold off

%% compare with gps data
figure
load('\\SYNOLOGYDS215J\home\JJ_Documents\MATLAB\Laptime simulation\session_zandvoort_laps36-52_20130627_0931_v1.mat')

scatter(results.s, results.v, 'k.'); hold on

scatter(Distancem(Lap==40) - min(Distancem(Lap==40)), Speedms(Lap==40)); hold off
