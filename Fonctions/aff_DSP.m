% fichier : structure de type {signal duree ips}
function [ sortie ] = aff_DSP( fichier, varargin )

% Utile de recalculer la DSP?

    taille = fichier.ips*fichier.duree; % taille du signal (= nb_points)
    fe     = fichier.ips;
    faxis  = (-fe/2:fe/taille:fe/2 - fe/taille);
     
%     % calcul de la DSP
     DSP = fftshift(abs(fft(fichier.sig, taille)));
    
    % permet de sp?cifier les bornes d'affichage
    nbargin = length(varargin);
    figure, plot(faxis, DSP);
    
    if nbargin == 0
        xlim([0 6]), ylim([0 0.7]);
    elseif nbargin == 2
        xlim([varargin{1} varargin{2}]), ylim([0 0.7]);
    elseif nbargin == 4
        xlim([varargin{1} varargin{2}]), ylim([varargin{3} varargin{4}]);
    else
        error('nombre d arguments incorrects');
    end
    
    title('S(f) TF du signal s(t)');
    xlabel('Frequence en Hz'), ylabel('|S(f)|');
    grid;
    
    sortie = DSP;
end