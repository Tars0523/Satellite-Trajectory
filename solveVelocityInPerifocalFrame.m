function velocityInPQW = solveVelocityInPerifocalFrame(semimajor_axis, eccentricity, true_anomaly)
    mu = 3.986004418*10^5;
    true_anomaly = deg2rad(true_anomaly);
    
    p=semimajor_axis*(1-eccentricity^2);
    velocityInPQW = sqrt(2*mu/p)*[-sin(true_anomaly) eccentricity+cos(true_anomaly)]';
end