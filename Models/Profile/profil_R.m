function [q, dq, ddq] = profil_R(t)
% PROFIL TRAPEZOIDAL DE VITEZA CU COLTURI ROTUNJITE - CUPLA DE ROTATIE (R)
% Viteza si acceleratia MAXIME ale modulului.
% Secventa:  0 (mijloc) -> +L/2 -> -L/2 -> +L/2 -> -L/2 ...
%            (cu L = 300 grade: 0 -> +150 -> -150 -> +150 ...)
% Fiecare cursa: trapez de viteza cu colturi rotunjite (acceleratie sin^2):
%   aceeasi viteza maxima v si acceleratie maxima a, dar fara salturi.
% Iesiri: q [rad], dq [rad/s], ddq [rad/s^2]

q = 0; dq = 0; ddq = 0;          % initializare (necesar in Simulink)

% ---------------- LIMITELE MODULULUI DE ROTATIE ----------------
L_lim = 300;      % unghi maxim (cursa totala) [grade]
V_lim = 120;      % viteza unghiulara maxima [grade/s]
A_lim = 510;      % acceleratia unghiulara maxima [grade/s^2]
% ---------------- MISCAREA CERUTA ----------------
L      = 300;     % cursa totala [grade] -> de la -L/2 la +L/2 (negativ = intai spre minus)
V      = 120;     % viteza [grade/s]      (maxima)
A      = 510;     % acceleratie [grade/s^2] (maxima)
t_p    = 0;       % pauza la capete [s]
repeta = true;    % true = continua +150 <-> -150; false = se opreste la -150
% --------------------------------------------------

semn = sign(L);
L = min(abs(L), L_lim);
V = min(abs(V), V_lim);
A = min(abs(A), A_lim);

h = deg2rad(L) / 2;               % jumatate de cursa (150 grade) [rad]
v = deg2rad(V);
a = deg2rad(A);
t = max(t, 0);

if h > 0 && v > 0 && a > 0
    T1 = durata(h, v, a);         % 0 -> +h
    T2 = durata(2*h, v, a);       % +h -> -h (cursa intreaga)

    if t < T1                                     % 0 -> +150
        [q, dq, ddq] = cursa(t, h, v, a);
    elseif t < T1 + t_p                           % pauza la +150
        q = h;
    else
        tm = t - T1 - t_p;
        if ~repeta && tm >= T2                    % oprit la -150
            q = -h;
        else
            P = 2*(T2 + t_p);                     % perioada dus-intors
            k = mod(tm, P);
            if k < T2                             % +150 -> -150
                [s, ds, dds] = cursa(k, 2*h, v, a);
                q = h - s;  dq = -ds;  ddq = -dds;
            elseif k < T2 + t_p                   % pauza la -150
                q = -h;
            elseif k < 2*T2 + t_p                 % -150 -> +150
                [s, ds, dds] = cursa(k - T2 - t_p, 2*h, v, a);
                q = -h + s; dq = ds;   ddq = dds;
            else                                  % pauza la +150
                q = h;
            end
        end
    end
end

q = semn*q; dq = semn*dq; ddq = semn*ddq;
end

% ---------- durata unei curse de lungime D ----------
function T = durata(D, v, a)
T_a = 2*v / a;                    % accelerare cu profil sin^2 (medie a/2)
if D >= v * T_a
    T = D / v + T_a;              % cu palier de viteza constanta
else
    T = 2*sqrt(2*D / a);          % cursa scurta: fara palier
end
end

% ---------- o cursa 0 -> D, trapez cu colturi rotunjite (sin^2) ----------
% Viteza: urca de la 0 la v, palier v, coboara la 0 (forma de trapez),
% dar acceleratia nu mai sare in treapta: ddq = a*sin^2(pi*tau/T_a),
% porneste lin din 0, ajunge la a maxim si revine lin la 0.
% -> fortele si momentele (J*ddq + gravitatie + ...) sunt netede.
function [q, dq, ddq] = cursa(tt, D, v, a)
T_a = 2*v / a;
if D >= v * T_a
    t_c = D / v - T_a;
else
    T_a = sqrt(2*D / a); t_c = 0; v = a*T_a/2;
end
t_f = 2*T_a + t_c;
if tt < T_a                                   % Faza I: accelerare lina
    [q, dq, ddq] = rampa(tt, T_a, a);
elseif tt < T_a + t_c                         % Faza II: viteza constanta
    q = a*T_a^2/4 + v*(tt - T_a); dq = v; ddq = 0;
elseif tt < t_f                               % Faza III: franare lina
    [qr, dqr, ddqr] = rampa(t_f - tt, T_a, a);
    q = D - qr; dq = dqr; ddq = -ddqr;
else
    q = D; dq = 0; ddq = 0;
end
end

% ---------- rampa de accelerare sin^2, de la repaus ----------
function [q, dq, ddq] = rampa(tau, T_a, a)
w   = 2*pi / T_a;
ddq = a * sin(pi*tau/T_a)^2;
dq  = a * (tau/2 - sin(w*tau)/(2*w));
q   = a * (tau^2/4 + (cos(w*tau) - 1)/(2*w^2));
end