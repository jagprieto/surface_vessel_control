clc;
clear('all');
rng('default');
warning('off','all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIMULATION CONFIGURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PARAMETERS = {};
PARAMETERS.SIMULATION = {};
PARAMETERS.CONTROL = {};
PARAMETERS.DISTURBANCE = {};
PARAMETERS.PLOT = {};
PARAMETERS.SHIP = {};
PARAMETERS.CONTROL = {}; % ASNSTA parameters

PARAMETERS.PLOT.CREATE_PDF = 1;
PARAMETERS.PLOT.FONT_SIZE = 10;
PARAMETERS.PLOT.TAU_MAX = [100; 100; 100];
PARAMETERS.SIMULATION.TOTAL_TIME = 300;
PARAMETERS.SIMULATION.INITIAL_CONDITIONS = 1;
PARAMETERS.SIMULATION.SCENARIO = 2;
PARAMETERS.SIMULATION.SAMPLING_TIME = 1e-2;
PARAMETERS.SIMULATION.DISTURBANCE_FREQUENCY_MAX = 2*[2; 2; 2];%0.2*[.5; .6; .6];
if PARAMETERS.SIMULATION.INITIAL_CONDITIONS == 0
    PARAMETERS.SIMULATION.INITIAL_STATE = [0 0 0 0 0 0 0 0 0]'; % x, y, yaw, dot_x, dot_y, dot_yaw, u, v, r
else
    PARAMETERS.SIMULATION.INITIAL_STATE = [1.2 1.2 pi/3 0 0 0 0 0 0]'; % x, y, yaw, dot_x, dot_y, dot_yaw, u, v, r
end
PARAMETERS.SHIP.INERTIA_MATRIX = [25.8 0 0;0 24.6612 1.0948; 0 1.0948 2.7600];
PARAMETERS.SHIP.INERTIA_MATRIX_INVERSE = inv(PARAMETERS.SHIP.INERTIA_MATRIX);
% PARAMETERS.SHIP.MAXIMUM_VELOCITIES = [1.0; 1.0; 0.1*pi/180.0];
PARAMETERS.CONTROL.ANTI_CHATTERING_GAIN = [0.25;0.25;0.25]; % [0,1] :1 implies no chattering cancellation
% PARAMETERS.CONTROL.ANTI_PEAKING_GAIN = 0.5;  % [0,1] : 1 implies no peaking cancellation
PARAMETERS.CONTROL.SETTLING_TIMES = [1.0; 3.0]; 


simulation_time = 0:PARAMETERS.SIMULATION.SAMPLING_TIME:PARAMETERS.SIMULATION.TOTAL_TIME;
PARAMETERS.SIMULATION.TOTAL_STEPS = size(simulation_time, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIMULATION RUN AND PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SIMULATION_DATA = run_simulation(PARAMETERS);
plot_simulation(SIMULATION_DATA, PARAMETERS);
