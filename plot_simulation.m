
% Plot simulation 
function plot_simulation(SIMULATION_DATA, PARAMETERS)
    
    plot_legends = {'ASNSTA (t_s=1 s)','ASNSTA (t_s=3 s)','AIB', 'AISMC+DO', 'GFTBC'};
    plot_legends_with_reference = {'Reference trajectory', 'ASNSTA (t_s=1 s)','ASNSTA (t_s=3 s)','AIB', 'AISMC+DO', 'GFTBC'};

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIGURE 1 : TRAJECTORY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig1 = figure(1);
    clf(fig1);
    plot(SIMULATION_DATA.REFERENCE(1,:), SIMULATION_DATA.REFERENCE(2,:),'-', 'Color', [0.7, 0.7, 0.7], 'LineWidth',1.0);
    grid on;
    hold on;
    plot(SIMULATION_DATA.STATE_ASNSTA(1,:), SIMULATION_DATA.STATE_ASNSTA(2,:),'--', 'Color', 'r', 'LineWidth',1.0);
    plot(SIMULATION_DATA.STATE_ASNSTB(1,:), SIMULATION_DATA.STATE_ASNSTB(2,:),'--', 'Color', 'm', 'LineWidth',1.0);
    plot(SIMULATION_DATA.STATE_SHEN_BING(1,:), SIMULATION_DATA.STATE_SHEN_BING(2,:),'--', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);
    plot(SIMULATION_DATA.STATE_MIEN_VAN(1,:), SIMULATION_DATA.STATE_MIEN_VAN(2,:),'--', 'Color', 'k', 'LineWidth',1.0);
    plot(SIMULATION_DATA.STATE_MIEN_VAN_THACH(1,:), SIMULATION_DATA.STATE_MIEN_VAN_THACH(2,:),'--', 'Color', 'b', 'LineWidth',1.0);
    xlabel ('x-coordinate');
    ylabel ('y-coordinate');
    title('Ship trayectories');
    xlim([-6,5]);
    ylim([-1,5.5]);
    legend(plot_legends_with_reference);
    if PARAMETERS.PLOT.CREATE_PDF
        graph_file_path = strcat('../MANUSCRIPT/GRAPHICS/scenario_', num2str(PARAMETERS.SIMULATION.SCENARIO),'_ic_',num2str(PARAMETERS.SIMULATION.INITIAL_CONDITIONS),'_trajectory.pdf')
        export_fig(graph_file_path, '-transparent', '-nocrop');
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIGURE 2  : CONTROL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig2 = figure(2);
    clf(fig2);
    if PARAMETERS.SIMULATION.INITIAL_CONDITIONS > 0
        subplot(3,2,1);
    else
        subplot(3,1,1);
    end
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTA(1,:),'-', 'Color', 'r', 'LineWidth',1.0);    
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTB(1,:),'-', 'Color', 'm', 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_SHEN_BING(1,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);   
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN(1,:),'-', 'Color', 'k', 'LineWidth',1.0);  
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN_THACH(1,:),'-', 'Color', 'b', 'LineWidth',1.0);  
    xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);  
    ylabel('$\tau_1(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    title('Control in axis x [N]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    ylim([-PARAMETERS.PLOT.TAU_MAX(1), PARAMETERS.PLOT.TAU_MAX(1)]);
    
    if PARAMETERS.SIMULATION.INITIAL_CONDITIONS > 0
        subplot(3,2,2);
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTA(1,:),'-', 'Color', 'r', 'LineWidth',1.0);    
        grid on;
        hold on; 
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTB(1,:),'-', 'Color', 'm', 'LineWidth',1.0); 
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_SHEN_BING(1,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0); 
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN(1,:),'-', 'Color', 'k', 'LineWidth',1.0); 
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN_THACH(1,:),'-', 'Color', 'b', 'LineWidth',1.0);
        ylabel('$\tau_1(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
        xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
        xlim([0, 0.5]);
        subplot(3,2,3);
    else
        subplot(3,1,2);
    end

    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTA(2,:),'-', 'Color', 'r', 'LineWidth',1.0);    
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTB(2,:),'-', 'Color', 'm', 'LineWidth',1.0);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_SHEN_BING(2,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN(2,:),'-', 'Color', 'k', 'LineWidth',1.0);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN_THACH(2,:),'-', 'Color', 'b', 'LineWidth',1.0);
    xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);  
    ylabel('$\tau_2(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    ylim([-PARAMETERS.PLOT.TAU_MAX(2), PARAMETERS.PLOT.TAU_MAX(2)]);
    title('Control in axis y [N]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    

    if PARAMETERS.SIMULATION.INITIAL_CONDITIONS > 0
        subplot(3,2,4);
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTA(2,:),'-', 'Color', 'r', 'LineWidth',1.0);    
        grid on;
        hold on; 
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTB(2,:),'-', 'Color', 'm', 'LineWidth',1.0); 
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_SHEN_BING(2,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN(2,:),'-', 'Color', 'k', 'LineWidth',1.0);   
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN_THACH(2,:),'-', 'Color', 'b', 'LineWidth',1.0);
        ylabel('$\tau_2(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
        xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
        xlim([0, 0.5]);
        legend(plot_legends);
        subplot(3,2,5);
    else
        subplot(3,1,3);
    end
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTA(3,:),'-', 'Color', 'r', 'LineWidth',1.0);    
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTB(3,:),'-', 'Color', 'm', 'LineWidth',1.0);  
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_SHEN_BING(3,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN(3,:),'-', 'Color', 'k', 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN_THACH(3,:),'-', 'Color', 'b', 'LineWidth',1.0);
    xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);  
    ylabel('$\tau_3(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    title('Control in orientation angle [N]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    ylim([-PARAMETERS.PLOT.TAU_MAX(3), PARAMETERS.PLOT.TAU_MAX(3)]);
    if PARAMETERS.SIMULATION.INITIAL_CONDITIONS > 0
        subplot(3,2,6);
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTA(3,:),'-', 'Color', 'r', 'LineWidth',1.0);    
        grid on;
        hold on; 
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_ASNSTB(3,:),'-', 'Color', 'm', 'LineWidth',1.0);
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_SHEN_BING(3,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN(3,:),'-', 'Color', 'k', 'LineWidth',1.0);  
        plot(SIMULATION_DATA.TIME, SIMULATION_DATA.CONTROL_MIEN_VAN_THACH(3,:),'-', 'Color', 'b', 'LineWidth',1.0);
        ylabel('$\tau_3(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
        xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
        xlim([0, 0.5]);
    end
    if PARAMETERS.PLOT.CREATE_PDF
        graph_file_path = strcat('../MANUSCRIPT/GRAPHICS/scenario_', num2str(PARAMETERS.SIMULATION.SCENARIO),'_ic_',num2str(PARAMETERS.SIMULATION.INITIAL_CONDITIONS),'_control.pdf')
        export_fig(graph_file_path, '-transparent', '-nocrop');
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIGURE 3  : ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig3 = figure(3);
    clf(fig3);
    subplot(3,1,1);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(1,:) - SIMULATION_DATA.STATE_ASNSTA(1,:),'-', 'Color', 'r', 'LineWidth', 1.0);    
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(1,:) - SIMULATION_DATA.STATE_ASNSTB(1,:),'-', 'Color', 'm', 'LineWidth',1.0);    
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(1,:) - SIMULATION_DATA.STATE_SHEN_BING(1,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);    
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(1,:) - SIMULATION_DATA.STATE_MIEN_VAN(1,:),'-', 'Color', 'k', 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(1,:) - SIMULATION_DATA.STATE_MIEN_VAN_THACH(1,:),'-', 'Color', 'b', 'LineWidth',1.0);  
    xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);  
    ylabel('$e_x(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    title('Relative error in axis x [m]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');

        axes('Position',[.55 .75 .3 .1])
        box on
        detail_time = 30;
        from_step = ceil(PARAMETERS.SIMULATION.TOTAL_STEPS - (detail_time/PARAMETERS.SIMULATION.SAMPLING_TIME));
        if from_step > 0
            from_to_detail = from_step:PARAMETERS.SIMULATION.TOTAL_STEPS;    
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_ASNSTA(1,from_to_detail),'-', 'Color', 'r', 'LineWidth',1.0);    
            grid on;
            hold on;
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_ASNSTB(1,from_to_detail),'-', 'Color', 'm', 'LineWidth',1.0);    
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_SHEN_BING(1,from_to_detail),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);    
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN(1,from_to_detail),'-', 'Color', 'k', 'LineWidth',1.0);    
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN_THACH(1,from_to_detail),'-', 'Color', 'b', 'LineWidth',1.0);    
            xlim([from_step*PARAMETERS.SIMULATION.SAMPLING_TIME, PARAMETERS.SIMULATION.TOTAL_TIME]);
            ylim(1e-3*[-0.1,0.1]);            
        end

        if norm(PARAMETERS.SIMULATION.INITIAL_CONDITIONS) > 0
            axes('Position',[.15 .75 .3 .1])
            box on
            detail_time = 4.0;
            to_step = ceil((detail_time/PARAMETERS.SIMULATION.SAMPLING_TIME));
            if to_step > 0
                from_to_detail = 1:to_step;
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_ASNSTA(1,from_to_detail),'-', 'Color', 'r', 'LineWidth',1.0);    
                grid on;
                hold on;
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_ASNSTB(1,from_to_detail),'-', 'Color', 'm', 'LineWidth',1.0);    
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_SHEN_BING(1,from_to_detail),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);    
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN(1,from_to_detail),'-', 'Color', 'k', 'LineWidth',1.0);    
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(1,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN_THACH(1,from_to_detail),'-', 'Color', 'b', 'LineWidth',1.0);    
                xlim([0, detail_time]);          
            end
        end

    subplot(3,1,2);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(2,:) - SIMULATION_DATA.STATE_ASNSTA(2,:),'-', 'Color', 'r', 'LineWidth',1.0);    
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(2,:) - SIMULATION_DATA.STATE_ASNSTB(2,:),'-', 'Color', 'm', 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(2,:) - SIMULATION_DATA.STATE_SHEN_BING(2,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);  
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(2,:) - SIMULATION_DATA.STATE_MIEN_VAN(2,:),'-', 'Color', 'k', 'LineWidth',1.0);  
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.REFERENCE(2,:) - SIMULATION_DATA.STATE_MIEN_VAN_THACH(2,:),'-', 'Color', 'b', 'LineWidth',1.0);   
    xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);  
    ylabel('$e_y(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    title('Relative error in axis y [m]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');

        axes('Position',[.55 .45 .3 .1])
        box on
        detail_time = 30;
        from_step = ceil(PARAMETERS.SIMULATION.TOTAL_STEPS - (detail_time/PARAMETERS.SIMULATION.SAMPLING_TIME));
        if from_step > 0
            from_to_detail = from_step:PARAMETERS.SIMULATION.TOTAL_STEPS;    
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_ASNSTA(2,from_to_detail),'-', 'Color', 'r', 'LineWidth',1.0);    
            grid on;
            hold on;
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_ASNSTB(2,from_to_detail),'-', 'Color', 'm', 'LineWidth',1.0);    
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_SHEN_BING(2,from_to_detail),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);    
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN(2,from_to_detail),'-', 'Color', 'k', 'LineWidth',1.0);    
            plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN_THACH(2,from_to_detail),'-', 'Color', 'b', 'LineWidth',1.0);    
            xlim([from_step*PARAMETERS.SIMULATION.SAMPLING_TIME, PARAMETERS.SIMULATION.TOTAL_TIME]);
            ylim(1e-3*[-0.1,0.1]);
        end

        if norm(PARAMETERS.SIMULATION.INITIAL_CONDITIONS) > 0
            axes('Position',[.15 .45 .3 .1])
            box on
            detail_time = 4.0;
            to_step = ceil((detail_time/PARAMETERS.SIMULATION.SAMPLING_TIME));
            if to_step > 0
                from_to_detail = 1:to_step;
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_ASNSTA(2,from_to_detail),'-', 'Color', 'r', 'LineWidth',1.0);    
                grid on;
                hold on;
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_ASNSTB(2,from_to_detail),'-', 'Color', 'm', 'LineWidth',1.0);    
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_SHEN_BING(2,from_to_detail),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);    
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN(2,from_to_detail),'-', 'Color', 'k', 'LineWidth',1.0);    
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(2,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN_THACH(2,from_to_detail),'-', 'Color', 'b', 'LineWidth',1.0);    
                xlim([0, detail_time]);          
            end
        end

    subplot(3,1,3);
    plot(SIMULATION_DATA.TIME, (SIMULATION_DATA.REFERENCE(3,:) - SIMULATION_DATA.STATE_ASNSTA(3,:))*180/pi,'-', 'Color', 'r', 'LineWidth',1.0);    
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, (SIMULATION_DATA.REFERENCE(3,:) - SIMULATION_DATA.STATE_ASNSTB(3,:))*180/pi,'-', 'Color', 'm', 'LineWidth',1.0);    
    plot(SIMULATION_DATA.TIME, (SIMULATION_DATA.REFERENCE(3,:) - SIMULATION_DATA.STATE_SHEN_BING(3,:))*180/pi,'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);    
    plot(SIMULATION_DATA.TIME, (SIMULATION_DATA.REFERENCE(3,:) - SIMULATION_DATA.STATE_MIEN_VAN(3,:))*180/pi,'-', 'Color', 'k', 'LineWidth',1.0);  
    plot(SIMULATION_DATA.TIME, (SIMULATION_DATA.REFERENCE(3,:) - SIMULATION_DATA.STATE_MIEN_VAN_THACH(3,:))*180/pi,'-', 'Color', 'b', 'LineWidth',1.0);
    xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);  
    ylabel('$e_{\psi}(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    title('Relative orientation error  $[^{\circ}]$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');

        axes('Position',[.55 .16 .3 .1])
        box on
        detail_time = 15;
        from_step = ceil(PARAMETERS.SIMULATION.TOTAL_STEPS - (detail_time/PARAMETERS.SIMULATION.SAMPLING_TIME));
        if from_step > 0
            from_to_detail = from_step:PARAMETERS.SIMULATION.TOTAL_STEPS;    
            plot(SIMULATION_DATA.TIME(from_to_detail), (SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_ASNSTA(3,from_to_detail))*180/pi,'-', 'Color', 'r', 'LineWidth',1.0);    
            grid on;
            hold on;
            plot(SIMULATION_DATA.TIME(from_to_detail), (SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_ASNSTB(3,from_to_detail))*180/pi,'-', 'Color', 'm', 'LineWidth',1.0);    
            plot(SIMULATION_DATA.TIME(from_to_detail), (SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_SHEN_BING(3,from_to_detail))*180/pi,'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);    
            plot(SIMULATION_DATA.TIME(from_to_detail), (SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN(3,from_to_detail))*180/pi,'-', 'Color', 'k', 'LineWidth',1.0);    
            plot(SIMULATION_DATA.TIME(from_to_detail), (SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN_THACH(3,from_to_detail))*180/pi,'-', 'Color', 'b', 'LineWidth',1.0);    
            xlim([from_step*PARAMETERS.SIMULATION.SAMPLING_TIME, PARAMETERS.SIMULATION.TOTAL_TIME]);
            ylim(1e-1*[-0.5,0.5]);
        end
	
        if norm(PARAMETERS.SIMULATION.INITIAL_CONDITIONS) > 0
	        axes('Position',[.15 .16 .3 .1])
            box on
            detail_time = 4.0;
            to_step = ceil((detail_time/PARAMETERS.SIMULATION.SAMPLING_TIME));
            if to_step > 0
                from_to_detail = 1:to_step;
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_ASNSTA(3,from_to_detail)*180/pi,'-', 'Color', 'r', 'LineWidth',1.0);    
                grid on;
                hold on;
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_ASNSTB(3,from_to_detail)*180/pi,'-', 'Color', 'm', 'LineWidth',1.0);    
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_SHEN_BING(3,from_to_detail)*180/pi,'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0);    
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN(3,from_to_detail)*180/pi,'-', 'Color', 'k', 'LineWidth',1.0);    
                plot(SIMULATION_DATA.TIME(from_to_detail), SIMULATION_DATA.REFERENCE(3,from_to_detail) - SIMULATION_DATA.STATE_MIEN_VAN_THACH(3,from_to_detail)*180/pi,'-', 'Color', 'b', 'LineWidth',1.0);    
                xlim([0, detail_time]);          
            end
        end

    if PARAMETERS.PLOT.CREATE_PDF
        graph_file_path = strcat('../MANUSCRIPT/GRAPHICS/scenario_', num2str(PARAMETERS.SIMULATION.SCENARIO),'_ic_',num2str(PARAMETERS.SIMULATION.INITIAL_CONDITIONS),'_error.pdf')
        export_fig(graph_file_path, '-transparent', '-nocrop');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIGURE 4  : DISTURBANCE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig4 = figure(4);
    clf(fig4);
    subplot(3,1,1);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_ASNSTA(1, :),'-', 'Color', 'r', 'LineWidth',1.0);    
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_ASNSTB(1, :),'-', 'Color', 'm', 'LineWidth',1.0);    
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_MIEN_VAN(1, :),'-', 'Color', 'k', 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_MIEN_VAN_THACH(1, :),'-', 'Color', 'b', 'LineWidth',1.0);  
    xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);  
    ylabel('$d_x(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    subplot(3,1,2);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_ASNSTA(2, :),'-', 'Color', 'r', 'LineWidth',1.0);    
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_ASNSTB(2, :),'-', 'Color', 'K', 'LineWidth',1.0);    
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_MIEN_VAN(2, :),'-', 'Color', 'k', 'LineWidth',1.0);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_MIEN_VAN_THACH(2, :),'-', 'Color', 'b', 'LineWidth',1.0);  
    xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);  
    ylabel('$d_y(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    subplot(3,1,3);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_ASNSTA(3, :),'-', 'Color', 'r', 'LineWidth',1.0);    
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_ASNSTB(3, :),'-', 'Color', 'm', 'LineWidth',1.0);    
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_MIEN_VAN(3, :),'-', 'Color', 'k', 'LineWidth',1.0);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.DISTURBANCE_MIEN_VAN_THACH(3, :),'-', 'Color', 'b', 'LineWidth',1.0);  
    xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);  
    ylabel('$d_{\psi}(t)$', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');

    if PARAMETERS.PLOT.CREATE_PDF
        graph_file_path = strcat('../MANUSCRIPT/GRAPHICS/scenario_', num2str(PARAMETERS.SIMULATION.SCENARIO),'_ic_',num2str(PARAMETERS.SIMULATION.INITIAL_CONDITIONS),'_disturbance.pdf')
        export_fig(graph_file_path, '-transparent', '-nocrop');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIGURE 8  : VELOCITIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig8 = figure(8);
    clf(fig8);
    subplot(3,1,1);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_ASNSTA(7,:),'-', 'Color', 'r', 'LineWidth',1.0);
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_ASNSTB(7,:),'-', 'Color', 'm', 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_SHEN_BING(7,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_MIEN_VAN(7,:),'-', 'Color', 'k', 'LineWidth',1.0);  
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_MIEN_VAN_THACH(7,:),'-', 'Color', 'b', 'LineWidth',1.0);  
    xlim([0.0, 0.5]);  
