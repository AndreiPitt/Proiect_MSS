function dxdt = comutat(t,x)   % t - timp de simulare, x variabila pe care
                               % o calculam din ecuatia diferentiala 
%Elementele de circuit
Rg = 10e-3; Ron=15e-3; C=100e-6; LM=500e-6; n = 4.7; D = 0.4599; R = 12; Vg = 5; VD = 0.8; fs = 40e3;
Ts = 1/fs;

% se decomenteaza linia 9 pentru a adauga peste Vg constant o perturbatie sinusoidala cu f = 1kHz si amplitudinea varf la varf = 1V 
% aceasta perturbatie se regaseste si in Vo amplificata sau atenuata in functie de frecventa sa
% Vg = Vg + 0.5*sin(2*pi*1e3*t);

% D = 0.6 pentru primele 5ms din simulare, apoi D = 0.4 pana la finalul simularii,
% la modificarea lui D (la 5ms) apre un nou regim tranzitoriu 
% if t<5e-3
%     D = 0.6;
% else
%     D = 0.4;
% end

Vramp = t/Ts - floor(t/Ts); % generam dintele de fierastrau
q = D > Vramp; % generam semnalul de comanda q (modulatie TE)

% u = [Vg; VD]  x = [iL; vC] y = [iL; vout; iQ] 
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
   
Aq=q*A1+(1-q)*A2;
Bq=q*B1+(1-q)*B2;
Eq=q*E1+(1-q)*E2;
Fq=q*F1+(1-q)*F2;

u = [Vg;VD]; % vectorul de intrare 
dxdt = Aq * x + Bq * u; %ecuatia diferentiala pe care dorim sa o rezolvam
% se decomenteaza linia 43 daca dorim sa calculam marimile din vectorul de iesire (y)
% se observa ca Vo != Vc in cazul modelului comutat (Vo=19.2338 si Vc=19.2163) => VRc!=0 => Vo=Vc+VRc
% y = Eq * x + Fq * u 
end