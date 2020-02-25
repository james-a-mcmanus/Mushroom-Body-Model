function newactivations = normalise_activity(activations, output, factor, rest)
   
    newactivations = activations + sum(output) * factor * ( rest - activations );

end