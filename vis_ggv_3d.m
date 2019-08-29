%% visualise ggv versus logged gps data

clearvars

load('vis1', 'lat_a', 'lon_a', 'vel'); 

if ~exist('ggv_const','var')
    load('vis1', 'ggv_const'); 
end



%% plot smoothed data


%%get simulated data

load('Z:\JJ_Documents\MATLAB\Laptime simulation\tracks\zandvoort_fit.mat')
[t, results] = laptime_sim(track_data, ggv_const, F);


g_lat = results.a_lat ./9.81;
g_lon = results.a_lon ./9.81;

plot3(lat_a, lon_a, vel);
hold on

plot3(g_lat, g_lon, results.v,'LineWidth', 3);
% plot3(a_lat, a_lon, v,'o');
hold off



