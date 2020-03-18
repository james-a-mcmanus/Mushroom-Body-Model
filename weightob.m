classdef weightob < handle
    
    properties
    
        numneurons
        numlayers
        weight = 2
        array = []
        numcons
        connections = [];
        setting = 2
        
    end
    
    methods
        
        function obj = weights(numneurons)
            
                obj.numneurons = numneurons;
                obj.numlayers = length(numneurons);

        end
        
        function initialise(obj)

            nn = obj.numneurons;
            w = cell(1,obj.numlayers-1); c = cell(1,obj.numlayers-1);
            
            
            for l = 1: obj.numlayers - 1

                switch obj.setting

                    case 1

                        w{l} = (randn(nn(l), nn(l+1)));
                        c{l} = ones(nn(l),nn(l+1));

                    case 2

                        cons = obj.numcons;

                        permby = nan(nn(l),nn(l+1));
                        w{l} =  zeros(nn(l), nn(l+1)); % basically 10 connections spread across 

                        w{l}(1:cons,:) = obj.weight;

                        for n = 1:nn(l+1)
                            permby(:,n) = randperm(nn(l));
                        end

                        w{l} = w{l}(permby);
                        c{l} = w{1} ~= 0;

                end

                obj.array = w;
                obj.connections = c;

            end            
            
        
        end
        
        
    end
    
end