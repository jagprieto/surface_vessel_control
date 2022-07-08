function [tau, state_control_new] = function_control_mien_van(time, reference, dot_reference, ddot_reference, state, state_control, PARAMETERS)
    % (2019) An enhanced tracking control of marine surface vessels based on adaptive integral sliding mode control and disturbance observer

    % Read states data
    x1 = state(1:3); % x, y, yaw
    x2 = state(4:6); % dot_x, dot_y, dot_yaw
    yaw = x1(3); 
    u = state(7); 
    v = state(8);
    r = state(9);
    
    % System matrices and kwon dynamics
    ROTATION_MATRIX = function_calculate_rotation_matrix(yaw);
    CONTROL_MATRIX = function_calculate_control_matrix(ROTATION_MATRIX, PARAMETERS.SHIP.INERTIA_MATRIX_INVERSE);
    CONTROL_MATRIX_INVERSE = inv(CONTROL_MATRIX);
    GAMMA = function_calculate_known_dynamics(u, v, r, ROTATION_MATRIX, CONTROL_MATRIX);

    % Parameters
    k1 = 10;
    k2 = 20;
    rho = 100;
    epsilon = 0.5;
    c = 1;
    K = 2*eye(3); 

    % Disturbance observer
    z1 = x1 - reference;
    alfa1 = -k1*z1 + dot_reference;
    z2 = x2 - alfa1;
    dot_z1 = x2 - dot_reference;

    % Sliding surfaces
    if time < PARAMETERS.SIMULATION.SAMPLING_TIME
       state_control(4:6) = -(dot_z1 + K*z1);
    end
    s0 = state_control(4:6);
    s = dot_z1 + K*z1;
    int_sigma = state_control(1:3);    
    sigma = s - s0 - int_sigma;  

    % Control
%     control_swicth = -CONTROL_MATRIX_INVERSE*(rho+epsilon)*sign(sigma);
    control_swicth = -CONTROL_MATRIX_INVERSE*(rho+epsilon)*(sigma./(abs(sigma) + c));
    control_nominal = -CONTROL_MATRIX_INVERSE*(GAMMA - ddot_reference + k1*dot_z1 + z1 + k2*z2);
    tau = 1*(control_swicth + control_nominal);
    int_sigma = int_sigma + (CONTROL_MATRIX*control_nominal + GAMMA - ddot_reference + K*dot_z1)*PARAMETERS.SIMULATION.SAMPLING_TIME;
    state_control_new = state_control;
    state_control_new(1:3) = int_sigma;
end

