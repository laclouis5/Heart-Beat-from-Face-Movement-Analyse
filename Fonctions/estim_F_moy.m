function [ F_moy ] = estim_F_moy( fichier )
    taille    = fichier.ips*fichier.duree;
    lg        = size(fichier.sig);
    nb_sig    = lg(2);
    duree     = fichier.duree;
    ips       = fichier.ips;
    debut_fft = ceil(taille/2 + 1);
    
    sig_mean = struct('sig', sum(fichier.sig, 2)/nb_sig, 'duree', duree, 'ips', ips);
    
    sortie    = DSP(sig_mean);
    fenetre_F = [debut_fft, taille]; % 6 pour la fin de la fenetre d affichage

    sortie_fenetree = sortie(round(fenetre_F(1)):round(fenetre_F(2)));

    [ord, absc] = findpeaks(sortie_fenetree, duree);
    F_moy       = absc(ord == max(ord)); % frequence en Hz

    % figure, findpeaks(sortie_fenetree, duree);
end

