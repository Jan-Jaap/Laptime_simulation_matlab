
function [t, results] = laptime_sim(track_data, ggv_const)

% b is the spline parametric baseline
b = linspace(0, max(track_data.spline.breaks), 10000);

% s is distance traveled between points in xy
xy = fnval(track_data.spline,b);  %xy[1] and xy[end] are at same location
s = [0 sqrt(sum(diff(xy,1,2).^2))];

%curvature at the point in xy  (= 1/Radius)
dxy = fnval(fnder(track_data.spline, 1),b);
ddxy = fnval(fnder(track_data.spline, 2),b);
c = -diff(dxy.*flip(ddxy)) ./ sum(dxy.^2,1).^(3/2);
% c(end)=[];


results.xy = xy;
results.dxy = dxy;
results.ddxy = ddxy;




m_car = 945+98; %kg
max_lat_acc     =ggv_const(1);
max_lon_brk     =ggv_const(2);
Cd              =ggv_const(3);
a_o             =ggv_const(4);
max_lon_acc     =2;
% Y               =ggv_const(5:9);

% x   = linspace(20,55,5);
% F = griddedInterpolant(x,Y, 'pchip', 'nearest' );

v_a = zeros(size(s));
v_b = zeros(size(s));

%maximum velocity through corner based on max laterel acceleration
v_max = sqrt(abs(max_lat_acc ./ c));

%% starting conditions
vel_f = 0;   %velocity [m/s]
a_lon = max_lon_acc;


% simulate laps till start speed is not 0  (2 laps)
while v_a(1)==0
    
for i=1:length(s);
    
    % calculate new velocity based on start velocity and max acceleration
    vel_i = sqrt(vel_f^2 + 2 * a_lon * s(i) );    

    % calculate lateral acceleration based on speed and corner radius at point i   
    a_lat = vel_i^2 * c(i);

    
    if vel_i > v_max(i)  % is velocity bigger than the maximum velocity?
        a_lat = max_lat_acc;
        vel_i = v_max(i);
    end
     
%     a_lon = sin(acos(a_lat / max_lat_acc)).* (F(vel_i)/m_car - a_o) - Cd/2*vel_i.^2/m_car + a_o;
    a_lon = sin(acos(a_lat / max_lat_acc)).* (max_lon_acc - a_o) + Cd/2*vel_i^2/m_car + a_o;

    v_a(i) = vel_i;
    vel_f = vel_i;
end


end


%% braking  (backward acceleration)

for i=flip(1:length(s));
    
    vel_i = sqrt(vel_f^2 + 2*a_lon*s(i));    

    % calculate lateral acceleration based on speed and corner radius at point i   
    a_lat = vel_i^2 * c(i);

    if vel_i > v_max(i);  % is lateral acceleration smaller than the maximum?
        a_lat = max_lat_acc;
        vel_i = v_max(i);
    end
    
    a_lon = sin(acos(a_lat / max_lat_acc)).* (max_lon_brk + a_o) + Cd/2*vel_i^2/m_car - a_o;

    v_b(i) = vel_i;
    vel_f = vel_i;

end


v = min(v_a,v_b)';


a_lon = diff([v; v(1)].^2) ./ (2 * s.');  %previous section
a_lat = v.^2 .* c';
t = cumsum(diff([v; v(1)]) ./ a_lon);


results.t = t;
t = max(t);
s = cumsum(s);
results.s = s;
results.v = v;
results.v_a = v_a;
results.v_b = v_b;
results.a_lat = a_lat;
results.a_lon = a_lon;


end
