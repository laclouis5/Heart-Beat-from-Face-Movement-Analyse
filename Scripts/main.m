close all;
clear;

%% Param
% parametres biologiques pour simulation
f_card    = 100/60; 
f_resp    = 35/60;

% defini la plage de freq cardiaque possible
interv_f_card_bpm = [60 240];
interv_f_card_Hz  = interv_f_card_bpm/60;
interv_f_card_T   = 1./interv_f_card_Hz(end:-1:1);

% parametres signal entree
ips    = 30; % nb image/s de la camera
duree  = 10; % en secondes
taille = ips*duree;
nb_sig = 10; % nb de signaux generes

% parametres simulation
pas       = 0.1; % pas entre deux valeurs de amp_card
amp_card  = pas:pas:1; 
amp_resp  = 5;
amp_bruit = 0.5;

% structures
simu  = struct('sig', zeros(taille, nb_sig), 'duree', duree, 'ips', ips);

%% Creation signaux simules
for i = 1:1:nb_sig
    simu.sig(:, i) = creer_signal(duree, ips, f_card, amp_card(i), f_resp, amp_resp, amp_bruit);
end

%% Signaux reels
% fichier1 = charger('Donnee/donnees.mat');
% fichier2 = charger('Donnee/donnees2.mat');
% fichier3 = charger('Donnee/donnees3.mat');
fichier4 = charger('Donnee/donnees4.mat');

fichier_Louis   = charger('Donnee/Donnees_Louis.mat');
fichier_Louis_2 = charger('Donnee/Donnees_Louis2.mat');
fichier_Justine = charger('Donnee/Donnees_Justine.mat');

fichier = simu;

%% Filtrage
load 'Filtres/filter.mat';

simu_filtre       = filtrage(fichier, BpFilter);
simu_filtre.sig   = simu_filtre.sig(mean(grpdelay(BpFilter)):end, :); % bien verifier que la taille choisie est divisible par ips
simu_filtre.duree = length(simu_filtre.sig(:, 1))/simu_filtre.ips; 

%% Refenetrage
% O permet d'afficher toutes les courbes
[entree, sig_filtre] = fenetrage(5, fichier, simu_filtre);

%% Affichage
afficher_signal(entree, 0, fichier.duree);
afficher_signal(sig_filtre, 0, simu_filtre.duree);

aff_DSP(entree, 0, 15, 0, 100);
aff_DSP(sig_filtre, 0, 15, 0, 100);

%% Estimation freq cardiaque moyenne
F_moy     = estim_F_moy(simu_filtre);
F_moy_bpm = 60*F_moy;

%% Estimation de alpha_i par la DSP
delta_freq      = 0.5; % largueur moyenne d un pic de freq cardiaque dans la fft
[sig_z, alpha]  = estim_alpha(simu_filtre, F_moy, delta_freq, interv_f_card_bpm);
F_finale        = estim_F_moy(sig_z);
F_finale_bpm    = 60*F_finale;

F_pca = methode_PCA(simu_filtre)*60;
