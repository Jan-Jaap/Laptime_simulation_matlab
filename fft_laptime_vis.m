% function out = fft_laptime_vis(f0)


% Steadystate laptime simulator based on GPS derived track
clear
clc
close all

%% define circuit properties (boundary, bank)

load('zandvoort_dtm.mat')

wp_r = wp_pos - perp.*right(:,[1 1 1]);
wp_l = wp_pos - perp.*left(:,[1 1 1]);

inter_r = wp_pos + perp.*12;
inter_l = wp_pos - perp.*12;

x = [inter_l(:,1); flip(inter_r(:,1))];
y = [inter_l(:,2); flip(inter_r(:,2))];
z = [inter_l(:,3); flip(inter_r(:,3))]; 

F = scatteredInterpolant(x,y,z, 'natural', 'none');

plot(x, y, 'k-.'); hold on
plot3(wp_pos(:,1), wp_pos(:,2), wp_pos(:,3), 'r');
patch(x, y, z, z);

x = [wp_l(:,1); flip(wp_r(:,1))];
y = [wp_l(:,2); flip(wp_r(:,2))];
z = [wp_l(:,3); flip(wp_r(:,3))]; 

plot3(x,y,z,'r','LineWidth', 2);
clear x y z




%% create track
load('session_zandvoort_circuit_20161003_0923_v1.mat')

ind = Lap<0;

% for i=unique(Lap(Lap>0))'
% for i=[1,2,3,4,5,6,7,8,9,10,13,14,17,18,19,20,21,24,25,26,29,30,34,35,37,38,39,40,41,42,45,46,51,52,53,56]
for i=[40,41,42,45,46,51,52,53,56]
% for i=[36:44 49:51]
% for i=[39 40 41 44]
% for i=40
    ind = or(Lap==i, ind);
end
Latitudedeg(~ind)=[];
Longitudedeg(~ind)=[];
Lap(~ind)=[];
Distancem(~ind)=[];
% Xpositionm(~ind)=[];
% Ypositionm(~ind)=[];
Speedms(~ind)=[];


lcm = deg2rad(5.5);
[Ypositionm, Xpositionm]=ell2utm(deg2rad(Latitudedeg), deg2rad(Longitudedeg),lcm);

%Zandvoort start/finish (racechrono) center track
[y_offset, x_offset] = ell2utm(deg2rad(52.387725), deg2rad(4.54000) ,lcm);
x0 = Xpositionm - x_offset-344;
y0 = Ypositionm - y_offset+210;

% sort into 1 noisy lap (averaging)
if true
    
        % set startpoint for each lap to distance traveled zero (dist=0)
        dist = Distancem;

        for i=unique(Lap)'
            ind = Lap==i;
            dist(ind) = dist(ind) - min(dist(ind));
        end


        % sort the data according distance traveled and fit spline
        [dist_sorted, ind] = sort(dist);
        lap_length = max(dist_sorted);
        % ind(end)=1;

        x0 = x0(ind);
        y0 = y0(ind);
        v0 = Speedms(ind);
          
end

%low pass filter
xyf =  fft([x0 y0]);
i = 40; % lower frequencies to keep
xyf(1+i:end-i,:) = 0;% set higher frequencies to zero

%inter/extra polation by resizing frequency domain
i = 2000; 
xyf(1+i:end-i,:) = [];%
xyf =  xyf .* (i/length(x0)*2);% scale fft to new dimension

% from frequency domain back to time domain
xy = real(ifft(xyf));

x = xy(:,1);
y = xy(:,2);
z = F(x, y);

plot3(x,y,z, 'k', 'LineWidth', 2);
i = 286;
plot3(x(i),y(i),z(i),'or');

% Determine FRENET Frame (wrt position vector)
% [T,N,B,k,t] = frenet(x, y, z);

% SPEED OF CURVE
dx = gradient(x);
dy = gradient(y);
dz = gradient(z);
dr = [dx dy dz];

% ACCELERATION OF CURVE
ddx = gradient(dx);
ddy = gradient(dy);
ddz = gradient(dz);
ddr = [ddx ddy ddz];

ds = sqrt(sum(dr.^2,2));  %curve speed
s = cumtrapz(ds);% Calculate integrand from x,y derivatives (=arc length)

% TANGENT
T = dr./ ds(:,[1 1 1]); %Tangent vector at unit speed

tic
% DERIVIATIVE OF TANGENT
dTx =  gradient(T(:,1), s);
dTy =  gradient(T(:,2), s);
dTz =  gradient(T(:,3), s);
dT = [dTx dTy dTz];  % pure lateral accelerations

% Determine DARBOUX Frame (wrt to surface)

% T = T  (same as in frenet frame)

 % create path 80cm (~half trackwidth) to the right
u = zeros(size(T));
u(:,3) = 0.8;
u = cross(T,u);    

%set z to path height
u(:,3) = F(x+u(:,1), y+u(:,2))-z;     
u = u ./ (sqrt(sum(u.^2,2))*[1 1 1]);%normalize perpedicular vector

