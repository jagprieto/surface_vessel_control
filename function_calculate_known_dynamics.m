function DYNAMICS = function_calculate_known_dynamics(u, v, r, ROTATION_MATRIX, CONTROL_MATRIX)
   S = [0 -r 0;r 0 0;0 0 0];
   D = function_calculate_damping_matrix(u, v, r);
   C = function_calculate_centripetal_matrix(u, v, r);
   SIGMA = C*[u; v; r] + D*[u; v; r];
   DYNAMICS = ROTATION_MATRIX*S*[u; v; r] - CONTROL_MATRIX*SIGMA;
end