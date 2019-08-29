%% plot track spine derived from gps data in game track
% minimize point outside track by offsetting track boundaries

clearvars -except offset
load('tracks\zandvoort_fit.mat')
load('tracks\DTM_ZANDVOORT.mat')


s = linspace(0, track_data.lap_length,500);
x1 = fnval(track_data.x,s);
y1 = fnval(track_data.y,s);


x2 = [outside_x;  NaN; flip(inside_x)];
y2 = [outside_y;  NaN; flip(inside_y)];


% fun = @(offset)sum(~inpolygon(x1, y1   ,x2 * offset(3) + offset(1) ,y2 * offset(4) + offset(2) ));

fun = @(offset)sum(~inpolygon(x1, y1...
    ,[outside_x* offset(3);  NaN; flip(inside_x)* offset(4)]  + offset(1)...
    ,[outside_y* offset(3);  NaN; flip(inside_y)* offset(4)]  + offset(2) ));

% offset = [360, -160, 1, 1];
offset = fminsearch(fun,offset)

x2 = x2 + offset(1);
y2 = y2 + offset(2);

ind = inpolygon(x1  ,y1  ,x2 ,y2 );

plot(x2, y2); hold on; axis equal;
% plot(path_x, path_y, ':')

plot(x1 , y1,'k')
plot(x1(~ind) , y1(~ind),'rx')
hold off