t = cross(u, T);                %surface normal vector; (length is normalized)
t = t ./ (sqrt(sum(t.^2,2))*[1 1 1]);%re-normalize normal vector


% clearvars -except x y bank s c sc 

%% define car properties

g               =9.81; %m/s2
m_car           =945+98; %kg (incl driver)
% max_lat_acc     =10.9780336297735; % max lateral acceleration
u_fric          =1.15;
% a_max_lat       =u_fric * g;
a_max_lon_brk   =0.6*g; % max braking deceleration
Cd              =1.8; % drag coefficient
% Due to car geometry maximum lateral acceleration can be achieved with 
% slight longitudinal acceleration
a_o             =0.1; % max_lat_acc offset
a_max_lon_acc   =0.3 * g; % max longitudinal accelation

g_vector = zeros(size(t));
g_vector(:,3) = g;


%% simulate laptime



%maximum velocity through corner based on friction and bank

g_n = dot(g_vector, t,2); %normal component of gravity
g_p = dot(g_vector, u,2); %lateral component of gravity
g_T = dot(g_vector, T,2); %tangential component of gravity;

k_n = dot(dT, t, 2);  %normal signed curvature
k_p = dot(dT, u, 2);  %lateral signed curvature


%goes imaginary when v_max is so high that the normal acceleration
%overcomes the gravity  (car takes off). Not a realistic scenario in most
%cases, so will be disregarded by taking the abs.

% a_lat = v^2 * k_p - g_p;   %gravity helps, so less stress on tires
% a_lat_max = u_fric * (g_n - k_n * v_max^2);
% a_lat = a_lat_max;



v_max = (sqrt( (-u_fric.* g_n + g_p) ./ (k_p + u_fric.*k_n ));  
a_max = v_max.^2 .* k_p - g_p;



% quiver3(x, y, z, t(:,1).* k_n, t(:,2).* k_n, t(:,3).* k_n);
% quiver3(x, y, z, t(:,1).* g_n, t(:,2).* g_n, t(:,3).* g_n, 'k-.');
quiver3(x, y, z, u(:,1).* k_p, u(:,2).* k_p, u(:,3).* k_p);
% quiver3(x, y, z, u(:,1).* g_p, u(:,2).* g_p, u(:,3).* g_p, 'k-.');

% quiver3(x, y, z, u(:,1), u(:,2), u(:,3));
% quiver3(x, y, z, dT(:,1), dT(:,2), dT(:,3));






% starting conditions
vel_f = 0;   %velocity [m/s]
a_lon = a_max_lon_acc; %and we're away...

v_a = zeros(size(ds));  %initiating max velocity vector with acceleration only
v_b = zeros(size(ds));  %initiating max velocity vector with braking only

% simulate laps till start speed is >20 (2 laps)
while v_a(1)<10
    
for i=1:length(ds);
    
    % calculate new velocity based on start velocity and acceleration
    vel_i = sqrt(vel_f^2 + 2 * a_lon * ds(i) )    
    
    if vel_i >= v_max(i)  % is velocity bigger than the maximum velocity?
        vel_i = v_max(i);
    end
    a_lat = vel_i^2 .* k_p(i) - g_p(i);

    a_lon = sin(acos(a_lat/(a_max(i)))).* (a_max_lon_acc - a_o ) - Cd/2*vel_i^2/m_car + a_o + g_T(i);
    
    v_a(i) = vel_i;
    vel_f = vel_i;
end


end

% braking  (backward acceleration)

for i=flip(1:length(ds));
    
    if i == 250;
        i;
    end
    
    
    vel_i = sqrt(vel_f^2 + 2*a_lon*ds(i));    

    if vel_i > v_max(i);  % is lateral acceleration smaller than the maximum?
        vel_i = v_max(i);
    end
    
    
    
    a_lat = vel_i^2 .* k_p(i) - g_p(i);
    a_lon = sin(acos(a_lat / a_max(i))).* (a_max_lon_brk + a_o ) + Cd/2*vel_i^2/m_car - a_o - g_T(i);

    v_b(i) = vel_i;
    vel_f = vel_i;

end

v = min(v_a,v_b);
a_lon = gradient(v.^2) ./ (2 * ds) ;
a_lat = v.^2 .* k_p ;

t1 = trapz(gradient(v) ./ a_lon); 
t2 = cumsum(diff([v; v(1)]) ./ a_lon);

%% plot results

if true  % set to true to plot results

    % plot track + longitudinal acceleration

    disp(['Laptime in simulated lap = ' datestr(max(t1) / (24*60*60), 'hh:MM:SS.FFF')]) 

    axis equal

    % plot speed graph incl gps data 
    
    figure

    plot(s, v , 'k', 'LineWidth', 1); hold on

    axis manual

    plot(s, v_max,'DisplayName','v_max1');
    scatter(dist_sorted, v0, '.');
    
    grid on
    hold off


    figure
    subplot(3,1,1)
    plot(a_lat,a_lon)
    axis equal;
    
    % grid on; 
    
    subplot(3,1,2)
    plot(v,a_lon)
    grid on
    
    subplot(3,1,3)
    plot(v,a_lat)
    grid on
    
    hold off
end


