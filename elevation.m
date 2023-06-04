function el = elevation(ENU, el_mask)
    num = size(ENU,1);
    el = zeros(1,num);
    for i = 1 : num
        E = ENU(i,1);
        N = ENU(i,2);
        U = ENU(i,3);
        el(1,i) = atan2(U,sqrt(E^2+N^2))*180/pi;
        if(el(1,i)<=el_mask)
            el(1,i) = NaN;
        end
    end
end