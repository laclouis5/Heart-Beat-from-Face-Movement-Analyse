function [ Freq_estime ] = estim_F_moy_autocorr( fichier, interv_f_card_T )

    signal = fichier.sig;
    ips = fichier.ips;
    taille = fichier.ips*fichier.duree;

    autocorr = xcorr(signal, 'unbiased');
    % figure, plot(echelle/(simu_filtre.ips), autocorr), title('autocorr'), grid;

    fenetre_T = round(interv_f_card_T.*ips + taille);
    figure, findpeaks(autocorr(fenetre_T(1):fenetre_T(2)));

    [pks, locs] = findpeaks(autocorr(round(taille+0.25*ips):round(taille+ips)));
    T           = locs(pks == max(pks))/ips + 0.25;
    Freq_estime = 1/T*60;

end

