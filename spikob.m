classdef spikob < neurob

    properties
        
        dstate = false;
        % array is the time since the spike
        spiked = [];
        spikes4num
        numnums = 10;
        
    end
    
    methods
        
        function obj = spikob(numneurons)
        
            obj = obj@neurob(numneurons);
            obj.spiked = obj.array;
            obj.spikes4num = repelem(obj.array,obj.numnums,1);
            
        end
        
        function initialise(obj)
        
            obj.fillall(obj.dstate)
        
        end
        
        function update_numcounts(obj, layer, num)
        
            obj.spikes4num{num+1,layer} = obj.spikes4num{num+1,layer} + obj.spiked{layer};
        
        end
        
    end
    
end