function activations = initialise_activations(numlayers, numneurons, default)

    if ~exist('default','var')
        default = -85;
    end

    activations = cell(1,numlayers);
    
    for l = 1:numlayers
        
        activations{l} = ones(numneurons(l),1)*default;%randi([default-20 default+20],numneurons(l),1);
        
    end

end