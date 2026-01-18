% Simularea Matlab si Simulink a modelelor in spatiul starilor
clear; clc; close all
%Elementele de circuit

syms Rg R Vg LM C Ron Vo D fs n Ts Io Vd

u=[Vg; Vd];

%punctu A 
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
   

% punctul B

Ad=D*A1+(1-D)*A2;
Bd=D*B1+(1-D)*B2;
Ed=D*E1+(1-D)*E2;
Fd=D*F1+(1-D)*F2;

x=-inv(Ad)*Bd*u;
y=Ed*x+Fd*u;

Ron=0; Rg=0; Vd=0;
n=4.7; 
% D = 0.4599;

Mideal=simplify(eval(y(1)/Vg))

nn=0.82;
Voimpus=24;
Vg=5;
Imin=1;
Imax=2;

Mimpus=Voimpus/Vg;
D=double(simplify(solve(nn-(Mimpus/Mideal),D)))

R=Voimpus/Imax
syms Vd
Rg=10e-3; Ron=15e-3; C=100e-6; Lm=500e-6;
Vd=double(eval(simplify(solve(y(1)-Voimpus,Vd))))

syms D
D_cal=solve(y(1)-Voimpus,D)


% punctul C
Iout=Imin:0.01:Imax;

for i=1:length(Iout)
    R=Voimpus/Iout(i);
    D = eval(D_cal(1));
    rand(i) = eval(Mimpus/Mideal);
end

plot(Iout,rand)

Rg = 10e-3; Ron=15e-3; C=100e-6; LM=500e-6; n = 4.7; 
D = 0.4599; R = 12; Vg = 5; Vd = 4.7819; fs = 40000;

P_out = (Voimpus * Imax);
iLm = double(eval(x(1)));


P_q = D * Ron * iLm^2;
P_d = (1-D) * Vd * (iLm / (1+n));
P_rg = D * Rg * iLm^2 + (1-D) * Rg * (iLm / (1+n))^2;

P_total = P_q + P_d + P_rg;
verificare_randament =  P_out / (P_total + P_out);



%Care dispozitiv ar trebui înlocuit dacă se doreşte mărirea randamentului în acest punct de funcţionare?
%Raspuns: Dioda
