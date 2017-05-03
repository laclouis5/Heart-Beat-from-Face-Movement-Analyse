close all;
clear;

%% Param
% parametres biologiques pour simulation
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
fichier  = struct('sig', zeros(taille, nb_sig), 'duree', duree, 'ips', ips);

%% boucle de calcul
for f_card = 60:10:250

    for i = 1:1:nb_sig
        fichier.sig(:, i) = creer_signal(duree, ips, f_card, amp_card(i), f_resp, amp_resp, amp_bruit);
    end

    load 'Filtres/filter.mat';

    simu_filtre       = filtrage(fichier, BpFilter);
    simu_filtre.sig   = simu_filtre.sig(mean(grpdelay(BpFilter)):end, :); % bien verifier que la taille choisie est divisible par ips
    simu_filtre.duree = length(simu_filtre.sig(:, 1))/simu_filtre.ips; 

    F_moy     = estim_F_moy(simu_filtre);
    F_moy_bpm = 60*F_moy;

    delta_freq      = 0.5; % en Hz
    [sig_z, alpha]  = estim_alpha(simu_filtre, F_moy, delta_freq, interv_f_card_bpm);
    F_finale        = estim_F_moy(sig_z);
    F_finale_bpm    = 60*F_finale;

    F_pca = methode_PCA(simu_filtre)*60;
    
    F = []
end