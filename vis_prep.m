%% visualise ggv versus logged gps data

clear
load('session_zandvoort_laps36-52_20130627_0931_v1.mat')


%% select desired laps

ind = zeros(size(Lap));

for i=[36:44 49:51]
    ind = or(Lap==i, ind);
end

Lap(~ind)=[];
Distancem(~ind)=[];
lat_a = LateralAccelerationG(ind);
lon_a = LongitudinalAccelerationG(ind);
vel = Speedms(ind);

%% smooth the data

lat_a = smooth(Distancem, lat_a,0.0021,'rloess');
lon_a = smooth(Distancem, lon_a,0.0021,'rloess');
vel = smooth(Distancem, vel,0.0021,'rloess');



%% plot smoothed data


%%get simulated data
% load('Z:\JJ_Documents\MATLAB\Laptime simulation\GGV\205_rfs.mat')
load('Z:\JJ_Documents\MATLAB\Laptime simulation\tracks\zandvoort_fit.mat')
[s, v, a] = laptime_sim(track_data, ggv_const);

a  = a/9.81;
a_lat = a(:,1);
a_lon = a(:,2);


subplot(3,2,2)
plot(lat_a,lon_a); 
grid on; 
axis equal;
hold on
plot(a_lat,a_lon)
hold off


subplot(3,2,[1; 3; 5])
plot(lat_a, vel);grid on; 
hold on
plot(a_lat, v)
grid on
hold off

subplot(3,2,4)
plot(vel(lon_a>0),lon_a(lon_a>0));
% plot(vel,lon_a);
grid on; 
hold on
plot(v(a_lon>0),a_lon(a_lon>0))
grid on
hold off

subplot(3,2,6)
plot(vel(lon_a<0),lon_a(lon_a<0));
% plot(vel,lon_a);
grid on; 
hold on
plot(v(a_lon<0),a_lon(a_lon<0))
grid on
hold off

save(vis1_data); 
