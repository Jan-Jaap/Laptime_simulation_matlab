clc

% x0 = 30;
fun = @(x0) fft_laptime_vis(x0);
% v = fminsearch(fun, x0);

t = fft_laptime_vis(x);
% disp(['Laptime in simulated lap = ' datestr(t / (24*60*60), 'hh:MM:SS.FFF')]) 
