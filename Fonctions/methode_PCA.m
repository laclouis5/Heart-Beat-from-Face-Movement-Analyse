function [F_pca] = methode_PCA( fichier )
% estimation frequence avec la methode PCA
taille = fichier.ips*fichier.duree;
fe     = fichier.ips;
faxis  = (-fe/2:fe/taille:fe/2 - fe/taille);

[COEFF,SCORE] = pca(fichier.sig);
s = SCORE(:,2);

DSP = fftshift(abs(fft(s, taille)));

% % Affichage
%figure, plot(faxis,DSP);

[pks, locs] = findpeaks(DSP);
F           = faxis(locs(pks == max(pks)));
F_pca       = F(find(F>0));

end