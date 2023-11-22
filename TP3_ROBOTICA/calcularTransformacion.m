% Función para calcular la transformación homogénea DH
function T = calcularTransformacion(theta, d, a, alpha, q)
    T = eye(4);
    for i = 1:length(theta)
        A_i = [
            cos(theta(i)), -sin(theta(i)) * cos(alpha(i)), sin(theta(i)) * sin(alpha(i)), a(i) * cos(theta(i));
            sin(theta(i)), cos(theta(i)) * cos(alpha(i)), -cos(theta(i)) * sin(alpha(i)), a(i) * sin(theta(i));
            0, sin(alpha(i)), cos(alpha(i)), d(i);
            0, 0, 0, 1
        ];

        T = T * A_i;
    end
end

