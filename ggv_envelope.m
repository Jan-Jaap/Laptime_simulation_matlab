clear
load('session_zandvoort_laps36-52_20130627_0931_v1.mat')

%% select data
ind = true(size(Lap));

% for i=[39 40 41 44]
%     ind = or(Lap==i, ind);
% end

Lap(~ind)=[];
Distancem(~ind)=[];
LateralAccelerationG(~ind)=[];
LongitudinalAccelerationG(~ind)=[];
Speedms(~ind)=[];

% 
% [x, y] = ggv(linspace(0,2*pi));
% plot(x, y); hold on;
% 
% % fun = @(x) myfun(x,c);    % function of x alone
% 
% fun = @(x) ggv(x)-1.1; 
% a = fzero(fun,0);
% 
% [x, y] = ggv(a);
% plot(x, y,'o'); hold off;
% 
% 
% % a_lon = sin(acos(a_lat / max_lat_acc)).* 0.25*g;
% 
% ind = LongitudinalAccelerationG>0;
% plot3 (abs(LateralAccelerationG(ind)), Speedkph(ind),LongitudinalAccelerationG(ind))
% grid on
% 
% ind = Power_DXDB10(:,1)>1200;
% rev = Power_DXDB10(ind,1);
% bhp = Power_DXDB10(ind,2);
% 
% figure
% plot(rev, bhp)

n = length(LongitudinalAccelerationG);

plot(LateralAccelerationG,LongitudinalAccelerationG,'.'); hold on; axis equal;  grid on;

%%
% mu = [0 0];
% Sigma = [.25 .3; .3 1];
% x1 = -3:.2:3; x2 = -3:.2:3;
% [X1,X2] = meshgrid(x1,x2);
% F = mvnpdf([X1(:) X2(:)]);
% F = reshape(F,length(x2),length(x1));
% surf(x1,x2,F);
%%


% [xx, yy]= meshgrid(LateralAccelerationG, LongitudinalAccelerationG);
% z = mvnpdf([xx(:) yy(:)]);
% z = reshape(z, n, n);
% surf(LateralAccelerationG, LongitudinalAccelerationG, z)

%%

ind2=true(size(LateralAccelerationG));

% plot(x,y,'g.'); hold on; axis equal;

for i = 1:200
    ind = randsample(n,uint16(n*0.1));

    x = LateralAccelerationG(ind);
    y = LongitudinalAccelerationG(ind);
    
    
    ch = convhull(x,y)';
    
    in = inpolygon(LateralAccelerationG,LongitudinalAccelerationG,x(ch),y(ch));
    ind2 = and(ind2, in);
end

ind = ind2;

plot( LateralAccelerationG(~ind), LongitudinalAccelerationG(~ind),'xr')

x = LateralAccelerationG(ind);
y = LongitudinalAccelerationG(ind);

x = [x; -x];
y = [y; y];

ind = convhull(x, y,'simplify', true);
% ind = convhull(x, y);
% ind = boundary(x, y);
% plot( x(ind), y(ind), 'k','LineWidth',2);
plot( x(ind), y(ind), 'k');
hold off



ggv_lat = x(ind);
ggv_lon = y(ind);
clearvars -except ggv_lat ggv_lon


%% fit spline to the convhull
hold on
plot( ggv_lat, ggv_lon, 'o'); hold on

pp = cscvn([ggv_lat ggv_lon]');
yy = fnval(pp, linspace(0, max(pp.breaks)));

plot(yy(1,:),yy(2,:),'LineWidth', 4), axis equal; hold off