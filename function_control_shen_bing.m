function [tau, state_control_new] = function_control_shen_bing(time, reference, dot_reference, ddot_reference, state, state_control, PARAMETERS)
    
    % Parameters
    
    if PARAMETERS.SIMULATION.INITIAL_CONDITIONS == 0
        k1 = 10;
        k2 = 20;
        k3 = 30;
    else
        k1 = 5;
        k2 = 10;
        k3 = 20;
    end
    k4 = 0.0; % Does not work the adaptive scheme !!! The value of H grows continuously. Parameter drift problem !!!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% IF THETA > 0 for all i=1,2,3 implies that  dot_H > 0, so that the value of H continuously grows ???   %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    
    % Read states data
    x = state(1);
    y = state(2);
    yaw = state(3);
    u = state(7); 
    v = state(8);
    r = state(9);

    % Read control states
    x1 = state_control(1:3);
    x2 = [x;y;yaw];
    x3 = [u;v;r];
    
    x1d = state_control(4:6);
    x2d = reference;
    x3d = dot_reference;    
   
    H = state_control(7:9);
    theta2 = norm(x3);
    THETA = 0*[1; theta2; theta2^2];
    
    % System matrices and known dynamics
    ROTATION_MATRIX = function_calculate_rotation_matrix(yaw);
    ROTATION_MATRIX_TRANSPOSE = transpose(ROTATION_MATRIX);
    S = [0 -r 0;r 0 0;0 0 0];
    DOT_ROTATION_MATRIX_TRANSPOSE = -ROTATION_MATRIX_TRANSPOSE*S;
    D = function_calculate_damping_matrix(u, v, r);
    C = function_calculate_centripetal_matrix(u, v, r);
   
    % States transformations
    z1 = x1 - x1d;
    alfa1 = -k1*z1;
    z2 = x2 - x2d - alfa1;
    alfa2 = -ROTATION_MATRIX_TRANSPOSE*(z1 + k1*(x2 - x2d) + k2*z2);
    z3 = x3 - ROTATION_MATRIX_TRANSPOSE*x3d - alfa2;
    dot_z1 = z2 + alfa1;
    dot_alfa1 = -k1*dot_z1;
    dot_z2 = ROTATION_MATRIX*(z3 + alfa2) - dot_alfa1;   
    dot_alfa2 = -DOT_ROTATION_MATRIX_TRANSPOSE*(z1 + k1*(x2 - x2d) + k2*z2) ...
              - ROTATION_MATRIX_TRANSPOSE*(dot_z1 + k1*(ROTATION_MATRIX*x3 - x3d) + k2*dot_z2);

     % System matrices and kwon dynamics
%     CONTROL_MATRIX = function_calculate_control_matrix(ROTATION_MATRIX, PARAMETERS.SHIP.INERTIA_MATRIX_INVERSE);
%     GAMMA = function_calculate_known_dynamics(u, v, r, ROTATION_MATRIX, CONTROL_MATRIX);
%     CONTROL_MATRIX_INVERSE = inv(CONTROL_MATRIX);

    % Control
%     tau =  (-GAMMA -k3*z3 - ROTATION_MATRIX_TRANSPOSE*z2 + C*x3 + D*x3 ...
%         + PARAMETERS.SHIP.INERTIA_MATRIX*(DOT_ROTATION_MATRIX_TRANSPOSE*x3d + ROTATION_MATRIX_TRANSPOSE*ddot_reference + dot_alfa2))
%     tau = -CONTROL_MATRIX_INVERSE*(GAMMA - ddot_reference + k1*dot_z1 + z1 + k2*z2);

    tau = 1*(-k3*z3 - ROTATION_MATRIX_TRANSPOSE*z2 + C*x3 + D*x3 ...
        + PARAMETERS.SHIP.INERTIA_MATRIX*(DOT_ROTATION_MATRIX_TRANSPOSE*x3d + ROTATION_MATRIX_TRANSPOSE*ddot_reference + dot_alfa2));% ...
%         - transpose(H)*THETA*sign(z3);

    % Update control states
    x1 = x1 + x2*PARAMETERS.SIMULATION.SAMPLING_TIME;
    x1d = x1d + x2d*PARAMETERS.SIMULATION.SAMPLING_TIME;
    dot_H = 0*k4*norm(z3)*THETA;
    if norm(z3) < 0.05
        dot_H = 0*dot_H;
    end
%     dot_H
    H = H + dot_H*PARAMETERS.SIMULATION.SAMPLING_TIME;    
   
    % Save control states
    state_control_new = state_control;
    state_control_new(1:3) = x1;
    state_control_new(4:6) = x1d;
    state_control_new(7:9) = H;

end



