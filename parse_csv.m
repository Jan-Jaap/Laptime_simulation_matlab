
clear
close all

load('session_zandvoort_circuit_20161003_0923_v1.mat' )
load('DTM_ZANDVOORT.mat')

ind = Lap<0;

for i=unique(Lap(Lap>0))'
% for i=[1,2,3,4,5,6,7,8,9,10,13,14,17,18,19,20,21,24,25,26,29,30,34,35,37,38,39,40,41,42,45,46,51,52,53,56]
% for i=[36:44 49:51]
% for i=[39 40 41 44]
% for i=41
    ind = or(Lap==i, ind);
end

Lap(~ind)=[];
Longitudedeg(~ind)=[];
Latitudedeg(~ind)=[];
Distancem(~ind)=[];
Xpositionm(~ind)=[];
Ypositionm(~ind)=[];
Speedms(~ind)=[];


% kmlwriteline('output.kml', Latitudedeg, Longitudedeg);



lcm = deg2rad(5.5);
[N, E]=ell2utm(deg2rad(Latitudedeg), deg2rad(Longitudedeg),lcm);
[start_y, start_x] = ell2utm(deg2rad(52.3877213), deg2rad(4.5399508),lcm);




x_pos = E - start_x;
y_pos = N - start_y;
plot (x_pos, y_pos , '.');
hold on

x_offset = 348;
y_offset = -210;

pos_x = circshift(wp_pos_x, -828);
pos_y = circshift(wp_pos_y, -828);

plot(pos_x + x_offset, pos_y + y_offset, '-x');
plot(outside_x + x_offset,outside_y + y_offset);
plot(inside_x + x_offset,inside_y + y_offset);

ind1 = inpolygon(x_pos, y_pos, outside_x + x_offset, outside_y + y_offset);
ind2 = inpolygon(x_pos, y_pos, inside_x + x_offset, inside_y + y_offset);
ind = ind1 & ~ind2;
plot(x_pos(ind), y_pos(ind) , '.');
sum(ind)



axis equal
grid on