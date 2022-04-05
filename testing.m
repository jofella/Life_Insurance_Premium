clc; clear all; close all;
%% Input definieren für x-Simulationen von t40-t60 (Männer)

%Inputwerte für Simulation
N_Simulationen = 100000;

N_Policen = 10000; N_Policen_v = ones(N_Simulationen,1).*N_Policen; %Überführung in Vektorendarstellung
Praemienhoehe = 6000;
Leistung = 400000;
Zins_mu = 0.009;
Zins_std = 0.025;

%Sterbetafel aus Excel eingelesen
Dummy = readmatrix('Sterbetafel.xlsx');
qx = Dummy(:,3);

%% Zinsberechnung
Zufallszahl_Zins = rand([N_Simulationen 40]);
Zinsfaktor = norminv(Zufallszahl_Zins,Zins_mu,Zins_std);

%% Tote
Zufallszahl_Tote = rand([N_Simulationen 40]);

%Leere Matrizen die befüllt werden sollen
mu_Tote = ones(N_Simulationen,40);
std_Tote = ones(N_Simulationen,40);
Todesfaelle = zeros(N_Simulationen,40);
Praemien = zeros(N_Simulationen,40);

Dummy = ones(N_Simulationen,39);
delta_N_Policen = [N_Policen_v Dummy];

%% Berechnung der Matrizen
for i = 1:40
    mu_Tote(:,i) = delta_N_Policen(:,i)*qx(i);
    std_Tote(:,i) = sqrt(mu_Tote(:,i)*(1-qx(i)));
    Todesfaelle(:,i) = round(norminv(Zufallszahl_Tote(:,i),mu_Tote(:,i),std_Tote(:,i)));
    delta_N_Policen(:,i+1) = delta_N_Policen(:,i) - Todesfaelle(:,i); %theoretisch eine Spalte zuviel
    Praemien(:,i) = delta_N_Policen(:,i)*Praemienhoehe;
end

%% Leistungen Berechnen
Leistungen = zeros(N_Simulationen,40);

for j = 2:40
    Leistungen(:,j) = round(Todesfaelle(:,j-1)*Leistung);
end

%% Reserven
Reserven = [Praemien(:,1) zeros(N_Simulationen,39)];
%Prämien-Leistungen zusammenfassen
Dummy = Praemien - Leistungen;

for h = 2:40
    Reserven(:,h) = Reserven(:,h-1).*(1+Zinsfaktor(:,h)) + Dummy(:,h);
end


%% Finale Analyse

%Endwert der Simulationen
Reserve_T = Reserven(:,end);
min_Reserve_T = min(Reserve_T);
max_Reserve_T = max(Reserve_T);
mean_Reserve_T = mean(Reserve_T);

%Probability of sufficiency
Simulationen_uber_Null = sum(Reserve_T>0); %Anzahl der Simulationen
Probability_Non_Default = Simulationen_uber_Null/N_Simulationen;

%% Grafische Darstellung

%Erstellen eines Histogramms
figure(1)
histogram(Reserve_T,12,'DisplayStyle','bar');
title('$Reserven$ $am$ $Laufzeitende$','interpreter','latex','fontsize',16);
xlabel('$Millionen$ $in$ $Euro$','interpreter','latex','fontsize',10);
ylabel('$Anzahl$','interpreter','latex','fontsize',10);
xlim([min_Reserve_T max_Reserve_T]);
%ylim([0 Simulationen_uber_Null]);

set(gca,'color','none');

%Anzeigen des Mittelwerts
hold on
line([mean_Reserve_T, mean_Reserve_T], ylim, 'LineWidth', 2, 'Color', 'r');
legend('Simulierte Reserven','Mittelwert')
hold off