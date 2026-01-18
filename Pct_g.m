clear all, clc, close all

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

I = eye(2); 

h=50e-9; Tsim=0.125e-3;
time=0:h:Tsim;
t=time(1); x=[1.4015;2.0027]; 
n=1;
while t<Tsim
     vsaw=t/Ts-floor(t/Ts);
     if D>vsaw
        q=1;
     else
        q=0;
     end

     Aq=q*A1+(1-q)*A2;
     Bq=q*B1+(1-q)*B2;
    
     k1=Aq*x(:,n)+Bq*U;
     k2=Aq*(x(:,n)+h*(1/2)*k1)+Bq*U;
     k3=Aq*(x(:,n)+h*(1/2)*k2)+Bq*U;
     k4=Aq*(x(:,n)+h*(k3))+Bq*U;
     x(:,n+1)=x(:,n)+h*((1/6)*k1+(2/6)*k2+(2/6)*k3 +(1/6)*k4);
     n=n+1; t=time(n);
end
plot(time,x)
title('Simulare convertor prin metoda RUNGE-KUTTA4');
