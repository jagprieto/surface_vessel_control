clc;
clear('all');
rng('default');
warning('off','all');

plot_font_size = 16;
nu_x = 9e-3;
alfa = 1;
delta = 0.5;
x = 0:0.001:2;
y_power = alfa*(abs(x).^delta);
lambda = alfa*delta;
beta = alfa*(1-delta); 
gamma =  1/((nu_x^(1-delta))*(1-delta)); 
y_smooth = lambda*abs(x) + beta.*tanh(gamma.*abs(x));

figure(1);
clf(1);
subplot(2,1,1);
plot(x, lambda*abs(x) + beta.*sign(abs(x)),'-', 'Color', 'b', 'Linewidth',2);
hold on;
grid on;
plot(x, y_power,'--', 'Color', 'r', 'Linewidth',2);
xlabel('x', 'FontSize', plot_font_size,'Interpreter','latex');
ylabel('Power vs linear + sign', 'FontSize', plot_font_size,'Interpreter','latex');
title('Power function vs linear + sign function ', 'FontSize', plot_font_size,'Interpreter','latex');
legend({'$\delta |x| + (1-\delta)$', '$|x|^{\delta}$'},'Interpreter','latex', 'Location','SouthEast', 'FontSize', plot_font_size);

subplot(2,1,2);
plot(x, y_smooth,'-', 'Color', 'b', 'Linewidth',2);
hold on;
grid on;
plot(x, y_power,'--', 'Color', 'r', 'Linewidth',2);
xlabel('x', 'FontSize', plot_font_size,'Interpreter','latex');
ylabel('Power vs linear + tanh', 'FontSize', plot_font_size,'Interpreter','latex');
title('Power function vs linear + tanh function ', 'FontSize', plot_font_size,'Interpreter','latex');
legend({'$\delta |x| + (1-\delta) \tanh(\gamma x)$', '$|x|^{\delta}$'},'Interpreter','latex', 'Location','NorthWest', 'FontSize', plot_font_size);

axes('Position',[.55 .20 .3 .1])
box on
plot(x, y_power,'--', 'Color', 'r', 'Linewidth',2);
hold on;
grid on;
plot(x, y_smooth,'-', 'Color', 'b', 'Linewidth',2);
xlim([0, 0.03]);

export_fig('../MANUSCRIPT/GRAPHICS/power_function_approximation.pdf', '-transparent', '-nocrop');
% plot(x, lambda*abs(x) + beta.*sign(abs(x)),'--', 'Color', 'b');
% plot(x, lambda*abs(x),'--', 'Color', 'k');
