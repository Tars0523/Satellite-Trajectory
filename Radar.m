function [l__,az__,el__,l__dot,az__dot,el__dot] = Radar(R_radar,az,el,R_eci2enu,R_PQW2ECI,velocityInPQW,R_ECI)
    l__ = R_radar;
    az__ = az;
    el__ = el;
    earth_rot = [0 0 7.292115*10^(-5)]';%[rad/s];
    R_ENU = R_eci2enu*R_ECI;
    Vel_ENU = R_eci2enu*R_PQW2ECI*velocityInPQW-cross(R_eci2enu*earth_rot,R_ENU);
    M = [cosd(el)*sind(az) -R_radar*sind(el)*sind(az) R_radar*cosd(el)*cosd(az);...
        cosd(el)*cosd(az) -R_radar*sind(el)*cosd(az) -R_radar*cosd(el)*sind(az);...
        sind(el) R_radar*cosd(el) 0];
    radar_dot = inv(M)*Vel_ENU;
    l__dot = radar_dot(1);
    az__dot = radar_dot(2);
    el__dot = radar_dot(3);
end