%% plot track spine derived from gps data in game track
% minimize point outside track by offsetting track boundaries

clearvars -except offset
load('tracks\zandvoort_fit.mat')
load('tracks\DTM_ZANDVOORT.mat')


s = linspace(0, track_data.lap_length,1000);
x1 = fnval(track_data.x,s);
y1 = fnval(track_data.y,s);

x3_l = wp_pos_x - wp_perp_x .* wp_width_l;
y3_l = wp_pos_y - wp_perp_y .* wp_width_l;
x3_r = wp_pos_x - wp_perp_x .* wp_width_r;
y3_r = wp_pos_y - wp_perp_y .* wp_width_r;

x2 = [x3_l; NaN; flip(x3_r)];
y2 = [y3_l; NaN; flip(y3_r)];
clearvars x3_l y3_l x3_r y3_r

fun = @(offset)sum(~inpolygon(x1, y1, x2 * offset(3) + offset(1) ,y2 * offset(4)  + offset(2) ));

offset = [360 -165 1 1];
% offset = fminsearch(fun,offset)

x2 = x2 * offset(3) + offset(1);
y2 = y2 * offset(4) + offset(2);

ind = inpolygon(x1  ,y1  ,x2 ,y2 );

plot(x2, y2); hold on; axis equal;

plot(wp_pos_x, wp_pos_y, ':')

plot(x1 , y1,'k')
plot(x1(~ind) , y1(~ind),'rx')
hold off