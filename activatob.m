classdef activatob < neurob
    
    properties
        
        dvoltage;
        updatelayers = [true true true]
        
    end
    
    methods
        
        function obj = activatob(numneurons)
        
            obj = obj@neurob(numneurons);
            obj.dvoltage = -85 * ones(1,obj.numlayers);
            
        end
        
        function initialise(obj)
            
            for l = 1:obj.numlayers
                obj.filllayer(obj.dvoltage(l), l);
            end
            
        end
        
        function update_layer(obj, l, input, resting_potential, threshold, recovery, tspike, output, cap, a, b, c, d, k,noisestd, nt, reversal, synt, quantile)
        
            if ~obj.update_layers(l)
                return
            end
        
            noise = generate_noise(obj.numneurons,noisestd);
            
            obj.update_voltage(l, input, resting_potential.array{l}, threshold.array{l}, recovery.array{l}, noise, k, cap);            
            
            obj.calc_recovery(l, recovery, resting_potential.array{l}, a, b);
            
            obj.check_spikes(l, threshold.array{l}, recovery, c, d,tspike)
            
            obj.calc_output(output, nt, quantile, tspike, synt, reversal)
                        
        end
        
        function calc_output(obj, l, op, nt, quantile, tspike, synt, rev)
        
            op.array{l} = (nt + quantile * (tspike==0) - nt./synt) .* (rev - obj.array{l});
        
        end
        
        function check_spikes(obj,l, t, rec, c, d, tspike)
        
            spiked = obj.array{l} > t;
            obj.array{l} = spiked .* c + ~spiked .* obj.array{l};
            rec.array{l} = rec.array{l} + spiked .* d;
            tspike.array{l} = (tspike.array{l} + 1) .* ~spiked;        
            
        end
        
        function update_voltage(obj, layer, i, r, t, rec, noise, k, cap)
        
            v = obj.array{layer};
            
            obj.array(layer) = v + (k .* (v - r) .* (v - t) + i + noise - rec )./ cap;
            
        end
        
        function calc_recovery(obj, l, rec, r, a, b)

            v = obj.array{layer};
            rec.array{l} = recovery + a*(b*(v - r) - rec.array{layer});
            
        end
       
    end
end