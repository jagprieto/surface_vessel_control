function [tau, state_asnsta_control_new] = function_control_asnsta(time, reference, dot_reference, ddot_reference, state_asnsta, state_asnsta_control, PARAMETERS, settling_time)    

    % Read states data
    eta = state_asnsta(1:3); % x, y, yaw
    zeta = state_asnsta(4:6); % dot_x, dot_y, dot_yaw
    yaw = eta(3); 
    u = state_asnsta(7); 
    v = state_asnsta(8);
    r = state_asnsta(9);

    % Compute measurable dynamics
    ROTATION_MATRIX = function_calculate_rotation_matrix(yaw);
    CONTROL_MATRIX = function_calculate_control_matrix(ROTATION_MATRIX, PARAMETERS.SHIP.INERTIA_MATRIX_INVERSE);
    CONTROL_MATRIX_INVERSE = inv(CONTROL_MATRIX);
    GAMMA = function_calculate_known_dynamics(u, v, r, ROTATION_MATRIX, CONTROL_MATRIX);

    % Maneuverabiliy parameters
    V0 = (abs(PARAMETERS.SIMULATION.INITIAL_STATE(1:3))).^(0.5);
    c2 = 2*V0*log(2)/settling_time;
    c1 = c2 ./ V0;
    lambdav = c1 + 0.5*c2/tanh(1);
    gammav = [1; 1; 1];
    kappav = 0.5*c2/tanh(1);
    
    % Read internal control states
    dot_sigma = state_asnsta_control(19:21);
    
    % ASNSTA parameters
    varrho = 15*PARAMETERS.SIMULATION.SAMPLING_TIME*[1;1;1]; 
    omega_c = 2*PARAMETERS.SIMULATION.DISTURBANCE_FREQUENCY_MAX;
    gamma = sqrt(5/2)*(1./varrho);
    lambda = 2*omega_c;
    kappa = PARAMETERS.CONTROL.ANTI_CHATTERING_GAIN.*((0.5./PARAMETERS.SIMULATION.SAMPLING_TIME).*ones(3,1) - lambda) ./ gamma;
    alfa = lambda.^2 / 4;
    p2 = (lambda.^2 +  alfa + 1) ./ (2*lambda.*alfa);
    XI = [max([0.5, p2(1,1)]); max([0.5, p2(2,1)]); max([0.5, p2(3,1)])];
    upsilon_sigma = 4.0*PARAMETERS.SIMULATION.DISTURBANCE_FREQUENCY_MAX.*XI./ sqrt(kappa);
    upsilon_ec = 4.0.*abs(dot_sigma).*XI./ sqrt(kappa);

    % Read internal control states
    if time < PARAMETERS.SIMULATION.SAMPLING_TIME
        zv = eta;
        epsilon_ec = zeros(3,1);
        epsilon_sigma = zeros(3,1);
        delta_ec = gamma;
        delta_sigma = gamma;
    else
        zv = state_asnsta_control(1:3);
        epsilon_ec = state_asnsta_control(4:6);
        epsilon_sigma = state_asnsta_control(7:9);
        delta_ec = state_asnsta_control(10:12); 
        delta_sigma = state_asnsta_control(13:15); 
    end

    % Step 1
    ev = zv - reference;
    dot_zv = - lambdav.*ev  - kappav.*tanh(gammav.*ev) + dot_reference;
    dot_ev = dot_zv - dot_reference;
    ddot_zv =  - lambdav.*dot_ev - kappav.*gammav.*((sech(gammav.*ev)).^2).*dot_ev + ddot_reference;
    
    % Step 2
    ec = eta - zv; 
    beta_ec = zeros(3,1);
    for i = 1:3
        if abs(ec(i)) > varrho(i)
            numerador = kappa(i)*tanh(gamma(i)*ec(i)) + 2*upsilon_ec(i)*sign(ec(i));
            denominador = 2*p2(i)*tanh(delta_ec(i)*ec(i));
            beta_ec(i,1) = numerador / denominador;
        else
            numerador = kappa(i)*tanh(gamma(i)*varrho(i));
            denominador = 2*p2(i)*tanh(delta_ec(i)*varrho(i));
            beta_ec(i,1) = numerador / denominador;  
        end
    end
    delta_ec = PARAMETERS.CONTROL.ANTI_CHATTERING_GAIN.*((0.5/(PARAMETERS.SIMULATION.SAMPLING_TIME^2)).*ones(3,1) - alfa) ./ beta_ec;  
    dot_ec = zeta - dot_zv;
    dot_epsilon_ec = alfa.*ec + beta_ec.*tanh(delta_ec.*ec);
    if time < PARAMETERS.SIMULATION.SAMPLING_TIME
        epsilon_ec = -(dot_ec + lambda.*ec + kappa.*tanh(gamma.*ec)); % Initial conditions to set sigma(0)=0
    else
        epsilon_ec = epsilon_ec + dot_epsilon_ec*PARAMETERS.SIMULATION.SAMPLING_TIME;   % Semi implicit discretization
    end    
    
    % Step 3
    sigma = dot_ec + lambda.*ec + kappa.*tanh(gamma.*ec) + epsilon_ec;        
    beta_sigma = zeros(3,1);
    for i = 1:3
        if abs(sigma(i)) > varrho(i)
            numerador = kappa(i)*tanh(gamma(i)*sigma(i)) + 2*upsilon_sigma(i)*sign(sigma(i));
            denominador = 2*p2(i)*tanh(delta_sigma(i)*sigma(i));
            beta_sigma(i,1) = numerador / denominador;
        else
            numerador = kappa(i)*tanh(gamma(i)*varrho(i));
            denominador = 2*p2(i)*tanh(delta_sigma(i)*varrho(i));
            beta_sigma(i,1) = numerador / denominador;  
        end
    end
    delta_sigma = PARAMETERS.CONTROL.ANTI_CHATTERING_GAIN.*((0.5/(PARAMETERS.SIMULATION.SAMPLING_TIME^2)).*ones(3,1) - alfa) ./ beta_sigma;
    dot_epsilon_sigma = alfa.*sigma + beta_sigma.*tanh(delta_sigma.*sigma);
    epsilon_sigma = epsilon_sigma + dot_epsilon_sigma*PARAMETERS.SIMULATION.SAMPLING_TIME;  % Semi implicit discretization

    % Compute control
    tau = CONTROL_MATRIX_INVERSE*(-GAMMA + ddot_zv - lambda.*dot_ec - kappa.*gamma.*((sech(gamma.*ec)).^2).*dot_ec ...
        - dot_epsilon_ec - lambda.*sigma - kappa.*tanh(gamma.*sigma) - epsilon_sigma);

    % Update and save data
    zv = zv + dot_zv*PARAMETERS.SIMULATION.SAMPLING_TIME; 

    % dot sigma estimation
    ddot_ec = CONTROL_MATRIX*tau + GAMMA + epsilon_sigma - ddot_zv;
    dot_sigma = ddot_ec + lambda.*dot_ec + kappa.*((sech(gamma.*ec)).^2).*dot_ec + dot_epsilon_ec; 

    % Save control state data
    state_asnsta_control_new = state_asnsta_control;
    state_asnsta_control_new(1:3) = zv;
    state_asnsta_control_new(4:6) = epsilon_ec;
    state_asnsta_control_new(7:9) = epsilon_sigma;
    state_asnsta_control_new(10:12) = delta_ec;
    state_asnsta_control_new(13:15) = delta_sigma;
    state_asnsta_control_new(16:18) = sigma;
    state_asnsta_control_new(19:21) = dot_sigma;
end

