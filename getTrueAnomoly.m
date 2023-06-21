function true_ano = getTrueAnomoly(Data,time)
    %% Init
    mu = 3.986004418*10^14; % [m^3/s^-2]
    t_0 = datetime(Data.toc); % [datetime] 
    M_0 = Data.M0; % [rad]
    a = Data.a; % [m]
    delta_t = seconds(time-t_0); % [sec]
    e = Data.e; % [eccentrictiy]
    %% Mean Anomoly
    M = M_0 + sqrt(mu/(a^3))*(delta_t); %[rad]
    while(1)
        if(M<=2*pi)
            break;
        end
        M = M - 2*pi;
    end
    %% Eccentric Anomoly
    E = M;
    while(1)
        E_new = M + e*sin(E);
        if(abs(E_new-E)<0.000001)
            break;
        end
        E = E_new;
    end
    %% True anomoly
    y = sqrt(1-e^2)*sin(E)/(1-e*cos(E));
    x = (cos(E)-e)/(1-e*cos(E));

    true_ano = atan2(y,x);
end