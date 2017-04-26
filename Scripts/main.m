close all;
clear;

%% Param
% parametres biologiques pour simulation
f_card = 80/60; 
f_resp    = 0.20;

% defini la plage de freq cardiaque possible
interv_f_card_bpm = [60 240];
interv_f_card_Hz  = interv_f_card_bpm/60;
interv_f_card_T   = 1./interv_f_card_Hz(end:-1:1);

% parametres signal entree
ips    = 30; % nb image/s de la camera
duree  = 10; % en secondes
taille = ips*duree;
nb_sig = 1; % nb de signaux generes

% parametres simulation
pas       = 0.1; % pas entre deux valeurs de amp_card
amp_card  = pas:pas:1; 
amp_resp  = 1;
amp_bruit = 0.3;

% structures
simu           = struct('sig', zeros(taille, nb_sig), 'duree', duree, 'ips', ips);
fichier_reel   = struct('sig', zeros(taille, nb_sig), 'duree', duree, 'ips', ips);
fichier_reel_2 = struct('sig', zeros(taille, nb_sig), 'duree', duree, 'ips', ips);

%% Creation signaux simules
for i = 1:1:nb_sig
    simu.sig(:, i) = creer_signal(duree, ips, f_card, amp_card(i), f_resp, amp_resp, amp_bruit);
end

%% Signaux reels

% donnee1 = load('Donnee/coordonnees.mat');
% fichier_reel.sig   =  [donnee1.x1' - donnee1.x1(1), donnee1.x2' - donnee1.x2(1), ...
%    donnee1.x3' - donnee1.x3(1), donnee1.x4' - donnee1.x4(1), ...
%    donnee1.x5' - donnee1.x5(1), donnee1.x6' - donnee1.x6(1)];

% fichier_reel_2.sig = [donnee1.y1' - donnee1.y1(1), donnee1.y2' - donnee1.y2(1), ...
%    donnee1.y3' - donnee1.y3(1), donnee1.y4' - donnee1.y4(1), ...
%    donnee1.y5' - donnee1.y5(1), donnee1.y6' - donnee1.y6(1)];

donnee2 = load('Donnee/donnees2.mat');
data3 = permute(donnee2.matricepoints(:, 2, 1:300), [3, 1, 2]);
data3_size = size(data3);
fichier_reel_3 = struct('sig', data3, 'duree', data3_size(1)/donnee2.Fe, 'ips', donnee2.Fe);
clear data3_size;

%% Filtrage
load 'Filtres/filter.mat';

simu_filtre       = filtrage(fichier_reel_3, BpFilter);
simu_filtre.sig   = simu_filtre.sig(mean(grpdelay(BpFilter)):end, :); % bien verifier que la taille choisie est divisible par ips
simu_filtre.duree = length(simu_filtre.sig(:, 1))/simu_filtre.ips; 

%% Refenetrage
% O permet d'afficher toutes les courbes
[entree, sig_filtre] = fenetrage(1, fichier_reel_3, simu_filtre);

%% Affichage
afficher_signal(entree, 0, 10);
afficher_signal(sig_filtre, 0, simu_filtre.duree);

aff_DSP(entree, 0, 15, 0, 50);
aff_DSP(sig_filtre, 0, 15, 0, 10);

%% Estimation freq cardiaque moyenne
F_moy     = estim_F_moy(simu_filtre);
F_moy_bpm = 60*F_moy;

%% Estimation de alpha_i par la DSP
delta_freq      = 0.5; % en Hz
[sig_z, alpha]  = estim_alpha(simu_filtre, F_moy, delta_freq, interv_f_card_bpm);
F_finale        = estim_F_moy(sig_z);
F_finale_bpm    = 60*F_finale;

% % affichier le signal E(zi)= E(s(t))= E(s(t)+ni(t)/alphai) (dans
% l'hypothese d'un bruit blanc) afficher_signal(sig_z, 0, sig_z.duree);
% sig_z_moy = struct('sig', sum(sig_z.sig, 2)/nb_sig, 'duree', sig_z.duree,
% 'ips', ips); afficher_signal(sig_z_moy, 0, sig_z_moy.duree);
