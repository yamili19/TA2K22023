clc, clear all, close all;
% Constantes
d1 = 15;
a2 = 7;
a3 = 3;
q = [45 45 45];
deltap = [0.01 0.01 0.01];
% Número de puntos en la trayectoria
num_points = 100;
t = linspace(0, 2*pi, num_points);

% Ajuste para un círculo completo en q(1)
theta = deg2rad([90 + q(1) + linspace(0, 360, num_points)' q(2)*ones(num_points, 1) q(3)*ones(num_points, 1)]);
d = [d1 0 0];
a = [0 a2 a3];
alpha = deg2rad([90 0 0]);

% Inicializar matrices para almacenar las coordenadas
x = zeros(size(t));
y = zeros(size(t));
z = zeros(size(t));

% Generar trayectoria circular en el plano XY
for i = 1:num_points
    T = calcularTransformacion(theta(i, :), d, a, alpha, q);
    x(i) = T(1, 4);
    y(i) = T(2, 4);
    z(i) = T(3, 4);
end

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

    %% Verificaci�n usando la cinem�tica directa
    % Puede ocurrir que alguna de las configuraciones propuestas por la CI no
    % sea correcta.
    pi1 = cinematicaDirectaTP(qi_posibles(1,:));
    pi2 = cinematicaDirectaTP(qi_posibles(2,:));
    pf1 = cinematicaDirectaTP(qf_posibles(1,:));
    pf2 = cinematicaDirectaTP(qf_posibles(2,:));

    if (abs(pi1 - pi ) < deltap)
        qiElegida = qi_posibles(1,:);
    elseif (abs(pi2 - pi ) < deltap)
        qiElegida = qi_posibles(2,:);
    else
        disp('Ninguna configuraci�n funciona!')
    end

    if (abs(pf1 - pf ) < deltap)
        qfElegida = qf_posibles(1,:);
    elseif (abs(pf2 - pf ) < deltap)
        qfElegida = qf_posibles(2,:);
    else
        disp('Ninguna configuraci�n funciona!')
    end

    % Generar trayectorias
    [q, Dq, ~] = GeneracionDeTrayectorias(qiElegida, qfElegida, [2, 2, 2], 1);

    % Almacenar resultados
    q_total = [q_total; q];
    Dq_total = [Dq_total; Dq];
end

% Eliminar la fila de ceros iniciales
q_total = q_total(2:end, :);
Dq_total = Dq_total(2:end, :);

% Visualizar trayectoria en 3D
DibujarTrayectorias(q_total, Dq_total, 1);

MovimientoRobot(q_total, z(end));







