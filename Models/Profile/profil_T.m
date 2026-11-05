function [q, dq, ddq] = profil_T(t, L, V, A)
% |||||GLOSIER|||||
% t       - timpul curent (de la Clock) [s]
% L       - cursa ceruta [mm]
% V       - viteza maxima ceruta [mm/s]
% A       - acceleratia maxima ceruta [mm/s^2]
% x_i     - pozitie initiala
% x_f     - pozitie finala
% t_p     - pauza la capetele cursei
% delta_q - diferenta dintre pozitia finala si cea initiala
% t_total - durata unei curse
% T_ciclu - durata unui ciclu complet (dus + intors)
% Iesiri: q [m], dq [m/s], ddq [m/s^2]
%
% Profil cicloidal (acceleratie continua, nula la capetele cursei):
%   s = t/t_total
%   q   = delta_q*(s - sin(2*pi*s)/(2*pi))
%   dq  = delta_q/t_total*(1 - cos(2*pi*s))      -> dq_max  = 2*delta_q/t_total
%   ddq = 2*pi*delta_q/t_total^2*sin(2*pi*s)     -> ddq_max = 2*pi*delta_q/t_total^2
% t_total se alege astfel incat sa nu se depaseasca nici V, nici A.

% initializare iesiri (necesar pentru generarea de cod in Simulink)
q = 0; dq = 0; ddq = 0;

% limitele modulului de translatie (din tabel)
L_lim = 325;      % [mm]
V_lim = 0.7;      % [mm/s]
A_lim = 13.5;    % [mm/s^2]
t_p = 0.2;        % pauza la capete [s] (0 = fara pauza)

% impunere limite
semn = sign(L);
L = min(abs(L), L_lim);
V = min(abs(V), V_lim);
A = min(abs(A), A_lim);

% conversia din mm in m
x_i   = 0;
x_f   = L / 1000;
v_max = V / 1000;
a_max = A / 1000;
delta_q = x_f - x_i;
t = max(t, 0);

% miscare doar daca toate marimile sunt nenule (altfel q = dq = ddq = 0)
if delta_q > 0 && v_max > 0 && a_max > 0
    % durata unei curse: cea mai mare dintre limita de viteza si cea de acceleratie
    t_total = max(2*delta_q/v_max, sqrt(2*pi*delta_q/a_max));
    T_ciclu = 2*(t_total + t_p);         % dus + pauza + intors + pauza
    tm = mod(t, T_ciclu);                % timpul in ciclul curent

    if tm < t_total
        % cursa de dus
        [q, dq, ddq] = cursa(tm, delta_q, t_total);
    elseif tm < t_total + t_p
        % pauza la capatul cursei
        q = delta_q; dq = 0; ddq = 0;
    elseif tm < 2*t_total + t_p
        % cursa de intoarcere (oglinda cursei de dus)
        [qf, dqf, ddqf] = cursa(tm - t_total - t_p, delta_q, t_total);
        q   = delta_q - qf;
        dq  = -dqf;
        ddq = -ddqf;
    else
        % pauza in pozitia initiala
        q = 0; dq = 0; ddq = 0;
    end
end

% aplicare sens si pozitie initiala
q   = x_i + semn * q;
dq  = semn * dq;
ddq = semn * ddq;
end

% ---------- profil cicloidal pentru o cursa ----------
function [q, dq, ddq] = cursa(tt, delta_q, t_total)
q = delta_q; dq = 0; ddq = 0;   % initializare iesiri
if tt < t_total
    s   = tt / t_total;
    q   = delta_q * (s - sin(2*pi*s)/(2*pi));
    dq  = delta_q / t_total * (1 - cos(2*pi*s));
    ddq = 2*pi*delta_q / t_total^2 * sin(2*pi*s);
end
end