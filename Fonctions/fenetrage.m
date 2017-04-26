% cette fonction permet de creer un fichier de sortie semblable au fichier
% d entree mais qui contient dans le champs "sig" seulement la courbe
% selectionnee. Cela permet d afficher seulement la courbe selectionnee
% plus tard avec d autres fonctions (afficher_signal)
function [entree, sig_filtre] = fenetrage(courbe_a_aff, fichier_entree, fichier_simu)

    % si courbe_a_aff = O on affiche toutes les courbes
    
    if courbe_a_aff == 0
        entree = struct('sig', fichier_entree.sig,'duree', ...
         fichier_entree.duree, 'ips', fichier_entree.ips);
     
        sig_filtre = struct('sig', fichier_simu.sig,'duree', ...
            fichier_simu.duree, 'ips', fichier_simu.ips);
    
    else
        entree = struct('sig', fichier_entree.sig(:, courbe_a_aff),'duree', ...
            fichier_entree.duree, 'ips', fichier_entree.ips);
        
        sig_filtre = struct('sig', fichier_simu.sig(:, courbe_a_aff),'duree', ...
            fichier_simu.duree, 'ips', fichier_simu.ips);
    end
    
end

