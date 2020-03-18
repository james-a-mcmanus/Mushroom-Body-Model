classdef neurob < handle
    
    properties
    
        numneurons
        numlayers
        array
        
    end
    
    methods
    
        function obj = neurob(numneurons)
        
            obj.numneurons = numneurons;
            obj.numlayers = length(numneurons);
            obj.initarray();
            
        end
    
        function initarray(obj)
        
            nn = obj.numneurons;
            nl = obj.numlayers;
            
            a = cell(1,obj.numlayers);
            
            for l = 1:nl 
                a{l} = nan(nn(l),1);
            end
            
            obj.array = a;
        
        end
        
    end

end
    