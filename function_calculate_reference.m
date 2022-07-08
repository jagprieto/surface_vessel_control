function [reference, dot_reference, ddot_reference] = function_calculate_reference(time, SCENARIO)
    if SCENARIO == 1
        reference = 1*[4*sin(0.02*time); 2.5*(1-cos(0.02*time)); 0.02*time];
        dot_reference = 1*[0.02*4*cos(0.02*time); 0.02*2.5*sin(0.02*time); 0.02];
        ddot_reference = 1*[-0.02*0.02*4*sin(0.02*time); 0.02*0.02*2.5*cos(0.02*time); 0];
    else
        reference = [4*sin(0.02*time) + 2*cos(0.02*time); 2.5*(1-cos(0.02*time)) + 0.5*sin(0.02*time); 0.02*time + 0.5*sin(0.02*time)];
        dot_reference = [0.02*4*cos(0.02*time) - 0.02*2*sin(0.02*time); 0.02*2.5*sin(0.02*time) + 0.02*0.5*cos(0.02*time); 0.02 + 0.02*0.5*cos(0.02*time)];
        ddot_reference = [-0.02*0.02*4*sin(0.02*time) - 0.02*0.02*2*cos(0.02*time) ; 0.02*0.02*2.5*cos(0.02*time) - 0.02*0.02*0.5*sin(0.02*time); - 0.02*0.02*0.5*sin(0.02*time)];
    end
end