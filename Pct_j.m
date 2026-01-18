clc; clear;
syms x y z a b c

% ecuatii
eq1 = -y - z == 0;
eq2 = x + a*y == 0;
eq3 = b + z*(x - c) == 0;

% Rezolvam sistemul simbolic
S = solve([eq1, eq2, eq3], [x, y, z]);

sol_x = S.x;
sol_y = S.y;
sol_z = S.z;


% --- VERIFICARE NUMERICA PENTRU CAZUL 1 ---
val_a = 0.2; val_b = 1.8; val_c = 5.7;

Delta = val_c^2 - 4*val_a*val_b;
fprintf('Delta pentru a=0.2, b=1.8, c=5.7 este: %.4f\n', Delta);

if Delta > 0
    disp('CONCLUZIE: Exista 2 puncte de echilibru izolate.');
else
    disp('CONCLUZIE: Nu exista puncte de echilibru reale.');
end