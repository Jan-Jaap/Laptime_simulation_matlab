clearvars

% close all; 
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
Timestamps(~ind)=[];

%% set startpoint for each lap to distance traveled zero (dist=0)
dist = Distancem;

% for i=unique(Lap)'
%     ind = Lap==i;
%     dist(ind) = dist(ind) - min(dist(ind));
% 
% end
% 
% 
% %% sort the data according distance traveled and fit spline
% [dist_sorted, ind] = sort(dist);
% lap_length = max(dist_sorted);
% ind(end)=1;

% 
% xx1 = Xpositionm(ind);
% yy1 = Ypositionm(ind);



% x = Xpositionm(ind);
% y = Ypositionm(ind);
x = Xpositionm;
y = Ypositionm;

% figure
plot (x,y, 'b.'); hold on
axis equal


%%



d = designfilt('lowpassiir', 'PassbandFrequency', 10, ...
               'StopbandFrequency', 20, 'PassbandRipple', 1, ...
               'StopbandAttenuation', 20, 'SampleRate', 400, ...
               'DesignMethod', 'butter');

x = filtfilt(d, x);
y = filtfilt(d, y);

   
% 
% 
% xf = fft(x);
% yf = fft(y);
% 
% % xft = fft2(x, t)
% 
% 
% fre = 30; % lower frequencies to keep
% %low pass filter
% xf(1+fre:end-fre) = 0; % set higher frequencies to zero
% yf(1+fre:end-fre) = 0; % set higher frequencies to zero
% 
% 
% %differentiation via the FFT is just a matter of scaling the Fourier coefficients. 
% nx = length(xf);
% hx = ceil(nx/2)-1;
% ftdiff = (2i*pi/nx)*(0:hx);
% ftdiff(nx:-1:nx-hx+1) = -ftdiff(2:hx+1);
% % ftddiff = (-(2*pi/nx)^2)*(0:hx);  %this method looks ill behaved. Cant find why this is happening
% % ftddiff(nx:-1:nx-hx+1) = ftddiff(1:hx);
% 
% x = real(ifft(xf));
% y = real(ifft(yf));
% dx = real(ifft(xf.*ftdiff'));
% dy = real(ifft(yf.*ftdiff'));
% ddx = real(ifft(xf.*ftdiff'.^2));
% ddy = real(ifft(yf.*ftdiff'.^2));
% % ddx = real(ifft(xf.*ftddiff'));
% % ddy = real(ifft(yf.*ftddiff'));

%%

plot (x,y,'k.-');
% quiver(x, y, ddx, ddy);
hold off

% c = (dx.*ddy-dy.*ddx) ./ (dx.^2 + dy.^2) .^ (3/2);  
% R = (dx.^2 + dy.^2) .^ (3/2) ./ (dx.*ddy-dy.*ddx);

% figure
% plot(c);

% hold off
