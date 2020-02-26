function [weights, numactivity] = main_low_mem(layers, num_neurons, cons, train, varargin)
    
    %close all;
    % random change to test git.

    
    % program control
    show_activations = false;
    show_aps = true;
    save_gif = false;
    disptime = 40;
    resttime = 10;    
    
    if train
        
        training = data( 'C:\Users\MIKKO\OneDrive\Sheffield\Matlab\MB Models\Wessnitzer 2011\Data\MNIST\train\' );
        training = randomise_input( training );
        update_weights = [false false true]; % this should really be input
        weights =cell( 1, layers - 1 );
        connections = weights;
        for l = 1:layers-1
            weights(l) = initialise_weights( 2, num_neurons( l : l + 1 ), 2, cons(l), 2 );
            connections{l} = weights{l} > 0;    
        end        
        
    else % test
        
        training = data( 'C:\Users\MIKKO\OneDrive\Sheffield\Matlab\MB Models\Wessnitzer 2011\Data\MNIST\test\' );
        training = randomise_input( training );
        update_weights = [false false false];
        weights = varargin{1};
        show_aps = varargin{2};
        numactivity = zeros(10, 2);
        
    end
    
    numdata = one_each_number( training );
    numsteps = length(numdata.labels) * ( disptime  + resttime ) - 1;
    
    if ~exist('numsteps','var') || isempty(numsteps)
        numsteps = length( training.labels ) * ( disptime + resttime ) ;
    end
    
    if show_activations || show_aps
        f = figure; %#ok<*UNRCH>
    end
    
    if save_gif
        fname = 'out/network.gif';
        snapevery = 10;
        im = cell( floor( numsteps / snapevery ), 1 );
    end
    
    
    activations = cell( 1, layers );
    activations(:) = initialise_activations( layers, num_neurons );

    spiked = cell( 1, layers );
    
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
    recovery = fill_neurons(layers, num_neurons, 0);
    timesincespike= fill_neurons(layers, num_neurons, 0);
    nt = fill_neurons(layers, num_neurons, 0);
    output = fill_synapses(layers, num_neurons, 0);
    tag = fill_synapses(layers, num_neurons, 0);
    reversal_pot = fill_neurons(layers, num_neurons, 0);

    wb = waitbar(0, 'Running Model');
    % main loop
    for t = 1:numsteps
        
        try
        waitbar(t/numsteps,wb)
        catch
            return
        end
        
        da = update_da(da, td, ba);       
        % also best to output the ba in here.
        [input, number, ba] = get_input( t, numdata, num_neurons(1), disptime, resttime, input_activity, rewardednums);
        input1 = input;
        
        
        % update each layer
        for l = 1:layers
            
            if activate(l)               
                [activations{l}, recovery{l}, timesincespike{l}, spiked{l}, output{l}] = update_activation(num_neurons(l), input, activations{l}, resting_potential(l), threshold(l), recovery{l}, timesincespike{l}, cap(l), a(l), b(l), c, d, k(l),noisestd, nt{l}, reversal_pot{l}, synt(l), quantile(l), normalise(l), norm_factor);
            end
            
%              if normalise(l)
% %                      activations{l} = normalise_activity(activations{l}, output{l}, norm_factor, resting_potential(l));
%              end
            
            if update_weights(l)
                weights{l-1} = change_weights(weights{l-1},connections{l-1},timesincespike{l-1},timesincespike{l},tag{l-1},amp,da,tc,tplus);
            end
            
            if l < layers
                input = sum(output{l} .* weights{l})';
            end

        % plot the activations.    
        if show_activations || show_aps
            subplot(1,layers+1,l+1)
            if show_activations
                imagesc(activations{l},[-85 -25]);
            elseif show_aps
                imagesc(timesincespike{l}==0);
            end
            drawnow
            title(num2str(number))
        end
        
        end
        
        if show_activations || show_aps
            subplot(1,layers+1,1)
            image(input1)
            drawnow
            title(num2str(number))
        end            
        
        if ~train
            numactivity(number+1,1) = numactivity(number+1) + sum(spiked{end-1});
            numactivity(number+1,2) = numactivity(number+1) + 1;
        end
        
        if save_gif && mod(t,snapevery)==0 %#ok<*NODEF>
            frame = getframe(f);
            im{t/snapevery} = frame2im(frame);  %#ok<*NASGU,*AGROW>
        end
    end
    
    if save_gif
        save_gif(im,fname)
    end
    
    close(wb);
    
end
