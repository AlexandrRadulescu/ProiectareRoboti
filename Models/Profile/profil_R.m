function [q, dq, ddq] = profil_R(t, L, V, A)
% |||||GLOSIER|||||
% t       - timpul curent (de la Clock) [s]
% L       - unghiul cerut (phi) [grade] (semnul da sensul)
% V       - viteza unghiulara maxima ceruta (omega) [grade/s]
% A       - acceleratia unghiulara maxima ceruta (epsilon) [grade/s^2]
% x_i     - pozitie initiala
% x_f     - pozitie finala
% t_p     - pauza la capetele cursei
% delta_q - diferenta dintre pozitia finala si cea initiala
% t_a     - timpul de accelerare (= timpul de decelerare)
% t_c     - timpul de mers cu viteza constanta
% t_total - durata unei curse
% T_ciclu - durata unui ciclu complet (dus + pauza + intors + pauza)
% Iesiri: q [rad], dq [rad/s], ddq [rad/s^2]
% Miscarea este simetrica fata de pozitia 0: de la -L/2 la +L/2
%
% Profil trapezoidal de viteza:
%   Faza I   (0 < t < t_a):            ddq = +a, dq = a*t,  q = a*t^2/2
%   Faza II  (t_a < t < t_a+t_c):      ddq = 0,  dq = v,    q = a*t_a^2/2 + v*(t - t_a)
%   Faza III (t_a+t_c < t < t_total):  ddq = -a, dq = a*tr, q = delta_q - a*tr^2/2, tr = t_total - t
% Daca cursa e prea scurta ca sa se atinga v (delta_q < v^2/a), profilul
% devine triunghiular: t_a = sqrt(delta_q/a), t_c = 0.

% initializare iesiri (necesar pentru generarea de cod in Simulink)
q = 0; dq = 0; ddq = 0;

% limitele modulului de rotatie (din tabel)
L_lim = 300;      % [grade]
V_lim = 120;      % [grade/s]
A_lim = 510;      % [grade/s^2]
t_p   = 0.5;      % pauza la capete [s] (0 = fara pauza)

% impunere limite
semn = sign(L);
L = min(abs(L), L_lim);
V = min(abs(V), V_lim);
A = min(abs(A), A_lim);

% conversia din grade in radiani
x_i   = 0;
x_f   = deg2rad(L);
v_max = deg2rad(V);
a_max = deg2rad(A);
delta_q = x_f - x_i;
t = max(t, 0);

% miscare doar daca toate marimile sunt nenule (altfel q = dq = ddq = 0)
if delta_q > 0 && v_max > 0 && a_max > 0
    t_a = v_max / a_max;                 % timpul de accelerare
    if delta_q >= v_max * t_a            % se atinge viteza maxima -> trapez
        t_c = delta_q / v_max - t_a;
        v   = v_max;
    else                                 % cursa scurta -> triunghi
        t_a = sqrt(delta_q / a_max);
        t_c = 0;
        v   = a_max * t_a;
    end
    t_total = 2*t_a + t_c;               % durata unei curse
    T_ciclu = 2*(t_total + t_p);         % dus + pauza + intors + pauza
    tm = mod(t, T_ciclu);                % timpul in ciclul curent

    if tm < t_total
        % cursa de dus
        [q, dq, ddq] = cursa(tm, delta_q, v, a_max, t_a, t_c, t_total);
    elseif tm < t_total + t_p
        % pauza la capatul cursei
        q = delta_q; dq = 0; ddq = 0;
    elseif tm < 2*t_total + t_p
        % cursa de intoarcere (oglinda cursei de dus)
        [qf, dqf, ddqf] = cursa(tm - t_total - t_p, delta_q, v, a_max, t_a, t_c, t_total);
        q   = delta_q - qf;
        dq  = -dqf;
        ddq = -ddqf;
    else
        % pauza in pozitia initiala
        q = 0; dq = 0; ddq = 0;
    end
end

% centrare miscare: de la -delta_q/2 la +delta_q/2
q   = semn * (q - delta_q/2);
dq  = semn * dq;
ddq = semn * ddq;
end

% ---------- profil trapezoidal pentru o cursa ----------
function [q, dq, ddq] = cursa(tt, delta_q, v, a, t_a, t_c, t_total)
q = delta_q; dq = 0; ddq = 0;   % initializare iesiri (capatul cursei)
if tt < t_a                      % Faza I: accelerare
    q   = a * tt^2 / 2;
    dq  = a * tt;
    ddq = a;
elseif tt < t_a + t_c            % Faza II: viteza constanta (dus liniar)
    q   = a * t_a^2 / 2 + v * (tt - t_a);
    dq  = v;
    ddq = 0;
elseif tt < t_total              % Faza III: decelerare
    tr  = t_total - tt;
    q   = delta_q - a * tr^2 / 2;
    dq  = a * tr;
    ddq = -a;
end
end