close all
clear

load('DTM_ZANDVOORT.mat')

lcm = deg2rad(5.5);
% [N, E]=ell2utm(deg2rad(Latitudedeg), deg2rad(Longitudedeg),lcm);

% start/finish at 0,0m



[start_N, start_E] = ell2utm(deg2rad(52.387734), deg2rad(4.539952) ,lcm);

x_offset = start_E +348;
y_offset = start_N -210;
% x_offset = [435011.795016594];
% y_offset = [5804386.74055716];


% [lat,lon]=utm2ell(N,E,Zone,a,e2,lcm)
[lat,lon] = utm2ell(inside_y + y_offset, inside_x + x_offset,31, lcm);
kmlwriteline('inside.kml', rad2deg(lat), rad2deg(lon));
inside_lat = lat;
inside_lon = lon;

[lat,lon] = utm2ell(outside_y + y_offset, outside_x + x_offset,31, lcm);
kmlwriteline('outside.kml', rad2deg(lat), rad2deg(lon));
outside_lat = lat;
outside_lon = lon;

[lat,lon] = utm2ell(path_y + y_offset, path_x + x_offset,31, lcm);
% kmlwriteline('path.kml', rad2deg(lat), rad2deg(lon));
path_lat = lat;
path_lon = lon;

[lat,lon] = utm2ell(wp_pos_y + y_offset, wp_pos_x + x_offset,31, lcm);
% kmlwriteline('wp_pos.kml', rad2deg(lat), rad2deg(lon));
wp_pos_lat = lat;
wp_pos_lon = lon;
