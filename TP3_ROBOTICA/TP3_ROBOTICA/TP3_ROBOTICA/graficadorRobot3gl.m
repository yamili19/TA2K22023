function graficadorRobot3gl(q, Dq, t)

  [filas, columnas] = size(q)
  for i=1:filas
  qi = q(i,:);
  Dqi = Dq(i,:);
  ti = t(i);




%% Constantes
d1 = 15;
a2 = 7;
a3 = 3;

%Parametros DenavitHartenberg
theta = deg2rad([ (90+qi(1)) qi(2) qi(3)]);
d = [ d1 0 0];
a = [ 0 a2 a3];
alpha = deg2rad([ 90 0 0]);

%% C�lculo de la Cinem�tica Directa
A01 = matrizDenavitHartenberg(theta(1), d(1), a(1), alpha(1));
A12 = matrizDenavitHartenberg(theta(2), d(2), a(2), alpha(2));
A23 = matrizDenavitHartenberg(theta(3), d(3), a(3), alpha(3));

T1 = A01;
T2 = A01 * A12;
T3 = A01 * A12 * A23;


x1 = T1(1,4);
y1 = T1(2,4);
z1 = T1(3,4);

x2 = T2(1,4);
y2 = T2(2,4);
z2 = T2(3,4);

x3 = T3(1,4);
y3 = T3(2,4);
z3 = T3(3,4);

  plot3([0 x1],[0 y1],[0 z1],...
        [x1 x2],[y1 y2],[z1 z2],...
        [x2 x3],[y2 y3],[z2 z3])
  plot3(x3, y3, z3, '--o','Color',[0.5 0 0.8],'LineWidth',3)
  hold on




  pause(0.1);
  axis([-10 10 -10 10 0 22])
  xlabel('X')
  ylabel('y')
  zlabel('z')
end
