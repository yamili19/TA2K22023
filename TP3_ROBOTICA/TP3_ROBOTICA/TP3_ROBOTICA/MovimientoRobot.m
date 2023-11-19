function MovimientoRobot(q, Z)

%% Articulaciones
q1 = q(:, 1);
q2 = q(:, 2);
q3 = q(:, 3);

%% Eslabones
l1 = 15;
l2 = 7;
l3 = 3;

%% Gráfico
figure;
h = plot3(NaN, NaN, NaN);
grid on;
#set(h, 'EraseMode', 'xor');
axis([-1 l1 + l2 + l3 -1 l1 + l2 + l3 -1 l1 + l2 + l3]);
xlabel('Posición x []');
ylabel('Posición y []');
zlabel('Posición z []');
title('Cinemática directa de un robot de 3 gdl');
hold on;

for i = 1:length(q1)
    x1 = [0 l1 * cosd(q1(i)) l1 * cosd(q1(i)) + l2 * cosd(q1(i) + q2(i)) l1 * cosd(q1(i)) + l2 * cosd(q1(i) + q2(i)) + l3 * cosd(q1(i) + q2(i) + q3(i))];
    y1 = [0 l1 * sind(q1(i)) l1 * sind(q1(i)) + l2 * sind(q1(i) + q2(i)) l1 * sind(q1(i)) + l2 * sind(q1(i) + q2(i)) + l3 * sind(q1(i) + q2(i) + q3(i))];
    z1 = [Z Z Z Z];  % Ajusta esta línea si hay una componente z en tu robot

    set(h, 'XData', x1, 'YData', y1, 'ZData', z1, 'linewidth', 3);
    plot3(x1(end), y1(end), z1(end), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');

    M = sprintf('q_1 = %.2f�\nq_2 = %.2f�\nq_3 = %.2f�', q1(i), q2(i), q3(i));
    legend(h, M);
    drawnow;
    pause(0.1);
end
disp('Aplausos, por favor');

