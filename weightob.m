classdef weightob < synob
    
    properties
    
        dweight = [0.25 2];
        numcons
        connections = [];
        setting = 2
        
        update = [false true false];
        
    end
    
    methods
        
        function obj = weightob(numneurons)
                
            obj@synob(numneurons);
            
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

                        w{l}(1:cons,:) = obj.dweight(l);

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
        
        function update_weights(obj,l,tspike,tag,amp,da,tc,tplus)
             
            if ~obj.update(l)
                return
            end
        
            pret = tspike.array{l-1};
            postt = tspike.array{l};
            
            
            obj.update_tag(l, tag, tc, pret, postt, obj.connections{l-1}, amp, tplus );
            
            obj.array{l} = obj.array{l} + tag * da;
            obj.array{l} ( obj.array{l} < 0 ) = 0;
            
        end
        
        function update_tag(obj, l, tag, tc, pre_time, post_time, connections, amp, tplus)
        
            tg = tag.array{l};
            tg = tg + -tg ./ tc + obj.stdp( pre_time, post_time, amp, tplus ) .* (( pre_time .* post_time' ) == 0);
            tag.array{l} = tag.array{l} + tg .* connections.array{l};
        
        end        
        
    end
    
    methods (Static)
        
        function out = stdp(pre_time, post_time, amp, tplus)

            %tpre-tpost = post_time - pre_time;
            spike_latency = post_time' - pre_time;

            % note, the tag is the same whether latency is +ve or -ve, this is
            % special case of learning which is anti-hebbian, i.e. the tag is
            % always negative.     
            out = (spike_latency~=0) .* amp .* exp(spike_latency/tplus);

        end        
        
    
    end
    
end