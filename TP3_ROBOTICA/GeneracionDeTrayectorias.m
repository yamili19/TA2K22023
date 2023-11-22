function [q, Dq, t] = GeneracionDeTrayectorias(qi, qf, wmax, h)

dof = max(size(qf));    % Grados de libertad
T=max(abs((qf-qi))./wmax);

wT=(qf-qi)/T;

% Generación de Trayectorias.
%h=1e-1;
t = 0:h:T;
q = zeros(length(t), dof);
Dq = zeros(length(t), dof);
index = 1;
for i = 1:1:length(t)
    
    q(index,:)=qi'+wT'*t(i);       % Posición
    Dq(index,:)=wT;               % Velocidad
    index = index + 1;
end

