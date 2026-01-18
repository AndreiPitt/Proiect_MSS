tic
clear all; close all; clc; 

L=500e-6; C=100e-6; R=12; k=1; fs = 40e3; Ts=1/fs; Vl=3.8; Vu=8.2; Vref=11; Rg = 10e-3; Ron=15e-3; n = 4.7;

% % Matricile de stare. Indicele 1 corespunde primei stari topologice, indiferent care este ea (on sau off)
Aon=[-(Rg+Ron)/L	0;  0 -1/(R*C)];  Bon=[1/L 0;  0  0];
Aoff=[-Rg/(L*(1+ n))	  -1/(L*(1+n));   1/C	-1/(R*C)]; Boff=[1/(L*(1+n)) -1/(L*(1+n));  0  0]; 
I=eye(2);
extr=[0 1]; 

Vg=5; Vd = 4.7819; incr=0.1; lambda=zeros(2); % initializari parametru de simulare, increment si multiplicatori caracteristici in cerc
u = [Vg ; Vd];
while abs(lambda(1))<1 && abs(lambda(2))<1  
      D=fzero(@(x) Pct_h_functie_calcul_D(x,Vg,Vd,Aon,Bon,Aoff,Boff,Ts,k,Vref,Vu,Vl),0.4599); 
      Phi1=expm(Aon*D*Ts); 
      Psi1=Aon\(Phi1-I)*Bon; 
      Phi2=expm(Aoff*(1-D)*Ts);
      Psi2=Aoff\(Phi2-I)*Boff;
       
      X=(I-Phi2*Phi1)\(Phi2*Psi1+Psi2)*u;
            
      dFdxn = -k*extr*Phi1;    
      dFddn = -k*extr*Ts*Phi1*(Aon*X+Bon*u)-Vu-Vl;
      dgdxn = Phi2*Phi1;
      dgddn = Ts*Phi2*((Aon-Aoff)*Phi1*X-(Phi1*Boff-Aon*Psi1-Bon)*u);
         
      JFX=dgdxn-dgddn*dFdxn/dFddn; 
      lambda=eig(JFX)
      %modullambda=abs(lambda);
      
      relambda1=real(lambda(1)); imlambda1=imag(lambda(1));
      relambda2=real(lambda(2)); imlambda2=imag(lambda(2));
      figure(1); plot(relambda1,imlambda1,'xr', relambda2,imlambda2,'xb'); hold on
      k=k+incr;
 end
 x=0:0.001:2*pi;
 y=exp(j*x); plot(y); % formula lui Euler
   k=k-incr, D   
   toc