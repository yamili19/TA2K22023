%% Generaci�n de trayectorias completo
% Robot de 2gdl, https://www.geogebra.org/m/espsungm
close all; clear all; clc
%% Posici�n inicial y final
tuplaPi = [[5 -5 15]; [5 -5 10];[5 0 10];[5 0 15]];   % Posici�n Inicial
tuplaPf = [[5 -5 10]; [5 0 10];[5 0 15];[5 -5 15]];   % Posici�n Final

for i = 1:1:4

  pi = tuplaPi(i,:);
  pf = tuplaPf(i,:);

deltap = [0.1 0.1];      % Error tolerado en la posici�n
wmax = [2 2 2];       % Velocidades m�ximas de las articulaciones
h = 1;            % paso de integraci�n

%% C�lculo de la cinem�tica inversa.
% Se devuelven dos configuraciones posibles: codo arriba y codo abajo
qi = cinematicaInversaTP(pi);
qf = cinematicaInversaTP(pf);

%%Hasta aca llegue

%% Verificaci�n usando la cinem�tica directa
% Puede ocurrir que alguna de las configuraciones propuestas por la CI no
% sea correcta.
pi1 = cinematicaDirectaTP(qi(1,:));
pf1 = cinematicaDirectaTP(qf(1,:));

pi2 = cinematicaDirectaTP(qi(2,:));
pf2 = cinematicaDirectaTP(qf(2,:));

if (abs(pi1 - pi ) < deltap(1))
    qiElegida = qi(1,:);
elseif (abs(pi2 - pi ) < deltap(2))
    qiElegida = qi(1,:);
else
    disp('Ninguna configuraci�n funciona!')
end

if (abs(pf1 - pf ) < deltap(1))
    qfElegida = qf(1,:);
elseif (abs(pf2 - pf ) < deltap(2))
    qfElegida = qf(1,:);
else
    disp('Ninguna configuraci�n funciona!')
end



%% Generacion de Trayectorias
[q, Dq, t] = GeneracionDeTrayectorias(qiElegida, qfElegida, wmax, h);




graficadorRobot3gl(q, Dq, t)

end




