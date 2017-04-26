% cette fonction calcule la DSP des signaux presents dans le fichier et les
% stocke dans une matrice de sortie
function [sortie] = DSP(fichier)

    taille = fichier.ips*fichier.duree;
    fe     = fichier.ips;

% calcul de la DSP
    DSP    = fftshift(abs(fft(fichier.sig, taille)));
    sortie = DSP;
    
end