%     xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);
    ylabel('u(t)', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    legend(plot_legends);

    subplot(3,1,2);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_ASNSTA(8,:),'-', 'Color', 'r', 'LineWidth',1.0);
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_ASNSTB(8,:),'-', 'Color', 'm', 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_SHEN_BING(8,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_MIEN_VAN(8,:),'-', 'Color', 'k', 'LineWidth',1.0);  
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_MIEN_VAN_THACH(8,:),'-', 'Color', 'b', 'LineWidth',1.0);  
    xlim([0.0, 0.5]);  
%     xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);
    ylabel('v(t)', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    
    subplot(3,1,3);
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_ASNSTA(9,:),'-', 'Color', 'r', 'LineWidth',1.0);
    grid on;
    hold on; 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_ASNSTB(9,:),'-', 'Color', 'm', 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_SHEN_BING(9,:),'-', 'Color', [0.1, 0.5, 0.1], 'LineWidth',1.0); 
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_MIEN_VAN(9,:),'-', 'Color', 'k', 'LineWidth',1.0);  
    plot(SIMULATION_DATA.TIME, SIMULATION_DATA.STATE_MIEN_VAN_THACH(9,:),'-', 'Color', 'b', 'LineWidth',1.0);  
    xlim([0.0, 0.5]);
%     xlim([0.0, PARAMETERS.SIMULATION.TOTAL_TIME]);
    ylabel('r(t)', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    xlabel('Time [s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    title('Velocities evolution at initial instant [m/s]', 'FontSize', PARAMETERS.PLOT.FONT_SIZE,'Interpreter','latex');
    
    if PARAMETERS.PLOT.CREATE_PDF
        graph_file_path = strcat('../MANUSCRIPT/GRAPHICS/scenario_', num2str(PARAMETERS.SIMULATION.SCENARIO),'_ic_',num2str(PARAMETERS.SIMULATION.INITIAL_CONDITIONS),'_velocities.pdf')
        export_fig(graph_file_path, '-transparent', '-nocrop');
    end

end

