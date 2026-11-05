clear; clc;

% ---------- parametri (aceiasi ca in blocurile Constant din model) ----------
% Cupla T (Lungime)
L_T = -325;     % cursa [mm]
V_T = 200;      % viteza maxima [mm/s]
A_T = 1000;     % acceleratia maxima [mm/s^2]

% Cupla R (Unghi)
L_R = 300;      % unghiul [grade]
V_R = 120;      % viteza unghiulara maxima [grade/s]
A_R = 510;      % acceleratia unghiulara maxima [grade/s^2]

t_end = 10;     % durata [s] (aceeasi cu Stop time din Simulink)
dt    = 1e-3;   % pasul de timp [s]

% ---------- calcul ----------
t = 0:dt:t_end;
n = numel(t);
[qT, dqT, ddqT] = deal(zeros(1, n));
[qR, dqR, ddqR] = deal(zeros(1, n));

for i = 1:n
    [qT(i), dqT(i), ddqT(i)] = profil_T(t(i), L_T, V_T, A_T);
    [qR(i), dqR(i), ddqR(i)] = profil_R(t(i), L_R, V_R, A_R);
end

% ---------- grafice ----------
deseneaza(t, qT, dqT, ddqT, 'Profilul de miscare pentru cupla T', ...
    'Pozitie q(t) [m]', 'Viteza dq(t) [m/s]', 'Acceleratie ddq(t) [m/s^2]');

deseneaza(t, qR, dqR, ddqR, 'Profilul de miscare pentru cupla R', ...
    'Pozitie q(t) [rad]', 'Viteza dq(t) [rad/s]', 'Acceleratie ddq(t) [rad/s^2]');

% ---------- valori maxime (pentru verificare fata de limite) ----------
fprintf('Cupla T: |v|max = %.1f mm/s, |a|max = %.1f mm/s^2\n', ...
    max(abs(dqT))*1000, max(abs(ddqT))*1000);
fprintf('Cupla R: |w|max = %.1f grade/s, |e|max = %.1f grade/s^2\n', ...
    rad2deg(max(abs(dqR))), rad2deg(max(abs(ddqR))));

% ---------- functie locala pentru o figura cu 3 grafice ----------
function deseneaza(t, q, dq, ddq, titlu, yq, ydq, yddq)
figure('Name', titlu, 'Color', 'w');

subplot(3,1,1);
plot(t, q, 'b', 'LineWidth', 1.5); grid on;
title('Grafic pozitie'); xlabel('Timp [s]'); ylabel(yq);

subplot(3,1,2);
plot(t, dq, 'g', 'LineWidth', 1.5); grid on;
title('Grafic viteza'); xlabel('Timp [s]'); ylabel(ydq);

subplot(3,1,3);
plot(t, ddq, 'r', 'LineWidth', 1.5); grid on;
title('Grafic acceleratie'); xlabel('Timp [s]'); ylabel(yddq);

sgtitle(titlu);
end