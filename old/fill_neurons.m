function out = fill_neurons(numlayers, numneurons, tofill)

    out = cell(1,numlayers);
    
    for l = 1:numlayers
        
        out{l} = zeros(numneurons(l),1) + tofill;
        
    end

end