clear; clc; close all
% Definim variabilele simbolice necesare
syms Rg R Vg LM C Ron Vo D fs n Ts Io Vd s

A1 = [-(Rg+Ron)/LM,       0; 
       0,                -1/(R*C)];
B1 = [1/LM, 0; 
      0,    0]; 
E1 = [0, 1; 
      0, 1/R];
F1 = [0, 0; 
      0, 0];

% --- STAREA 2 (Switch OFF) ---
A2 = [-Rg/(LM*(1+n)),   -1/(LM*(1+n)); 
       1/C,       -1/(R*C)];

B2 = [1/(LM*(1+n)),      -1/(LM*(1+n)); 
      0,                  0]; 
E2 = [0, 1; 
      0, 1/R];
F2 = [0, 0; 
      0, 0];

% Vectorul intrarilor
U = [Vg; Vd];

% Matricele Mediate
AD = D*A1 + (1-D)*A2;
BD = D*B1 + (1-D)*B2;
ED = D*E1 + (1-D)*E2;
FD = D*F1 + (1-D)*F2;

X = -inv(AD)*BD*U;
% Acestea corespund termenilor (A1-A2)*X + (B1-B2)*U
csiD = (A1-A2)*X + (B1-B2)*U; 
zetaD = (E1-E2)*X + (F1-F2)*U;

I = eye(2); 

Gc =simplify(ED*inv(s*I-AD)*csiD + zetaD); % functia de transf control-iesire
pretty(Gc);