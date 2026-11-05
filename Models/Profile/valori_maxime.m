data_forte_T   = aranjeaza(out.translatie_forte.Data);
data_momente_T = aranjeaza(out.translatie_moment.Data);
data_forte_R   = aranjeaza(out.rotatie_forte.Data);
data_momente_R = aranjeaza(out.rotatie_moment.Data);

% forte [N]
max_x_force_T = max(abs(data_forte_T(1,:)))
max_y_force_T = max(abs(data_forte_T(2,:)))
max_z_force_T = max(abs(data_forte_T(3,:)))

% momente [N*m]
max_x_moment_T = max(abs(data_momente_T(1,:)))
max_y_moment_T = max(abs(data_momente_T(2,:)))
max_z_moment_T = max(abs(data_momente_T(3,:)))

% ================= CUPLA R (rotatie) =================
% forte [N]
max_x_force_R = max(abs(data_forte_R(1,:)))
max_y_force_R = max(abs(data_forte_R(2,:)))
max_z_force_R = max(abs(data_forte_R(3,:)))

% momente [N*m]
max_x_moment_R = max(abs(data_momente_R(1,:)))
max_y_moment_R = max(abs(data_momente_R(2,:)))
max_z_moment_R = max(abs(data_momente_R(3,:)))

function D = aranjeaza(D)
D = squeeze(D);
if size(D,1) ~= 3 && size(D,2) == 3
    D = D.';                 % n x 3  ->  3 x n
else
    D = reshape(D, 3, []);   % 3 x 1 x n  ->  3 x n
end
end