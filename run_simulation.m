function [SIMULATION_DATA, PARAMETERS] = run_simulation(PARAMETERS)
     
    % Prepare simulation data
    SIMULATION_DATA = {};
    SIMULATION_DATA.REFERENCE = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); % x, y, yaw
    SIMULATION_DATA.DOT_REFERENCE = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); % dot_x, dot_y, dot_yaw
    SIMULATION_DATA.DDOT_REFERENCE = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); % dot_x, dot_y, dot_yaw
    SIMULATION_DATA.TIME = zeros(1, PARAMETERS.SIMULATION.TOTAL_STEPS);
    
    SIMULATION_DATA.DISTURBANCE_ASNSTA = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    SIMULATION_DATA.STATE_ASNSTA = zeros(9, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    state_asnsta = PARAMETERS.SIMULATION.INITIAL_STATE; % x, y, yaw, dot_x, dot_y, dot_yaw, u, v, r
    SIMULATION_DATA.CONTROL_STATE_ASNSTA = zeros(25, PARAMETERS.SIMULATION.TOTAL_STEPS);  %z1; %epsilon_e; epsilon_sigma
    state_asnsta_control = zeros(25,1);
    SIMULATION_DATA.CONTROL_ASNSTA = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); % tau1, tau2, tau3
    
    SIMULATION_DATA.DISTURBANCE_ASNSTB = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    SIMULATION_DATA.STATE_ASNSTB = zeros(9, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    state_asnstb = PARAMETERS.SIMULATION.INITIAL_STATE;
    SIMULATION_DATA.CONTROL_STATE_ASNSTB = zeros(25, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    state_asnstb_control = zeros(25,1);
    SIMULATION_DATA.CONTROL_ASNSTB = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS);
    
    SIMULATION_DATA.DISTURBANCE_SHEN_BING = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    SIMULATION_DATA.STATE_SHEN_BING = zeros(9, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    state_shen_bing = PARAMETERS.SIMULATION.INITIAL_STATE;
    SIMULATION_DATA.CONTROL_STATE_SHEN_BING = zeros(20, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    state_shen_bing_control = zeros(20,1);
    SIMULATION_DATA.CONTROL_SHEN_BING = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS);

    SIMULATION_DATA.DISTURBANCE_MIEN_VAN = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    SIMULATION_DATA.STATE_MIEN_VAN = zeros(9, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    state_mien_van = PARAMETERS.SIMULATION.INITIAL_STATE; 
    SIMULATION_DATA.CONTROL_STATE_MIEN_VAN = zeros(20, PARAMETERS.SIMULATION.TOTAL_STEPS);
    state_mien_van_control = zeros(20,1);
    SIMULATION_DATA.CONTROL_MIEN_VAN = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); % tau1, tau2, tau3
    
    SIMULATION_DATA.DISTURBANCE_MIEN_VAN_THACH = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    SIMULATION_DATA.STATE_MIEN_VAN_THACH = zeros(9, PARAMETERS.SIMULATION.TOTAL_STEPS); 
    state_mien_van_thach = PARAMETERS.SIMULATION.INITIAL_STATE; 
    SIMULATION_DATA.CONTROL_STATE_MIEN_VAN_THACH = zeros(20, PARAMETERS.SIMULATION.TOTAL_STEPS);
    state_mien_van_thach_control = zeros(20,1);
    SIMULATION_DATA.CONTROL_MIEN_VAN_THACH = zeros(3, PARAMETERS.SIMULATION.TOTAL_STEPS); % tau1, tau2, tau3

    % Run simulation
    simulation_time = 0.0;
   
    for simulation_step = 1:PARAMETERS.SIMULATION.TOTAL_STEPS
        % Compute reference
        [reference, dot_reference, ddot_reference] = function_calculate_reference(simulation_time, PARAMETERS.SIMULATION.SCENARIO);

        % Save history data
        SIMULATION_DATA.TIME (:, simulation_step) = simulation_time;
        SIMULATION_DATA.STATE_ASNSTA(:, simulation_step) = state_asnsta;
        SIMULATION_DATA.STATE_ASNSTB(:, simulation_step) = state_asnstb;
        SIMULATION_DATA.STATE_SHEN_BING(:, simulation_step) = state_shen_bing;
        SIMULATION_DATA.STATE_MIEN_VAN(:, simulation_step) = state_mien_van;
        SIMULATION_DATA.STATE_MIEN_VAN_THACH (:, simulation_step) = state_mien_van_thach;
        SIMULATION_DATA.REFERENCE(:, simulation_step) = reference;
        SIMULATION_DATA.DOT_REFERENCE = dot_reference;
        SIMULATION_DATA.DDOT_REFERENCE = ddot_reference;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASNSTA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute control
        settling_time = PARAMETERS.CONTROL.SETTLING_TIMES(1);
        [tau_asnsta, state_asnsta_control] = function_control_asnsta(simulation_time, reference, dot_reference, ddot_reference, state_asnsta, state_asnsta_control, PARAMETERS, settling_time);
        
        % Run ship dynamics
        [X1_asnsta, X2_asnsta, U_asnsta, disturbance_asnsta] = function_calculate_ship_motion(simulation_time, state_asnsta(1:3), state_asnsta(4:6), state_asnsta(7:9), tau_asnsta, PARAMETERS);
        
        % Save history data
        SIMULATION_DATA.CONTROL_ASNSTA(:, simulation_step) = tau_asnsta;
        SIMULATION_DATA.CONTROL_STATE_ASNSTA(:, simulation_step) = state_asnsta_control;
        SIMULATION_DATA.DISTURBANCE_ASNSTA(:, simulation_step) = disturbance_asnsta;

        % Update state
        state_asnsta(1:3) = X1_asnsta;
        state_asnsta(4:6) = X2_asnsta;
        state_asnsta(7:9) = U_asnsta;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASNSTB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute control
        settling_time = PARAMETERS.CONTROL.SETTLING_TIMES(2);
        [tau_asnstb, state_asnstb_control] = function_control_asnsta(simulation_time, reference, dot_reference, ddot_reference, state_asnstb, state_asnstb_control, PARAMETERS, settling_time);
        
        % Run ship dynamics
        [X1_asnstb, X2_asnstb, U_asnstb, disturbance_asnstb] = function_calculate_ship_motion(simulation_time, state_asnstb(1:3), state_asnstb(4:6), state_asnstb(7:9), tau_asnstb, PARAMETERS);
        
        % Save history data
        SIMULATION_DATA.CONTROL_ASNSTB(:, simulation_step) = tau_asnstb;
        SIMULATION_DATA.CONTROL_STATE_ASNSTB(:, simulation_step) = state_asnstb_control;
        SIMULATION_DATA.DISTURBANCE_ASNSTB(:, simulation_step) = disturbance_asnstb;

        % Update state
        state_asnstb(1:3) = X1_asnstb;
        state_asnstb(4:6) = X2_asnstb;
        state_asnstb(7:9) = U_asnstb;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SHEN_BING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute control
        [tau_shen_bing, state_shen_bing_control] = function_control_shen_bing(simulation_time, reference, dot_reference, ddot_reference, state_shen_bing, state_shen_bing_control, PARAMETERS);

        % Run ship dynamics
        [X1_shen_bing, X2_shen_bing, U_shen_bing, disturbance_shen_bing] = function_calculate_ship_motion(simulation_time, state_shen_bing(1:3), state_shen_bing(4:6), state_shen_bing(7:9), tau_shen_bing, PARAMETERS);
        
        % Save history data
        SIMULATION_DATA.CONTROL_SHEN_BING(:, simulation_step) = tau_shen_bing;
        SIMULATION_DATA.CONTROL_STATE_SHEN_BING(:, simulation_step) = state_shen_bing_control;
        SIMULATION_DATA.DISTURBANCE_SHEN_BING(:, simulation_step) = disturbance_shen_bing;
      
        % Update state
        state_shen_bing(1:3) = X1_shen_bing;
        state_shen_bing(4:6) = X2_shen_bing;
        state_shen_bing(7:9) = U_shen_bing;
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MIEN_VAN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute control
        [tau_mien_van, state_mien_van_control] = function_control_mien_van(simulation_time, reference, dot_reference, ddot_reference, state_mien_van, state_mien_van_control, PARAMETERS);
        
        % Run ship dynamics
        [X1_mien_van, X2_mien_van, U_mien_van, disturbance_mien_van] = function_calculate_ship_motion(simulation_time, state_mien_van(1:3), state_mien_van(4:6), state_mien_van(7:9), tau_mien_van, PARAMETERS);
        
        % Save history data
        SIMULATION_DATA.CONTROL_MIEN_VAN(:, simulation_step) = tau_mien_van;
        SIMULATION_DATA.CONTROL_STATE_MIEN_VAN(:, simulation_step) = state_mien_van_control;
        SIMULATION_DATA.DISTURBANCE_MIEN_VAN(:, simulation_step) = disturbance_mien_van;

        % Update state
        state_mien_van(1:3) = X1_mien_van;
        state_mien_van(4:6) = X2_mien_van;
        state_mien_van(7:9) = U_mien_van;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MIEN_VAN_THACH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute control
        [tau_mien_van_thach, state_mien_van_thach_control] = function_control_mien_van_thach(simulation_time, reference, dot_reference, ddot_reference, state_mien_van_thach, state_mien_van_thach_control, PARAMETERS);
        
        % Run ship dynamics
        [X1_mien_van_thach, X2_mien_van_thach, U_mien_van_thach, disturbance_mien_van_thach] = function_calculate_ship_motion(simulation_time, state_mien_van_thach(1:3), state_mien_van_thach(4:6), state_mien_van_thach(7:9), tau_mien_van_thach, PARAMETERS);
        
        % Save history data
        SIMULATION_DATA.CONTROL_MIEN_VAN_THACH(:, simulation_step) = tau_mien_van_thach;
        SIMULATION_DATA.CONTROL_STATE_MIEN_VAN_THACH(:, simulation_step) = state_mien_van_thach_control;
        SIMULATION_DATA.DISTURBANCE_MIEN_VAN_THACH(:, simulation_step) = disturbance_mien_van_thach;

        % Update state
        state_mien_van_thach(1:3) = X1_mien_van_thach;
        state_mien_van_thach(4:6) = X2_mien_van_thach;
        state_mien_van_thach(7:9) = U_mien_van_thach;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Update time
        simulation_time = simulation_time + PARAMETERS.SIMULATION.SAMPLING_TIME;
    end
end
        