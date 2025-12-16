clear; clc; close all

syms Rg R Vg LM C Ron Vo D fs n Ts Io Vd

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

AD = D*A1+(1-D)*A2; BD = D*B1+(1-D)*B2;
ED = D*E1+(1-D)*E2; FD = D*F1+(1-D)*F2;
X = -inv(AD)*BD*U;
csiD = (A1-A2)*X + (B1-B2)*U;
zetaD = (E1-E2)*X + (F1-F2)*U;

syms s
I = eye(n);
Gc =simplify(ED * inv(s*I-AD)*csiD + zetaD); % functiile de transf control-iesire
pretty(Gc);

