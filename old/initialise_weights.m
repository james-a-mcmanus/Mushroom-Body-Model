function weights  = initialise_weights(numlayers, numneurons, varargin)

if isempty(varargin)
    setting = 1;
else
    setting = varargin{1};
end

weights = cell(1,numlayers -  1);

 for l = 1: numlayers - 1
     
     switch setting
         case 1
             weights{l} = (randn(numneurons(l), numneurons(l+1)));
         case 2
             % cons is how many presynaptic neurons connect to each
             % postsynaptic neuron (i.e how many upstream partners);
             cons = varargin{2}(l);
             if cons > numneurons(l)
                 fprintf(2,'\n More connections than presynaptic neurons!\n')
             end
             permby = nan(numneurons(l),numneurons(l+1));
             weights{l} =  zeros(numneurons(l), numneurons(l+1)); % basically 10 connections spread across 
             weights{l}(1:cons,:) = varargin{3};
             for n = 1:numneurons(l+1)
                permby(:,n) = randperm(numneurons(l));
             end
             weights{l} = weights{l}(permby);
     end
     
 end
end