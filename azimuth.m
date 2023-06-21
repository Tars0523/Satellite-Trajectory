function az = azimuth(ENU)
    num = size(ENU,1);
    az = zeros(1,num);
    for i = 1 : num
        E = ENU(i,1);
        N = ENU(i,2);
        U = ENU(i,3);
        az(1,i) = atan2(E,N)*180/pi;
        if(az(1,i)<=0)
            az(1,i) = az(1,i) + 360;
        end
    end
end