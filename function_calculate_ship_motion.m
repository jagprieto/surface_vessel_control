function [X1_NEW, X2_NEW, U_NEW, disturbance] = function_calculate_ship_motion(time, X1, X2, U, tau, PARAMETERS)
    yaw = X1(3);
    u = U(1);
    v = U(2);
    r = U(3);
    ROTATION_MATRIX = function_calculate_rotation_matrix(yaw);
    CONTROL_MATRIX = function_calculate_control_matrix(ROTATION_MATRIX, PARAMETERS.SHIP.INERTIA_MATRIX_INVERSE);    
    KNOWN_DYNAMICS = function_calculate_known_dynamics(u, v, r, ROTATION_MATRIX, CONTROL_MATRIX);
    F = function_calculate_disturbance(time, u, v, r) - function_calculate_model_uncertain(time, u, v, r);
    disturbance = -CONTROL_MATRIX*F;
    dot_X1 = X2;
    dot_X2 = CONTROL_MATRIX*tau + KNOWN_DYNAMICS + disturbance;    
    X1_NEW = X1 + dot_X1*PARAMETERS.SIMULATION.SAMPLING_TIME;
    X2_NEW = X2 + dot_X2*PARAMETERS.SIMULATION.SAMPLING_TIME;
    U_NEW = ROTATION_MATRIX'*X2;
end