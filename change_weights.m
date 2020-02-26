function weights = change_weights(weights,connections,pre_time,post_time,tag,amp,da,tc,tplus)

    tag = tag + update_tag( tag, tc, pre_time, post_time, connections, amp, tplus );

    weights = weights + tag * da;
    weights ( weights < 0 ) = 0;

end

function tag = update_tag(tag, tc, pre_time, post_time, connections, amp, tplus)

    
    % problem, tag refers to synapses, pre_time etc. refers to neurons.
    newtag = tag + -tag ./ tc + stdp( pre_time, post_time, amp, tplus ) .* (( pre_time .* post_time' ) == 0);
    
    % we only want to change the weights of neurons that are actually
    % connected.
    tag = newtag.*connections;
    
end

function out = stdp(pre_time, post_time, amp, tplus)

    %tpre-tpost = post_time - pre_time;
    spike_latency = post_time' - pre_time;
    
    % note, the tag is the same whether latency is +ve or -ve, this is
    % special case of learning which is anti-hebbian, i.e. the tag is
    % always negative.     
    out = (spike_latency~=0) .* amp .* exp(spike_latency/tplus);
     
end