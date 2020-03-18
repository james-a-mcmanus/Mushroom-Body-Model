function [weights, numactivity] = main_low_mem(layers, num_neurons, cons, train, varargin)
    
    % program control
    disptime = 40;
    resttime = 10;    
    
    if train
        
        training = data( 'C:\Users\MIKKO\OneDrive\Sheffield\Matlab\MB Models\Wessnitzer 2011\Data\MNIST\train\' );
        
    else % test
        
        training = data( 'C:\Users\MIKKO\OneDrive\Sheffield\Matlab\MB Models\Wessnitzer 2011\Data\MNIST\test\' );

    end
    
    training = randomise_input(training);
        
    weights = weightob(num_neurons);
    weights.numcons = cons;
    weights.initialise;    
    
    % need to objectify the training data a bit more.
    numdata = one_each_number( training );
    
    numsteps = length(numdata.labels) * ( disptime  + resttime ) - 1;
    
    if ~exist('numsteps','var') || isempty(numsteps)
        numsteps = length( training.labels ) * ( disptime + resttime ) ;
    end
    
    activations = activatob(num_neurons);
    spiked = spikob(num_neurons);
    
    % universal variables
  
    c = -65;
    d = 8;
    noisestd = 0.05;    
    td = 10;
    da = 0;
    ba = 0;
    tc = 40;
    amp = -1;
    tplus = 15;
    imdisplay = 40;
    datime = 40;
    rest = 10;
    norm_factor = 40*num_neurons(2);%0.00000005; % update so that only small % spike at any one time?
    input_activity = 40 * num_neurons(1);
    rewardednums = 3;
    
    % variables for each layer
    normalise = [false true false];
    activate = [true true true];
    layerweights = [0.25 2];
    cap = [100 4 100];
    a = [0.3 0.01 0.3];
    b = [-0.2 -0.3 -0.2];
    k = [2 0.035 2];
    threshold = [-40 -25 -40];
    resting_potential = [-60 -85 -60];
    synt = [3 8 nan];
    quantile = [0.93 8 nan];
   
    
    % variables  for each neuron/synapes
    recovery = neurob(num_neurons);
    recovery.fillall(0);
    timesincespike = neurob(num_neurons);
    timesincespike.fillall(0);
    nt = neurob(num_neurons);
    nt.fillall(0);
    output = synob(num_neurons);
    synob.fillall(0);
    
    
    tag = fill_synapses(layers, num_neurons, 0);
    reversal_pot = fill_neurons(layers, num_neurons, 0);
    
    % main loop
    for t = 1:numsteps

        
        da = update_da(da, td, ba);       
        [input, number, ba] = get_input( t, numdata, num_neurons(1), disptime, resttime, input_activity, rewardednums);
        
        
        % update each layer
        for l = 1:layers
            
            
            activations.update_activation(l, input, resting, threshold, recovery, timesincespike, output, cap(l), a(l), b(l), c, d, k(l),noisestd, nt{l}, reversal_pot{l}, synt(l), quantile(l), normalise(l), norm_factor);
                       
            weights.update_weights()
            
            
            if update_weights(l)
                weights{l-1} = change_weights(weights{l-1},connections{l-1},timesincespike{l-1},timesincespike{l},tag{l-1},amp,da,tc,tplus);
            end
            
            if l < layers
                input = sum(output{l} .* weights{l})';
            end
        
        end
        
        if ~train
            numactivity(number+1,1) = numactivity(number+1,1) + sum(spiked{end-1});
            numactivity(number+1,2) = numactivity(number+1,2) + 1;
        end
        
    
    end
