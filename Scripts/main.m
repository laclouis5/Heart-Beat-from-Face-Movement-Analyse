close all;
clear;

%% Param
% parametres biologiques pour simulation
f_card = 80/60; 
f_resp    = 0.20;

% d?fini la plage de freq cardiaque possible
interv_f_card_bpm = [60 240];
interv_f_card_Hz  = interv_f_card_bpm/60;
interv_f_card_T   = 1./interv_f_card_Hz(end:-1:1);

% parametres signal de simulation
ips    = 30; % nb image/s de la camera
duree  = 10; % en secondes
taille = ips*duree;
nb_sig = 6; % nb de signaux generes

% parametres simulation
pas       = 0.1; % pas entre deux valeurs de amp_card
amp_card  = pas:pas:1; 
amp_resp  = 1;
amp_bruit = 0.3;

% structures
simu         = struct('sig', zeros(taille, nb_sig), 'duree', duree, 'ips', ips);
fichier_reel = struct('sig', zeros(taille, nb_sig), 'duree', duree, 'ips', ips);
fichier_reel_2 = struct('sig', zeros(taille, nb_sig), 'duree', duree, 'ips', ips);

%% Creation signaux simules
for i = 1:1:nb_sig
    simu.sig(:, i) = creer_signal(duree, ips, f_card, amp_card(i), f_resp, amp_resp, amp_bruit);
end

%% Signaux reels
donnee1 = load('Donnee/coordonnees.mat');

fichier_reel.sig =  [donnee1.x1' - donnee1.x1(1), donnee1.x2' - donnee1.x2(1), ...
    donnee1.x3' - donnee1.x3(1), donnee1.x4' - donnee1.x4(1), ...
    donnee1.x5' - donnee1.x5(1), donnee1.x6' - donnee1.x6(1)];

fichier_reel_2.sig = [donnee1.y1' - donnee1.y1(1), donnee1.y2' - donnee1.y2(1), ...
    donnee1.y3' - donnee1.y3(1), donnee1.y4' - donnee1.y4(1), ...
    donnee1.y5' - donnee1.y5(1), donnee1.y6' - donnee1.y6(1)];

%% Filtrage
load 'Filtres/filter.mat';

simu_filtre       = filtrage(fichier_reel, BpFilter);
simu_filtre.sig   = simu_filtre.sig(mean(grpdelay(BpFilter)):end, :); % bien verifier que la taille choisie est divisible par ips
simu_filtre.duree = length(simu_filtre.sig(:, 1))/simu_filtre.ips; 

%% Refenetrage
courbe_a_aff = 5;
% enlever "(:, courbe_a_aff)" pour affichier toutes les courbes
entree       = struct('sig', fichier_reel.sig(:, courbe_a_aff),'duree', ...
    fichier_reel.duree, 'ips', fichier_reel.ips);
sig_filtre   = struct('sig', simu_filtre.sig(:, courbe_a_aff),'duree', ...
    simu_filtre.duree, 'ips', simu_filtre.ips);

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

% % affichier le signal E(zi)= E(s(t))= E(s(t)+ni(t)/alphai) (dans l'hypothese d'un bruit blanc)
% afficher_signal(sig_z, 0, sig_z.duree);
% sig_z_moy = struct('sig', sum(sig_z.sig, 2)/nb_sig, 'duree', sig_z.duree, 'ips', ips);
% afficher_signal(sig_z_moy, 0, sig_z_moy.duree);

% Essai méthode PCA
f_pca = methode_PCA(simu_filtre);