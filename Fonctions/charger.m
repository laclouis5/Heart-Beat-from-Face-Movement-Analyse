function [ fichier ] = charger(donnee)

    donnee = load(donnee);
    
    data_size = size(donnee.matricepoints);
    data      = permute(donnee.matricepoints(:, 2, 1:floor(data_size(3)/donnee.Fe)), [3, 1, 2]);
    
    % soustrait le premier terme pour ?viter d avoir la r?ponse indicielle 
    for i = 1:data_size(1)
        firstTerm = data(1, i);
        data(:, 1) = data(:, 1) - firstTerm;
    end
    
    fichier = struct('sig', data, 'duree', floor(data_size(3)/donnee.Fe), 'ips', donnee.Fe);
    
end

