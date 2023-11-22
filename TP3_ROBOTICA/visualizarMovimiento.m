% Función para visualizar el movimiento del robot a lo largo de las transformaciones intermedias
function visualizarMovimiento(transformaciones)
    num_points = length(transformaciones);

    figure;
    hold on;
    axis equal;
    grid on;
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
    title('Movimiento del Robot de 3 Grados de Libertad');

    for i = 1:num_points
        plotRobot(transformaciones{i});
        pause(0.1);  % Añade un pequeño retraso para visualización
    end

    hold off;
end
