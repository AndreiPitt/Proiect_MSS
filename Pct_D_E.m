clear all; clc; close all
%Elementele de circuit


syms Rg R Vg LM C Ron Vo D fs n Ts Io VD
%Elementele de circuit
Rg = 10e-3; Ron=15e-3; C=100e-6; LM=500e-6; n = 4.7; D = 0.4599; R = 12; Vg = 5; VD = 4.7819;
% u=[Vg; Vd];
 
%starea 1
A1=[-(Rg+Ron)/LM	0;  0 -1/(R*C)];
B1=[1/LM 0;  0  0];   
E1=[0 1; 0 1/R];
F1=[0 0; 0 0];
%starea 2 
A2=[-Rg/(LM*(1+ n))	  -1/(LM*(1+n));   1/C	-1/(R*C)];
B2=[1/(LM*(1+n)) -1/(LM*(1+n));  0  0]; 
E2=[0 1; 0 1/R];
F2=[0 0; 0 0];
   

% punctul D

Ad=D*A1+(1-D)*A2;
Bd=D*B1+(1-D)*B2;
Ed=D*E1+(1-D)*E2;
Fd=D*F1+(1-D)*F2;

[numarator , numitor]=ss2tf(Ad,Bd,Ed,Fd,1); % 1 -> determinam functiile de transfer in raport cu prima marime din u (Vg)
H=tf(numarator(1,:),numitor) %audiosusceptibilitatea (v0/Vg)
poli=pole(H) %determinam polii pentru H pentru a vedea daca sistemul este stabil, Re{poli}<0
Vgp=0.3; %perturbatiile de la intrare, amplitudine = 0.3Vvv, f=1kHz
Vop=Vgp*abs(evalfr(H,j*2*pi*1e3)) %perturbatiile de la iesire, se evalueaza H la frecventa perturbatiilor (jw=j*2*pi*f)
bode(H); 

% punctul E

[x,u,y,dx] = trim('Sim_trim',[],[],[NaN 2],[],[],[false true])
D=u