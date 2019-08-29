%% plot track spine derived from gps data in game track
% minimize point outside track by offsetting track boundaries

clearvars -except offset
load('tracks\zandvoort_fit.mat')
load('tracks\DTM_ZANDVOORT.mat')


s = linspace(0, track_data.lap_length,1000);
x1 = fnval(track_data.x,s);
y1 = fnval(track_data.y,s);

len_x = numel(x1);


x2 = @(offset)[offset(1) + wp_pos_x - wp_perp_x .* wp_width_l * offset(3); NaN; flip(offset(1) + wp_pos_x - wp_perp_x .* wp_width_r * offset(4) )];
y2 = @(offset)[offset(2) + wp_pos_y - wp_perp_y .* wp_width_l * offset(3); NaN; flip(offset(2) + wp_pos_y - wp_perp_y .* wp_width_r * offset(4) )];

fun = @(offset) sum(~inpolygon(x1, y1 ,x2(offset) , y2(offset) ))  + sumsqr(offset(3:4) - 1);

offset = [362.2830 -161.3822    1.4259    1.5646];
% offset = fminsearch(fun,offset)
fun(offset)

x2 = x2(offset);
y2 = y2(offset);

ind = inpolygon(x1  ,y1  ,x2 ,y2 );

plot(x2, y2); hold on; axis equal;
plot(path_x + offset(1), path_y + offset(2), ':')

plot(x1 , y1,'k')
plot(x1(~ind) , y1(~ind),'rx')
hold off