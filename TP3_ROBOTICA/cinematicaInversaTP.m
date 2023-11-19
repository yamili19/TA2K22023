function q = cinematicaInversaTP(p)

%% Modelado de este robot
%% Constantes
d1 = 15;
a2 = 7;
a3 = 3;

%% Variables definidas por el usuario
x = p(1);
y = p(2);
z = p(3);

%% C�lculo de la Cinem�tica inversa


r = sqrt(y^2 + (-x)^2);
h = sqrt(r^2 +(z-d1)^2);

% Calcular q1
q1(1) = atan2(-x, y) * 180/pi;
q1(2) = atan2(-x, y) * 180/pi;


if ~isreal(q1(1))
    fprintf('Advertencia: Resultado complejo en q1(1). Ajustando.\n');
    q1(1) = real(q1(1));  % Tomar la parte real del resultado
end

if ~isreal(q1(2))
    fprintf('Advertencia: Resultado complejo en q1(2). Ajustando.\n');
    q1(2) = real(q1(2));  % Tomar la parte real del resultado
end

q3(1) = acosd((h^2 - a2^2 -a3^2)/(2*a2*a3));
q3(2) = -q3(1);

if (~isreal(q3(1)))
  q3(1) = real(q3(1));  % Tomar la parte real del resultado
end

if (~isreal(q3(2)))
  q3(2) = real(q3(2));  % Tomar la parte real del resultado
end
%zona de error
q2(1) = atan2d((z-d1), r) - atan2d((a3*sind(q3(1))), (a2 + a3 * cosd(q3(1))));
q2(2) = atan2d((z-d1), r) - atan2d((a3*sind(q3(2))), (a2 + a3 * cosd(q3(2))));



q = [q1' q2' q3'];
