% Calcul D in CCM cu controller proportional si TE
function y=Pct_h_functie_calcul_D(x,Vg,Vd,Aon,Bon,Aoff,Boff,Ts,k,Vref,Vu,Vl)
extr=[0 1];
I=eye(2);
u = [Vg ; Vd];
phi1=expm(Aon*x*Ts); psi1=Aon\(phi1-I)*Bon;  
phi2=expm(Aoff*(1-x)*Ts); psi2=Aoff\(phi2-I)*Boff; 
X=(I-phi2*phi1)\(phi2*psi1+psi2);
y=k*(Vref - extr*(phi1*X+psi1)*u)-(Vu-Vl)*x-Vl; 