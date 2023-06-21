nav_data = load("nav.mat"); 
GPS = nav_data.nav.GPS;
QZSS = nav_data.nav.QZSS;
BDS = nav_data.nav.BDS;

%% True Anomomly
while(1)
    %% set time 
    time = datetime(GPS.toc);
    %% true anomoly
    true_anomoly = getTrueAnomoly(GPS,time);
    %% PQW2ECI
    R_PQW2ECI = PQW2ECI(GPS.omega,GPS.i,GPS.OMEGA);
    %% r at PQW
    rangeInPQW=solveRangeInPerifocalFrame(GPS.a, GPS.e, true_anomoly);
    %% r PQW to ECI
    R_ECI = R_PQW2ECI*rangeInPQW;
    %% v at PQW
    velocityInPQW = solveVelocityInPerifocalFrame(GPS.a, GPS.e, true_anomoly);
    %% update time
    time = time + hours;
    scatter3(R_ECI(0),R_ECI(1),R_ECI(2));
    hold on;
    drawnow;
end
