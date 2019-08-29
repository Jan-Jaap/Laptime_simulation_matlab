function err = laptime_eval(ggv_const, track_data, logged_vel, F)

    [t, res] = laptime_sim(track_data, ggv_const, F);
    simuld_vel = timeseries(res.v, res.s);
    [logged_vel, simuld_vel] = synchronize(logged_vel,simuld_vel,'Uniform','Interval',5);
    err = [logged_vel.Data - simuld_vel.Data];
    
%     ind = ts<0;
%     ts(ind) = ts(ind) * -0.5;
%     err = sqrt(abs(ts));
    


%     i = err>0;
%     err(i) = err(i).*10;
%     err = sum(err.^2);
        

%     err = abs(tanh(ts));

end



