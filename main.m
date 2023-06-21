clear;
clc;
close all;

nav_data = load("nav.mat"); 
GPS = nav_data.nav.GPS;
QZSS = nav_data.nav.QZSS;
BDS = nav_data.nav.BDS;
%% set init 
time = datetime(GPS.toc);
idx = 1;
%% 
while(1)
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
    %% ECI to ECEF
    r_ecef = eci2ecef(time,R_ECI);
    
    %% ECEF to ENU
    % sju chungmugwan rooftop
    lat0 = 37.552289;% [rad]
    lon0 = 127.073979; % [rad]
    h0 = 40 ; %[m]
    wgs84 = wgs84Ellipsoid('meter');
    [xEast,yNorth,zUp] = ecef2enu(r_ecef(1),r_ecef(2),r_ecef(3),lat0,lon0,h0,wgs84);
    %% ECI to ENU DCM
    % DCM ecef2enu
    R_ecef2enu = [1 0 0;...
                  0 cosd(90-lat0) sind(90-lat0);...
                  0 -sind(90-lat0) cosd(90-lat0)]*[cosd(90+lon0) sind(90+lon0) 0;...
                                                    -sind(90+lon0) cosd(90+lon0) 0;...
                                                    0 0 1];
    R_eci2ecef = dcmeci2ecef('IAU-2000/2006',time);
    R_eci2enu = R_ecef2enu*R_eci2ecef;
    [Vel_E,Vel_N,Vel_U] = VEl_ENU(R_eci2enu,R_PQW2ECI,velocityInPQW,R_ECI);
    %% ECEF tto geodetic
    lla = ecef2lla(r_ecef');
    %% ENU to azimuth & elevation
    az = azimuth([xEast,yNorth,zUp]);
    el = elevation_([xEast,yNorth,zUp], 0);
    %% Radar Measurement
    if (isnan(el)~=1)
        R_radar = norm([xEast,yNorth,zUp]);
        [l__,az__,el__,l__dot,az__dot,el__dot] = Radar(R_radar,az,el,R_eci2enu,R_PQW2ECI,velocityInPQW,R_ECI);
        Radar_measurement = [l__,az__,el__,l__dot,az__dot,el__dot];
    end
    %% Visualization
    
    % true anomaly & ECI position
    figure(1)
    subplot(1,2,1)
    scatter(time,true_anomoly*180/pi,'k');
    hold on;
    grid on;
    drawnow
    subplot(1,2,2)
    scatter3(R_ECI(1),R_ECI(2),R_ECI(3),'b');
    hold on;
    drawnow
    
    % sky plot
    figure(2)
    GPS_az(idx) = az;
    GPS_el(idx) = el;
    skyplot(GPS_az,GPS_el);
    % Ground Track
    figure(3)
    lat(idx) = lla(1);
    lon(idx) = lla(2);
    geoplot(lat,lon);
    
    %% update time,idx
    time = time + hours;
    idx = idx + 1 ;
end
