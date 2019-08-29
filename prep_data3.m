clear
load('session_zandvoort_laps36-52_20130627_0931_v1.mat')


%% select desired laps

ind = Lap<0;

for i=[39 40 41 44]
% for i=[41]
    ind = or(Lap==i, ind);
end

Lap(~ind)=[];
Distancem(~ind)=[];
LateralAccelerationG(~ind)=[];
LongitudinalAccelerationG(~ind)=[];
Speedms(~ind)=[];


% set startpoint for each lap to distance traveled zero (dist=0)
dist = Distancem;
tims = Timestamps;

for i=unique(Lap)' 
    ind = Lap==i;
    Distancem(ind) = Distancem(ind) - min(Distancem(ind));
%     Timestamps(ind) = Timestamps(ind) - min(Timestamps(ind));
end

%% sort the data according distance traveled
% [dist, ind] = sort(Distancem);

%% smooth the data

lat_a = smooth(Distancem, LateralAccelerationG,0.0025,'rloess');
lon_a = smooth(Distancem, LongitudinalAccelerationG,0.0025,'rloess');
vel = smooth(Distancem, Speedms,0.002,'rloess');

%% plot raw data
% figure
% subplot(3,1,1)       % add first plot in 2 x 1 grid
% plot(LateralAccelerationG,'DisplayName','LateralAccelerationG');hold on;plot(lat_a,'DisplayName','unfiltered');hold off;
% subplot(3,1,2)
% plot(LongitudinalAccelerationG,'DisplayName','LongitudinalAccelerationG');hold on;plot(lon_a,'DisplayName','unfiltered');hold off;
% subplot(3,1,3)
% plot(Speedms,'DisplayName','Speed');hold on;plot(vel,'DisplayName','unfiltered');hold off;
% 


%% plot smoothed data
% figure
% plot3 (LateralAccelerationG, LongitudinalAccelerationG, Speedms, '.')


subplot(3,1,1)
plot(lat_a,lon_a); grid on; axis equal;
subplot(3,1,2)
plot(vel,lat_a);grid on; 
subplot(3,1,3)

plot(vel(lon_a>0),lon_a(lon_a>0));grid on; 


% grid on
% hold on
% plot3 (lat_a, lon_a, vel, '.-')
% hold off

%% plot velocity profile

plot(Distancem,Speedms)

%% find peaks in velocity

[pks,locs] = findpeaks(Speedms,Distancem, 'MinPeakProminence',4, 'Annotate','extents');
[pks1,locs1] = findpeaks(-Speedms,Distancem, 'MinPeakProminence',4, 'Annotate','extents');

plot(Distancem,Speedms,locs, pks, 'o', locs1, -pks1, 'o')
% findpeaks(Speedms,Distancem,'MinPeakProminence',4,'Annotate','extents')
% findpeaks(Speedms,Distancem,'MinPeakProminence',1,'MinPeakDistance',100,'Annotate','extents')

% 'MinPeakDistance',6
% text(locs+.02,pks,num2str((1:numel(pks))'))

% findpeaks(-Speedms,Distancem)
