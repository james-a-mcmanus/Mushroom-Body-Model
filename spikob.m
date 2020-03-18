classdef spikob < neurob

    properties
        
        dstate = false;
        
    end
    methods
        
        function obj = spikob(numneurons)
        
            obj = obj@neurob(numneurons);
        
        end
        
        function initialise(obj)
        
            obj.fillall(obj.dstate)
        
        end
        
    end
    
end