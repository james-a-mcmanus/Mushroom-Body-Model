function [voltage, recovery, timesincespike, spiked, output] = update_activation(numneurons, input, voltage, resting_potential, threshold, recovery, timesincespike, cap, a, b, c, d, k,noisestd, nt, reversal, synt, quantile, normalise, norm_factor)

    noise = generate_noise(numneurons,noisestd);
    voltage = update_voltage(input, voltage, resting_potential, threshold, recovery, noise, k, cap);
    %normalisation would go in here.
    if normalise
%         voltage = normalise_activity2(voltage,resting_potential);
%             voltage = normalise_input(norm_factor,voltage);
    end
    recovery = calc_recovery(recovery, voltage, resting_potential, a, b);
    [voltage, recovery, timesincespike, spiked] = check_spikes(voltage, threshold, recovery, c, d, timesincespike);
    output = (nt + quantile*(timesincespike==0) - nt./synt) .* (reversal - voltage);

end

function [voltage, recovery, timesincespike, spiked] = check_spikes(voltage, threshold, recovery, c, d,timesincespike)

    spiked = voltage > threshold;
    voltage = spiked .* c + ~spiked .* voltage;
    recovery = recovery + spiked.*d;
    timesincespike = (timesincespike + 1) .* ~spiked;
    
end

function new_recovery = calc_recovery(recovery, voltage, rest, a, b)

    new_recovery = recovery + a*(b*(voltage - rest) - recovery);

end

function newvoltage = update_voltage(input, current_voltage, resting_potential, threshold, recovery, noise, k, cap)

    % workout how this works for each layer.
    newvoltage = current_voltage + (k .* (current_voltage - resting_potential) .* (current_voltage - threshold) + input + noise - recovery )./ cap;

end

function noise = generate_noise(numneurons, noise_std)
    
        noise = noise_std * randn(numneurons,1);

end