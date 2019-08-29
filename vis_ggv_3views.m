%% visualise ggv versus logged gps data

clearvars -except 'ggv_const' 'F'

load('vis1', 'lat_a', 'lon_a', 'vel'); 

if ~exist('ggv_const','var')
    load('GGV/205_rfs.mat', 'ggv_const'); 
end



%% plot smoothed data


%%get simulated data

load('Z:\JJ_Documents\MATLAB\Laptime simulation\tracks\zandvoort_fit.mat')
[t, results] = laptime_sim(track_data, ggv_const, F);

% [s, v, a] 


% a  = a;
g_lat = results.a_lat ./9.81;
g_lon = results.a_lon ./9.81;
v = results.v;

subplot(1,3,3)
plot(lat_a,lon_a); 
grid on; 
axis equal;
hold on
plot(g_lat ,g_lon)
hold off


subplot(1,3,2)
plot(lat_a, vel);grid on; 
hold on
plot(g_lat, v)
grid on
hold off

subplot(1,3,1)
% plot(vel(lon_a>0),lon_a(lon_a>0));
plot(lon_a, vel);
grid on; 
hold on
% plot(v(a_lon>0),a_lon(a_lon>0))
plot(results.a_lon ./ 9.81, results.v)
grid on
hold off

% subplot(3,2,6)
% plot(vel(lon_a<0),lon_a(lon_a<0));
% % plot(vel,lon_a);
% grid on; 
% hold on
% plot(v(a_lon<0),a_lon(a_lon<0))
% grid on
% hold off

% save('vis1'); 
