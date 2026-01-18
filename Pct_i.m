clear; clc; close all
% Definim variabilele simbolice necesare
syms Rg R Vg LM C Ron Vo D fs n Ts Io Vd s

Rg = 10e-3; Ron=15e-3; C=100e-6; LM=500e-6; n = 4.7; D = 0.4599; R = 12; Vg = 5; Vd = 4.7819; fs = 40000;
Ts = 1/fs;
U=[Vg; Vd];

 
%starea 1
A1=[-(Rg+Ron)/LM	0;  0 -1/(R*C)];
B1=[1/LM 0;  0  0]; 
E1=[0 1; 0 1/R];
F1=[0 0; 0 0];
%starea 2 
A2=[-Rg/(LM*(1+n))	  -1/(LM*(1+n));   1/C	-1/(R*C)];
B2=[1/(LM*(1+n)) -1/(LM*(1+n));  0  0]; 
E2=[0 1; 0 1/R];
F2=[0 0; 0 0];
   

Ad=D*A1+(1-D)*A2;
Bd=D*B1+(1-D)*B2;
Ed=D*E1+(1-D)*E2;
Fd=D*F1+(1-D)*F2;

X=-inv(Ad)*Bd*U;
Y=Ed*X+Fd*U;
% Acestea corespund termenilor (A1-A2)*X + (B1-B2)*U
csiD = (A1-A2)*X + (B1-B2)*U; 
zetaD = (E1-E2)*X + (F1-F2)*U;

I = eye(2); 

Gc =simplify(Ed*inv(s*I-Ad)*csiD + zetaD); % functia de transf control-iesire
pretty(Gc);

% Convertim Gc simbolic in numeric
[num_sym, den_sym] = numden(Gc(1));
num_coef = double(coeffs(num_sym, s, 'All'));
den_coef = double(coeffs(den_sym, s, 'All'));

GPID = tf(num_coef, den_coef);
[C_pid, info] = pidtune(GPID, 'pid');

Kp = C_pid.Kp;
Ki = C_pid.Ki;
Kd = C_pid.Kd;

a = Kp + Ki*Ts + Kd/Ts; % 0.08810
b = Kp + 2*Kd/Ts; % 0.16979
c = Kd/Ts; % 0.08181


% Ecuatia u[k] = u[k-1] + (0.08810)*e[k] - (0.16979)*e[k-1] + (0.08181)*e[k-2]



