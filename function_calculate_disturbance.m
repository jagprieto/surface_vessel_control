function F = function_calculate_disturbance(time, u, v, r)
    F1 = 2*u^3 + 6*sin(u*v) + 50*sin(0.5*time) - 50*sin(0.1*time);
    F2 = 3.2*u^2 + 4.5*sin(v) + 35*sin(0.5*time - (pi/6))  - 50*sin(0.3*time);
    F3 = -0.24*r^3 - 30*sin(0.9*time + (pi/3)) - 30*sin(0.1*time);
    F = [F1; F2; F3];
end