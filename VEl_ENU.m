function  [Vel_E,Vel_N,Vel_U] = VEl_ENU(R_eci2enu,R_PQW2ECI,velocityInPQW,R_ECI)
    earth_rot = [0 0 7.292115*10^(-5)]';%[rad/s]
    R_ENU = R_eci2enu*R_ECI;
    Vel_ENU = R_eci2enu*R_PQW2ECI*velocityInPQW-cross(R_eci2enu*earth_rot,R_ENU);
    Vel_E = Vel_ENU(1);
    Vel_N = Vel_ENU(2);
    Vel_U = Vel_ENU(3);
end