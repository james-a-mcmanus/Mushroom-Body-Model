function out = fill_synapses(num_layers, num_neurons,withwhat)

    out = cell(1,num_layers-1);

    for l = 1:num_layers-1
    
        out{l} = zeros(num_neurons(l),num_neurons(l+1)) + withwhat;
    
    end
end