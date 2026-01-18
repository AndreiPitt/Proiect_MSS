clear all; close all; clc;
%Elementele de circuit
Rg = 10e-3; Ron=15e-3; C=100e-6; LM=500e-6; n = 4.7; D = 0.4599; R = 12; Vg = 5; VD = 2.6701; fs = 40e3;
Ts = 1/fs;
%starea 1
A1=[-(Rg+Ron)/LM	0;  0 -1/(R*C)];
B1=[1/LM 0;  0  0]; 
E1=[0 1; 0 1/R];
F1=[0 0; 0 0];
%starea 2 
A2=[-Rg/(LM*(1+n)^2)	  -1/(LM*(1+n));   1/((1+n)*C)	-1/(R*C)];
B2=[1/(LM*(1+n)) -1/(LM*(1+n));  0  0]; 
E2=[0 1; 0 1/R];
F2=[0 0; 0 0];
   
Ad=D*A1+(1-D)*A2;
Bd=D*B1+(1-D)*B2;
Ed=D*E1+(1-D)*E2;
Fd=D*F1+(1-D)*F2;

%simulare folosind modelul comutat
Tsim = [0 40e-3]; %simulam pe o durata de 10ms, pornind de la t=0
% definim pasul de simulare dt, pentru modelul comutat dt trebuie sa fie de 100-1000 ori mai mic decat Ts
% ex: daca alegem dt = Ts = 10us, rezultatul simularii nu mai este corect
dt = odeset('MaxStep', Ts/100); 
X0 = [0;0]; %conditii initiale nule
X0 = [4.2510 ;  28.0438]; %conditii initiale pentru a incepe simularea direct din stare stationara
                          %se iau valorile din vectorul x de la finalul unei perioade, dupa ce functionarea convertorului s-a stabilizat
                          %[2.1248; 19.2163] - ultimele valori din vectorul x
[tc,xc] = ode45('comutat', Tsim, X0, dt);
figure(1)
subplot(2,1,1)
plot(tc, xc(:,1)); %afisam grafic prima marime din x (iL)
xlabel("timp [s]"); ylabel("iL [A]");
title("simulare folosind modelul comutat")
subplot(2,1,2)
plot(tc, xc(:,2)); %afisam grafic a doua marime din x (vC)
xlabel("timp [s]"); ylabel("vC [V]");

%simulare folosind modelul mediat
Tsim = [0 40e-3]; %simulam pe o durata de 10ms, pornind de la t=0
% definim pasul de simulare dt, pentru modelul mediat dt poate sa fie egal cu Ts
dt = odeset('MaxStep', Ts); 
X0 = [0;0]; %conditii initiale nule 
% conditii initiale pentru a incepe simularea direct din stare stationara,se decomenteaza liniile 48 si 49
U = [Vg; VD]; %vector de intrare utilizat pentru a calcula X0
X0 = -inv(Ad) * Bd * U; %valabil pentru modelul mediat
[tm,xm] = ode45('mediat', Tsim, X0, dt);
figure(2)
subplot(2,1,1)
plot(tm, xm(:,1)); %afisam grafic prima marime din x (iL)
xlabel("timp [s]"); ylabel("iL [A]");
title("simulare folosind modelul mediat")
subplot(2,1,2)
plot(tm, xm(:,2)); %afisam grafic a doua marime din x (vC)
xlabel("timp [s]"); ylabel("vC [V]");

figure(3)
%afisam pe acelasi grafic rezultatele de la modelul mediat si comutat
subplot(2,1,1)
plot(tc,xc(:,1),tm,xm(:,1)); %afisam grafic prima marime din x (iL)
xlabel("timp");  ylabel("iL [A]");
title("simulare folosind modelele mediat si comutat")
legend("iL-comutat","iL-mediat")
subplot(2,1,2)
plot(tc,xc(:,2),tm,xm(:,2)); %afisam grafic a doua marime din x (vC)
xlabel("timp");   ylabel("vC [V]");
legend("vC-comutat","vC-mediat")

% %simulare folosind comanda lsim (este echivalenta cu cea obtinuta folosind modelul mediat)
% circuit = ss(Ad, Bd, Ed, Fd); %definin circuitul simulat
% tsim = 0:Ts:10e-3; %timpul de simulare folosit pentru comanda lsim (se specifica timpul initial, pasul si timpul final)
% % Vg are aceeasi valoare la fiecare moment de timp din tsim (pe toata durata simularii)
% Vg_v = Vg * ones(length(tsim), 1);   %vector de tip coloana cu toate elementele egale cu Vg
% % Vg_v = Vg + 0.5*sin(2*pi*1e3*tsim)'; %Vg cu perturbatii sinusoidale
% % VD are aceeasi valoare la fiecare moment de timp din tsim (pe toata durata simularii)
% VD_v = VD * ones(length(tsim), 1);   %vector de tip coloana cu toate elementele egale cu VD
% u = [Vg_v VD_v]; 
% X0 = [0; 0]; %conditii initiale nule 
% y = lsim(circuit, u, tsim, X0);
% %afisam pe acelasi grafic rezultatele obtinute folosind modelul mediat si comanda lsim
% figure(4)
% subplot(2,1,1)
% plot(tm,xm(:,1),tsim, y(:,1)) 
% xlabel("timp"); ylabel("iL [A]");%afisam grafic prima marime din x (iL)
% title("simulare folosind modelul mediat si comanda lsim")
% legend("iL-mediat","iL-lsim")
% subplot(2,1,2)
% plot(tm,xm(:,2),tsim, y(:,2)) %afisam grafic a doua marime din x (vC)
% xlabel("timp");  ylabel("vC [V]");
% legend("vC-mediat","v0=vC-lsim")
% 
