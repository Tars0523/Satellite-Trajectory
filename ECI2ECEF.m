function DCM = ECI2ECEF(time)
    year = time(1);
    month = time(2);
    day = time(3);
    hour = time(4);
    minute = time(5);
    second = time(6);
    
    %% Calculate Julian date
    if month <= 2
        year = year - 1;
        month = month + 12;
    end
    
    a = floor(year / 100);
    b = 2 - a + floor(a / 4);
    
    jd = floor(365.25 * (year + 4716)) + floor(30.6001 * (month + 1)) + day + b - 1524.5;
    JD = jd + (hour + minute / 60 + second / 3600) / 24;

    %% Calculate GMST
    JD0 = NaN(size(JD));
    JDmin = floor(JD)-.5;
    JDmax = floor(JD)+.5;
    JD0(JD > JDmin) = JDmin(JD > JDmin);
    JD0(JD > JDmax) = JDmax(JD > JDmax);
    H = (JD-JD0).*24;
    D = JD - 2451545.0;    
    D0 = JD0 - 2451545.0;   
    T = D./36525;          
    GMST = mod(6.697374558 + 0.06570982441908.*D0  + 1.00273790935.*H + ...
        0.000026.*(T.^2),24).*15;

    GMST_rad = GMST*pi/180;
    DCM = [cos(GMST_rad) sin(GMST_rad) 0; -sin(GMST_rad) cos(GMST_rad) 0; 0 0 1];
    
end