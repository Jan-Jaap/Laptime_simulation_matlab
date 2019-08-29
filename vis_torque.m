
clear
load('GGV\rfs_engine.mat')

rpm = rfs_engine.rpm;  % [rpm]
trq = rfs_engine.trq;  % [Nm]
pwr = rpm/60.*trq*2*pi;      % [W]

% gearbox = [2.923 1.850 1.280 0.969 0.757 4.429];
gearbox = [2.923	1.850	1.360	1.069	0.865	3.688];
ratio = gearbox(1:5) .* gearbox(6);

d_wheel = (15 * 25.4 + 0.55 * 195 * 2) / 1000;
rpm2spd = 1./60 * (1./ratio)* pi * d_wheel;   %[m/s]

spd = rpm * rpm2spd;               %speed
acc = repmat(pwr, size(ratio)) ./ spd;
plot(spd, acc)

hold on
x = linspace(0,100,1000);        %range of speed [m/s]

% y = interp1(rpm, trq, x' * (ratio));
y = interp1(rpm, trq/d_wheel*2, x' * (1./rpm2spd));


ind = isnan(y);
y(ind) = 0;
y = y * diag(ratio);
y(ind) = NaN;
[y, gear] = max(y,[],2);

F = griddedInterpolant(x,y);


gear(isnan(y)) = NaN;
plot(x, F(x))

hold off