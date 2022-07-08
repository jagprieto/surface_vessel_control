function CENTRIPETAL_MATRIX = function_calculate_centripetal_matrix(u, v, r)
    %CENTRIPETAL_MATRIX = [0 0 -24.6612*v; 0 0 25.8*u; 24.6612*v + 1.0948*r -25.8*u 0];
    c13 = -24.6612*v -1.0948*r;
    c23 = 25.8*u;
    CENTRIPETAL_MATRIX = [0 0 c13; 0 0 c23; -c13 -c23 0];
end