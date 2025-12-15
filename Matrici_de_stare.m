% Simularea Matlab si Simulink a modelelor in spatiul starilor
clear all; clc; close all
%Elementele de circuit
syms Rg R Vg LM C Ron Vo D fs n Ts Io
Vg=5; LM=500e-6; C=100e-6; Ron=15e-3; Vo=24; D=0.6; fs=40e3; n = 4.7; Rg = 10e-3;
Ts=1/fs; 

%punctu a 

A1=[-(Rg+Ron)/LM	0;  0 -1/(R*C)];
B1=[1/LM 0;  0  0]; 
E1=[0 1; 0 1/R];
F1=[0 0; 0 0];
 
A2=[-Rg/(LM*(1+n))	  -1/(LM*(1+n));   1/C	-1/(R*C)];
B2=[1/(LM*(1+n)) -1/(LM*(1+n));  0  0]; 
E2=[0 1; 0 1/R];
F2=[0 0; 0 0];
   
% Ad=D*A1+(1-D)*A2;
% Bd=D*B1+(1-D)*B2;
% Ed=D*E1+(1-D)*E2;
% Fd=D*F1+(1-D)*F2;

% punctul be
randament = 0.82;
Io = 2;
Pout = Vo*Io;
M=(1+n*D)/(1-D);

Ppierderi = Pout*((1/randament)-1)




