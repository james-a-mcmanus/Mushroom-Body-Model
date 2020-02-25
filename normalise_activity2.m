function volts = normalise_activity2(volts, rest)

    
    difference = volts - rest;
    
    pos = -1 + 2 * ( difference > 0 );
    
    volts = volts + difference .* pos .* 0*sqrt(sum(difference.^2)); % should this factor be related to the number of neurons???? or the overall activity?
   

end