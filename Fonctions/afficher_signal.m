% fichier : structure de type {signal duree ips}
function [] = afficher_signal( fichier, varargin )

    fe     = fichier.ips;
    t      = 0:1/fe:(fichier.duree - 1/fe);
    
    % permet de specifier les bornes d'affichage
    nbargin = length(varargin);
    figure, plot(t, fichier.sig);
        
    if nbargin == 2
        xlim([varargin{1} varargin{2}]);
    elseif nbargin == 4
        xlim([varargin{1} varargin{2}]), ylim([varargin{3} varargin{2}]);
    elseif nbargin > 4 || (nbargin == 1)
        error('nombre d arguments incorrects');
    end
    
    grid;
    title('signal d interet');
    xlabel('temps en secondes');
    ylabel('amplitude');

end