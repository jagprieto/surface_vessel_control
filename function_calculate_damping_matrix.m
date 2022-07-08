function DAMPING_MATRIX = function_calculate_damping_matrix(u, v, r)
    d11 = 0.7225 + 1.3274*abs(u)+ 5.8664*(u^2);
    d22 = 0.8612 + 36.2823*abs(v) + 8.05*abs(r);
    d23 = - 0.1079 + 0.845*abs(v) + 3.45*abs(r);
    d32 = -0.1025 -5.0437*abs(v) - 0.13*abs(r);
    d33 = 1.9 - 0.08*abs(u) + 0.75*abs(r);
    DAMPING_MATRIX = [d11, 0, 0; 0, d22, d23; 0, d32, d33];
end