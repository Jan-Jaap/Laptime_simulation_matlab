
%% laptime sim
clearvars -except track_data ggv_const F
clc

if ~exist('ggv_const','var')
    load('GGV/205_rfs.mat', 'ggv_const'); 
end

load('Z:\JJ_Documents\MATLAB\Laptime simulation\tracks\zandvoort_fit.mat')
load('Z:\JJ_Documents\MATLAB\Laptime simulation\session_zandvoort_laps36-52_20130627_0931_v1.mat')

ind = zeros(size(Lap));
% for i=[39 40 41 44]
% for i=[36:44 49:51]
for i=41
    ind = or(Lap==i, ind);
end

Lap(~ind)=[];
Distancem(~ind)=[];
LateralAccelerationG(~ind)=[];
LongitudinalAccelerationG(~ind)=[];
Speedms(~ind)=[];

% dist = Distancem;
for i=unique(Lap)'
    ind = Lap==i;
    Distancem(ind) = Distancem(ind) - min(Distancem(ind));
end

hold off; plot(Distancem, Speedms,'.'); hold on
disp(['Laptime in logged lap = ' num2str(max(Distancem)/mean(Speedms))])


%% plot baseline

[t, res] = laptime_sim(track_data, ggv_const, F);
plot(res.s, res.v,'--')
disp(['Laptime in simulated lap before opt = ' num2str(t)]) 



%% find optimum ggv parameters to match logged data (Speedms)


fun = @(x0)laptime_eval(x0, track_data, timeseries(Speedms, Distancem), F);  

% fun = @(x0)sum(laptime_eval(x0, track_data, timeseries(Speedms, Distancem), F));         
% ggv_const

% ggv_const = fminsearch(fun,ggv_const, optimset('MaxIter',100) );
% ggv_const = fminsearch(fun,ggv_const);
lb = [0; 0; 0; 0];
ub = [12; 12; 3; 2;];

options = optimoptions('lsqnonlin',...
    'TolFun',1e-9);
% ggv_const = lsqnonlin(fun, ggv_const, lb, ub, options );

% 
% fun(ggv_const)
[t, res] = laptime_sim(track_data, ggv_const, F);
s = res.s;
ds = res.v;

disp(['Laptime in simulated lap after opt= ' num2str(t)])
plot(s, ds,'k'); hold off


logged_vel = timeseries(Speedms, Distancem);
simuld_vel = timeseries(ds, s);
% 
% plot(logged_vel); hold on
% plot(simuld_vel,'k','LineWidth',2); hold off
% 
% [logged_vel, simuld_vel] = synchronize(logged_vel,simuld_vel,'Uniform','Interval',10);
% ts = logged_vel - simuld_vel;
% err = sqrt(abs(ts.Data))
% 
% plot(logged_vel,'o'); 
% plot(simuld_vel,'.'); hold off
% 



