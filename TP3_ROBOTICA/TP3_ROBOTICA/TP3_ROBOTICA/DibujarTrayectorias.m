function DibujarTrayectorias(q, Dq, h)
   t = 0:h:length(q) * h - h;
   figure;
   subplot(311), plot(t, q(:, 1), t, q(:, 2), t, q(:, 3), 'linewidth', 2);
   grid;
   xlabel('Tiempo [seg]'); ylabel('q [rad]');
   title('Generador de Trayectorias');
   legend('q_1', 'q_2', 'q_3');

   subplot(312), plot(t, Dq(:, 1), t, Dq(:, 2), t, Dq(:, 3), 'linewidth', 2);
   grid;
   xlabel('Tiempo [seg]'); ylabel('\omega [rad / seg]');
   legend('\omega_1', '\omega_2', '\omega_3');
end

