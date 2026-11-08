%% GRAFICE PROFIL TRAPEZOIDAL - cupla T si cupla R
% Ruleaza din acelasi folder cu profil_T.m si profil_R.m.
clc;   % (fara 'clear', ca sa nu stearga rezultatele simularii din 'out')

% L, V, A sunt acum in profil_T.m si profil_R.m

%% Cupla T
t = linspace(0, 0.7, 2000);
q = zeros(size(t)); dq = q; ddq = q;
for i = 1:numel(t)
    [q(i), dq(i), ddq(i)] = profil_T(t(i));
end
figure('Name', 'Profil trapezoidal pentru cupla T');
subplot(3,1,1); plot(t, q, 'b', 'LineWidth', 1.5); grid on;
title('Grafic pozitie [m]'); xlabel('Timp [s]'); ylabel('Pozitie q(t) [m]');
subplot(3,1,2); plot(t, dq, 'g', 'LineWidth', 1.5); grid on;
title('Grafic viteza [m/s]'); xlabel('Timp [s]'); ylabel('Viteza dq(t) [m/s]');
subplot(3,1,3); plot(t, ddq, 'r', 'LineWidth', 1.5); grid on;
title('Grafic acceleratie [m/s^2]'); xlabel('Timp [s]'); ylabel('Acceleratie ddq(t) [m/s^2]');

%% Cupla R  (afisat in grade, ca sa se citeasca usor; Simscape primeste rad)
t = linspace(0, 3.2, 2000);
q = zeros(size(t)); dq = q; ddq = q;
for i = 1:numel(t)
    [q(i), dq(i), ddq(i)] = profil_R(t(i));
end
figure('Name', 'Profil trapezoidal pentru cupla R');
subplot(3,1,1); plot(t, rad2deg(q), 'b', 'LineWidth', 1.5); grid on;
title('Pozitie (q) [grade]'); xlabel('Timp [s]'); ylabel('Pozitie [grade]');
subplot(3,1,2); plot(t, rad2deg(dq), 'r', 'LineWidth', 1.5); grid on;
title('Viteza (dq) [grade/s]'); xlabel('Timp [s]'); ylabel('Viteza [grade/s]');
subplot(3,1,3); plot(t, rad2deg(ddq), 'g', 'LineWidth', 1.5); grid on;
title('Acceleratie (ddq) [grade/s^2]'); xlabel('Timp [s]'); ylabel('Acceleratie [grade/s^2]');

%% Forte si momente din simulare (dupa ce ai rulat modelul)
% Blocurile To Workspace salveaza: translatie_forte, translatie_moment,
% rotatie_forte, rotatie_moment (Timeseries). In versiunile noi sunt in "out".
if exist('out', 'var') || exist('translatie_forte', 'var')
    nume = {'translatie_forte', 'Forte cupla T [N]'; ...
        'translatie_moment', 'Momente cupla T [N*m]'; ...
        'rotatie_forte', 'Forte cupla R [N]'; ...
        'rotatie_moment', 'Momente cupla R [N*m]'};
    figure('Name', 'Forte si momente');
    for k = 1:4
        if exist('out', 'var')
            ts = out.get(nume{k,1});
        else
            ts = eval(nume{k,1});
        end
        subplot(2,2,k);
        d = squeeze(ts.Data);
        if size(d,1) ~= numel(ts.Time), d = d.'; end   % N x 3
        plot(ts.Time, d, 'LineWidth', 1.2); grid on;
        title(nume{k,2}); xlabel('Timp [s]'); legend('x', 'y', 'z');
    end
end