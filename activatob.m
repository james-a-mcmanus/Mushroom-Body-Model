classdef activatob < neurob
    
    properties
        
        dvoltage % = [-60 -85 -60];
        update
        
    end
    
    methods
        
        function obj = activatob(numneurons)
        
            obj = obj@neurob(numneurons);
            obj.update = repelem(true, obj.numlayers);
            obj.dvoltage = repelem(-85, obj.numlayers);
            
        end
        
        function initialise(obj)
            
            for l = 1:obj.numlayers
                obj.filllayer(obj.dvoltage(l), l);
            end
            
        end
        
        function update_activation(obj, l, input, threshold, recovery, tspike, output, cap, a, b, c, d, k,noisestd, nt, reversal, synt, quantile)
        
            if ~obj.update(l)
                return
            end
        
            noise = obj.generate_noise(obj.numneurons(l),noisestd);
            
            obj.update_voltage(l, input, obj.dvoltage(l), threshold(l), recovery.array{l}, noise, k, cap);            
            
            obj.calc_recovery(l, recovery, obj.dvoltage(l), a, b);
            
            obj.check_spikes(l, threshold(l), recovery, c, d,tspike)
            
            obj.calc_output(l, output, nt.array{l}, quantile, tspike.array{l}, synt, reversal.array{l})
                        
            
        end
        
        function calc_output(obj, l, op, nt, quantile, tspike, synt, rev)
        
            op.array{l} = (nt + quantile * (tspike==0) - nt./synt) .* (rev - obj.array{l});
        
        end
        
        function check_spikes(obj,l, t, rec, c, d, tspike)
        
            tspike.spiked{l} = obj.array{l} > t;
            obj.array{l} = tspike.spiked{l} .* c + ~tspike.spiked{l} .* obj.array{l};
            rec.array{l} = rec.array{l} + tspike.spiked{l} .* d;
            tspike.array{l} = (tspike.array{l} + 1) .* ~tspike.spiked{l};        
            
        end
        
        function update_voltage(obj, layer, i, r, t, rec, noise, k, cap)
        
            v = obj.array{layer};
            
            obj.array{layer} = v + (k .* (v - r) .* (v - t) + i + noise - rec )./ cap;
            
        end
        
        function calc_recovery(obj, l, rec, r, a, b)

            v = obj.array{l};
            rec.array{l} = rec.array{l} + a*(b*(v - r) - rec.array{l});
            
        end
       
        function normalise(obj)
        
            
        
        end
        
        
    end
    
    methods (Static)
    
        function noise = generate_noise(numneurons, noise_std)
    
            noise = noise_std * randn(numneurons,1);

        end
        
    end
end