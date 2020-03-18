classdef synob < handle
    properties
        
        array
        numneurons
        numlayers
        
    end
    methods
        
        function obj = synob(numneurons)
        
            obj.numneurons = numneurons;
            obj.numlayers = length(numneurons);
            obj.initarray();
            
        end
        
        function initarray(obj)
        
            nn = obj.numneurons;
            nl = obj.numlayers;
            
            a = cell(1,nl-1);
            
            for l = 1:nl - 1
                
                a{l} = nan(nn(l), nn(l+1));
            end
            
            obj.array = a;
        end
        
    end
end
