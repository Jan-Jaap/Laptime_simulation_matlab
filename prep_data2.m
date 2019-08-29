clearvars
load('session_zandvoort_laps36-52_20130627_0931_v1.mat')

%% select desired laps

ind = Lap<0;

% for i=[39 40 41 44]
for i=[36:44 49:51]
% for i=41
    ind = or(Lap==i, ind);
end

Lap(~ind)=[];
Distancem(~ind)=[];
Xpositionm(~ind)=[];
Ypositionm(~ind)=[];
Speedms(~ind)=[];
LateralAccelerationG(~ind)=[];
LongitudinalAccelerationG(~ind)=[];

%% set startpoint for each lap to distance traveled zero (dist=0)
dist = Distancem;

for i=unique(Lap)'
    ind = Lap==i;
    dist(ind) = dist(ind) - min(dist(ind));

end


%% sort the data according distance traveled and fit spline
[dist_sorted, ind] = sort(dist);
lap_length = max(dist_sorted);
ind(end)=1;


xx1 = Xpositionm(ind);
yy1 = Ypositionm(ind);

%oh hells yes. I'm on fire....
b = downsample(dist_sorted,uint16(length(dist_sorted)/100));
% disp(length(b))

spline_x = csape(b,xx1(:).'/fnval(csape(b,eye(length(b)),'periodic'),dist_sorted(:).'),'periodic');
spline_y = csape(b,yy1(:).'/fnval(csape(b,eye(length(b)),'periodic'),dist_sorted(:).'),'periodic');
% 

b(end)=0;

x = fnval(spline_x,b);
y = fnval(spline_y,b);
plot(x, y, 'o') ;hold on;

points = [x y]';
spline_track = cscvn(points);




%% plot data
% figure
plot (Xpositionm, Ypositionm); hold on; axis equal


% b = cumsum([0;((diff(points.').^2)*ones(2,1)).^(1/4)]);
xy = fnval(spline_track,spline_track.breaks);
plot(xy(1,:), xy(2,:), 'xk')


b = linspace(0, max(spline_track.breaks), 5000);

xy = fnval(spline_track,b);
l = cumsum([0;(diff(xy.').^2)*ones(2,1).^0.5]);

dxy = fnval(fnder(spline_track, 1),b);
ddxy = fnval(fnder(spline_track, 2),b);


plot(xy(1,:), xy(2,:),'k','LineWidth',2)

% x = xy(1,:);
% y = xy(2,:);
% 
% dx = dxy(1,:);
% dy = dxy(2,:);
% ddx = ddxy(1,:);
% ddy = ddxy(2,:);
% 
% 
% R = (dx.^2 + dy.^2).^(3/2) ./ (dx.*ddy - dy.*ddx);
% 

R = sum(dxy.^2,1).^(3/2) ./ diff(dxy.*flip(ddxy));

% plot(x,y, '.-');
hold on
axis equal
quiver(xy(1,:), xy(2,:), ddxy(1,:), ddxy(2,:));
% plot(fnval(spline_x,1440), fnval(spline_y,1440), 'r*')

hold off

% clearvars -except lap_length spline_track
% 
track_data.spline = spline_track;
track_data.lap_length = lap_length;



% laptime_opt
