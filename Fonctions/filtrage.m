function [ sortie ] = filtrage( fichier, filtre)
    
    lg        = size(fichier.sig);
    nb_sig    = lg(2);
    
    for i = 1:1:nb_sig
        sortie.sig(:, i) = filtre.filter(fichier.sig(:, i));
    end
    
    sortie.duree = fichier.duree;
    sortie.ips   = fichier.ips;
    
end
