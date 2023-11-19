% Función para elegir la mejor configuración basada en el error
function q_optima = elegirMejorConfiguracion(q_posibles, objetivo)
    % Calcular el error para cada configuración posible y elegir la mejor
    errores = zeros(size(q_posibles, 1), 1);
    for i = 1:size(q_posibles, 1)
        pi_calculada = cinematicaDirectaTP(q_posibles(i, :));
        errores(i) = norm(objetivo - pi_calculada);
    end

    % Elegir la configuración con el menor error
    [~, indice_optimo] = min(errores);
    if (errores(1) <= 0.01)
       [~, indice_optimo] = errores(1);
    elseif (errores(2) <= 0.01)
       [~, indice_optimo] = errores(2);
    endif
    q_optima = q_posibles(indice_optimo, :);
end
