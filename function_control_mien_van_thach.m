function [tau, state_control_new] = function_control_mien_van_thach(time, reference, dot_reference, ddot_reference, state, state_control, PARAMETERS)
    
    % Read states data
    x1 = state(1:3); % x, y, yaw
    x2 = state(4:6); % dot_x, dot_y, dot_yaw
    yaw = x1(3); 
    u = state(7); 
    v = state(8);
    r = state(9);
    nu = 2*PARAMETERS.SIMULATION.SAMPLING_TIME; % Avoid singularity !!

    % System matrices and kwon dynamics
    ROTATION_MATRIX = function_calculate_rotation_matrix(yaw);
    CONTROL_MATRIX = function_calculate_control_matrix(ROTATION_MATRIX, PARAMETERS.SHIP.INERTIA_MATRIX_INVERSE);
    CONTROL_MATRIX_INVERSE = inv(CONTROL_MATRIX);
    GAMMA = function_calculate_known_dynamics(u, v, r, ROTATION_MATRIX, CONTROL_MATRIX);
  
    % Parameters
    K = 15;
    L = 10;
    dot_PSI_x2 = K*[5;5;5]; % It is very sensible to this parameter !!!
    PSI = dot_PSI_x2.*x2;
    gamma1 = 0.75;
    k1 = 10;
    k2 = 20;
    l1 = 10;
    l2 = 10;
    gamma2 = 0.75;

    % Read control states
    if time < PARAMETERS.SIMULATION.SAMPLING_TIME
        est_x2 = x2;
        est_e = zeros(3,1);
        int_epsilon_2 = zeros(3,1);
    else
        est_x2 = state_control(1:3);
        est_e = state_control(4:6);
        int_epsilon_2 = state_control(13:15);
    end
    
    % Disturbance estimation
    disturbance_estimation = est_e + PSI + int_epsilon_2;

    % Finite time control
    z1 = x1 - reference;
    dot_z1 = x2 - dot_reference;
    if abs(z1) > nu
       alfa1 = -k1*z1 + dot_reference - l1*((abs(z1)).^gamma2).*sign(z1);
       dot_alfa1 = -k1*dot_z1 + ddot_reference - l1*gamma2.*((abs(z1)).^(gamma2-1)).*sign(z1).*dot_z1;
    else
       alfa1 = -k1*z1 + dot_reference;
       dot_alfa1 = -k1*dot_z1 + ddot_reference;
    end
    z2 = x2 - alfa1;
    tau = -1*CONTROL_MATRIX_INVERSE*(GAMMA + disturbance_estimation - dot_alfa1 + z1 + k2*z2 + l2*((abs(z2)).^gamma2).*sign(z2));

    % Update control states and save them
    dot_est_x2 = CONTROL_MATRIX*tau + GAMMA + disturbance_estimation;
    dot_est_e = -dot_PSI_x2.*dot_est_x2;    
    dot_int_epsilon_2 = K*tanh(dot_est_x2) + L*((abs(dot_est_x2)).^gamma1).*tanh(dot_est_x2);
    int_epsilon_2 = int_epsilon_2 + dot_int_epsilon_2*PARAMETERS.SIMULATION.SAMPLING_TIME; %% ?? %%
    est_x2 = est_x2 + dot_est_x2*PARAMETERS.SIMULATION.SAMPLING_TIME;
    est_e = est_e + dot_est_e*PARAMETERS.SIMULATION.SAMPLING_TIME;
    
    state_control_new = state_control;
    state_control_new(1:3) = est_x2;
    state_control_new(4:6) = est_e;
    state_control_new(7:9) = tau;
    state_control_new(10:12) = disturbance_estimation;
    state_control_new(13:15) = int_epsilon_2;
end

