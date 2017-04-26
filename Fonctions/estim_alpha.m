% Cette fonction prend en entree un fichier qui contient un ensemble de
% signaux et va calculer un rapport de puissance entre 2 zones distinctes
% de la DSP de ces signaux pour chaque signal puis il va diviser les
% signaux d'entree par ce rapport de puissance. Plus de details sur la
% methode utilisee dans le rapport de projet
function [sortie, alpha] = estim_alpha(fichier, F_moy, delta_freq, interv_f_card)
    
    interv_f_card_Hz  = interv_f_card/60;
    
    taille    = fichier.ips*fichier.duree;
    debut_fft = taille/2 + 1;
    
    sz = size(fichier.sig);
    lg = sz(1);
    
    %Calcul DSP
    DSP_sig = DSP(fichier); %DSP sur fichier.sig
    
    % DSP selon intervalles
    interv_P1     = [round(debut_fft + (F_moy - delta_freq/2)*fichier.duree), ...
        round(debut_fft + (F_moy + delta_freq/2)*fichier.duree)];
    DSP_P1        = DSP_sig(interv_P1(1):interv_P1(2), :);
    
    interv_P21    = [round(debut_fft + interv_f_card_Hz(1)*fichier.duree), ...
        round(debut_fft + (F_moy - delta_freq/2)*fichier.duree)];
    DSP_P21       = DSP_sig(interv_P21(1):interv_P21(2), :);
    
    interv_P22    = [round(debut_fft + (F_moy + delta_freq/2)*fichier.duree), ...
        round(debut_fft + interv_f_card_Hz(2)*fichier.duree)];
    DSP_P22       = DSP_sig(interv_P22(1):interv_P22(2), :);

    %Rapport signal a bruit
    P21 = sum(DSP_P21);
    P22 = sum(DSP_P22);
    P1  = sum(DSP_P1);
    P2  = P21 + P22;

    alpha = P1./P2;
    
    %Calcul sig/alpha(i)
    alpha2 = repmat(alpha, lg, 1);
    z      = (fichier.sig)./alpha2;
    sig_z  = struct('sig', z, 'duree', fichier.duree, 'ips', fichier.ips);
    
    sortie = sig_z;
end

