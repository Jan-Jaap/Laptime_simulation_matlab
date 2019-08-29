%% plot gps data in game track
% minimize point outside track by offsetting track boundaries

clearvars -except offset

load('tracks\DTM_ZANDVOORT.mat')

load('Z:\JJ_Documents\MATLAB\Laptime simulation\session_zandvoort_laps36-52_20130627_0931_v1.mat', ...
    'Xpositionm', 'Ypositionm', 'Lap')

ind = zeros(size(Lap));

% % unique(Lap)

% for i=[36:52]
% for i=[39 40 41 44]
% for i=[36:44 49:51]
for i=41
    ind = or(Lap==i, ind);
end

x1 = Xpositionm(ind);
y1 = Ypositionm(ind);

% x1 = Xpositionm;
% y1 = Ypositionm;


x2 = [outside_x;  NaN; flip(inside_x)];
y2 = [outside_y;  NaN; flip(inside_y)];


fun = @(offset)sum(~inpolygon(x1, y1   ,x2 * offset(3) + offset(1) ,y2 * offset(4) + offset(2) ));

offset = [361.4402 -164.7444    0.9974    1.0104];
% offset = fminsearch(fun,offset)

x2 = x2 + offset(1);
y2 = y2 + offset(2);

ind = inpolygon(x1  ,y1  ,x2 ,y2 );

plot(x2, y2); hold on; axis equal;
% plot(path_x, path_y, ':')

plot(x1 , y1,'k')
plot(x1(~ind) , y1(~ind),'rx')
hold off