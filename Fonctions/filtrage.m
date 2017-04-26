% Cette fonction filtre un ensemble de signaux d entree par un filtre
% defini en entree et calcule au prealable pour les besoin de l
% application. Plus de details sur les parametres du filtres dans le
% rapport de projet.
function [sortie] = filtrage(fichier, filtre)
    
    lg     = size(fichier.sig);
    nb_sig = lg(2);
    
    for i = 1:1:nb_sig
        sortie.sig(:, i) = filtre.filter(fichier.sig(:, i));
    end
    
    sortie.duree = fichier.duree;
    sortie.ips   = fichier.ips;
    
end
