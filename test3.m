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
for i=[36:44 49:51]
% for i=41
    ind = or(Lap==i, ind);
end

x1 = Xpositionm(ind);
y1 = Ypositionm(ind);

len_x = numel(x1);
% x1 = Xpositionm;
% y1 = Ypositionm;

x2 = @(offset)[offset(1) + wp_pos_x - wp_perp_x .* wp_width_l * offset(3); NaN; flip(offset(1) + wp_pos_x - wp_perp_x .* wp_width_r * offset(4) )];
y2 = @(offset)[offset(2) + wp_pos_y - wp_perp_y .* wp_width_l * offset(3); NaN; flip(offset(2) + wp_pos_y - wp_perp_y .* wp_width_r * offset(4) )];

fun = @(offset) sum(~inpolygon(x1, y1 ,x2(offset) , y2(offset) ))  + sumsqr(offset(3:4) - 1);

% offset = [362.1563 -161.5479    1.4161    1.5780];
% offset = fminsearch(fun,offset)
fun(offset)

x2 = x2(offset);
y2 = y2(offset);

ind = inpolygon(x1  ,y1  ,x2 ,y2 );

plot(x2, y2); hold on; axis equal;
% plot(path_x, path_y, ':')

plot(x1 , y1,'k')
plot(x1(~ind) , y1(~ind),'rx')
hold off