function [ sortie ] = DSP( fichier )
%Structure fichier
%Calcule seulement la DSP

taille = fichier.ips*fichier.duree;
fe     = fichier.ips;

% calcul de la DSP
    DSP = fftshift(abs(fft(fichier.sig, taille)));
    sortie = DSP;
    
end

