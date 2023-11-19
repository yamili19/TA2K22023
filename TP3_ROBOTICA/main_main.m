clc, clear all, close all;
% Constantes
d1 = 15;
a2 = 7;
a3 = 3;
q = [0 0 0];

% Coordenadas de la trayectoria circular en el plano XY
r = 2; % Radio del círculo
num_points = 100;
theta = linspace(0, 2*pi, num_points);
x = r * cos(theta);
y = r * sin(theta);
z = 0.5 * ones(size(theta));

% Visualización de la trayectoria
figure;
plot3(x, y, z, 'r', 'linewidth', 2);
title('Trayectoria Circular en el Plano XY');
xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
grid on;

% Inicializar matrices para almacenar los resultados
q_total = zeros(1, 3);
Dq_total = zeros(1, 3);
trayectorias = cell(num_points, 1);

% Inicializar matrices para almacenar los resultados
q_total = zeros(1, 3);
Dq_total = zeros(1, 3);

for i = 1:length(theta)-1
    % Posiciones inicial y final
    pi = [x(i), y(i), z(i)];
    pf = [x(i+1), y(i+1), z(i+1)];

    % Calcular cinemática inversa
    qi_posibles = cinematicaInversaTP(pi);
    qf_posibles = cinematicaInversaTP(pf);

    % Evaluar y elegir la mejor configuración
    qi_optima = elegirMejorConfiguracion(qi_posibles, pi);
    qf_optima = elegirMejorConfiguracion(qf_posibles, pf);

    % Calcular cinemática directa para verificar
    pi_calculada = cinematicaDirectaTP(qi_optima);
    pf_calculada = cinematicaDirectaTP(qf_optima);

    % Generar trayectorias
    [q, Dq, ~] = GeneracionDeTrayectorias(qi_optima, qf_optima, [2, 2, 2], 1);

    % Almacenar resultados
    q_total = [q_total; q];
    Dq_total = [Dq_total; Dq];
end

% Eliminar la fila de ceros iniciales
q_total = q_total(2:end, :);
Dq_total = Dq_total(2:end, :);

% Visualizar trayectoria en 3D
DibujarTrayectorias(q_total, Dq_total, 1);

MovimientoRobot(q_total);







