function velocityInPQW = solveVelocityInPerifocalFrame(semimajor_axis, eccentricity, true_anomaly)
    mu = 3.986004418*10^14; % [m^3/s^-2]
    
    p=semimajor_axis*(1-eccentricity^2);
    velocityInPQW = sqrt(mu/p)*[-sin(true_anomaly) eccentricity+cos(true_anomaly) 0]';
end