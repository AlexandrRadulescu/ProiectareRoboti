function [q, dq, ddq] = profil_T(t)
% PROFIL TRAPEZOIDAL DE VITEZA CU COLTURI ROTUNJITE - CUPLA DE TRANSLATIE (T)
% Viteza si acceleratia MAXIME ale modulului.
% Secventa: 0 -> L, apoi (daca repeta = true) L -> 0 -> L -> ...
% Iesiri: q [m], dq [m/s], ddq [m/s^2]

q = 0; dq = 0; ddq = 0;          % initializare (necesar in Simulink)

% ---------------- LIMITELE MODULULUI DE TRANSLATIE ----------------
L_lim = 325;      % cursa maxima [mm]
V_lim = 0.0007;      % viteza maxima [m/s]
A_lim = 0.0135;     % acceleratia maxima [m/s^2]
% ---------------- MISCAREA CERUTA ----------------
L      = 325;     % cursa [mm] (negativ = sens invers)
V      = 0.0007;     % viteza [m/s]      (maxima)
A      = 0.0135;    % acceleratie [m/s^2] (maxima)
t_p    = 0;       % pauza la capete [s]
repeta = false;   % false = o cursa si ramane la L; true = dus-intors continuu
% --------------------------------------------------

semn = sign(L);
L = min(abs(L), L_lim) / 1000;    % mm -> m (doar cursa!)
v = min(abs(V), V_lim);
a = min(abs(A), A_lim);
t = max(t, 0);

if L > 0 && v > 0 && a > 0
    T = durata(L, v, a);
    if ~repeta
        [q, dq, ddq] = cursa(min(t, T), L, v, a);
    else
        k = mod(t, 2*(T + t_p));
        if k < T                                  % 0 -> L
            [q, dq, ddq] = cursa(k, L, v, a);
        elseif k < T + t_p                        % pauza la L
            q = L;
        elseif k < 2*T + t_p                      % L -> 0
            [s, ds, dds] = cursa(k - T - t_p, L, v, a);
            q = L - s; dq = -ds; ddq = -dds;
        end                                       % altfel pauza la 0
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