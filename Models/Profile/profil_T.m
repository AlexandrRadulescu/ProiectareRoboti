function [q, dq, ddq] = profil_T(t, L, V, A)
% Conversie din metri in milimetri pentru toate marimile

L_mm = L/1000;
V_mm = abs(V)/1000;
A_mm = abs(A)/1000;

% Determinare sens de miscare (+1 sau -1)
directie = sign(L_mm);
if directie == 0
    directie = 1;
end

delta_q = abs(L_mm);

% Caz limita: deplasare nula
if delta_q == 0
    q = zeros(size(t));
    dq = zeros(size(t));
    ddq = zeros(size(t));
    return;
end

% Timp de accelerare si distanta parcursa in accelerare
t_a = V_mm / A_mm;
q1 = V_mm^2 / (2 * A_mm);

% Verificare tip de profil: trapezoidal sau triunghiular
if delta_q >= 2 * q1
    % Profil trapezoidal (atinge viteza de croaziera V_mm)
    t_c = (delta_q - 2 * q1) / V_mm;
else
    % Profil triunghiular (viteza maxima V_mm nu poate fi atinsa pe distanta L_mm)
    t_a = sqrt(max(0, delta_q / A_mm));
    t_c = 0;
    V_mm = A_mm * t_a;
end

t_total = 2 * t_a + t_c;

% Initializare vectori de stare
q = zeros(size(t));
dq = zeros(size(t));
ddq = zeros(size(t));

% Calculul pozitiei, vitezei si acceleratiei (in mm, mm/s, mm/s^2)
for i = 1:length(t)
    if t(i) < t_a
        % Faza I: Accelerare constanta
        q(i) = A_mm * t(i)^2 / 2;
        dq(i) = A_mm * t(i);
        ddq(i) = A_mm;

    elseif t(i) <= (t_total - t_a)
        % Faza II: Viteza constanta (croaziera)
        q(i) = A_mm * t_a^2 / 2 + V_mm * (t(i) - t_a);
        dq(i) = V_mm;
        ddq(i) = 0;

    elseif t(i) <= t_total
        % Faza III: Decelerare constanta
        q(i) = delta_q - A_mm * (t_total - t(i))^2 / 2;
        dq(i) = A_mm * (t_total - t(i));
        ddq(i) = -A_mm;

    else
        % Dupa oprire (mentinere la valoarea maxima L_mm)
        q(i) = delta_q;
        dq(i) = 0;
        ddq(i) = 0;
    end
end

% Aplicare sens deplasare
q = q * directie;
dq = dq * directie;
ddq = ddq * directie;
end