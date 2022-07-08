function F = function_calculate_model_uncertain(time, u, v, r)
    D = function_calculate_damping_matrix(u, v, r);
    C = function_calculate_centripetal_matrix(u, v, r);
    deltaC = 0.15*sin(0.52*time - 0.12);
    deltaD = -0.25*cos(0.13*time + 0.67);
    F = deltaC*C*[u; v; r] + deltaD*D*[u; v; r];
end