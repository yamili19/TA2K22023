function p = cinematicaDirectaTP(q)

%% Constantes
d1 = 15;
a2 = 7;
a3 = 3;


%Parametros DenavitHartenberg
theta = deg2rad([ (90+q(1)) q(2) q(3)]);
d = [ d1 0 0];
a = [ 0 a2 a3];
alpha = deg2rad([ 90 0 0]);


%% C�lculo de la Cinem�tica Directa
A01 = matrizDenavitHartenberg(theta(1), d(1), a(1), alpha(1));
A12 = matrizDenavitHartenberg(theta(2), d(2), a(2), alpha(2));
A23 = matrizDenavitHartenberg(theta(3), d(3), a(3), alpha(3));

T = A01 * A12 * A23;

x = T(1,4);
y = T(2,4);
z = T(3,4);


p = [x y z];





