function [input, num, ba] = get_input(t,training,l1num,disptime,resttime,ia,rn)

    ba = 0;
    restnow = mod(t,disptime+resttime)>disptime;
    imno = floor(t / (resttime + disptime));
    num = training.labels(imno+1);
    
    if restnow
        input = zeros(l1num,1);
        if mod(t,disptime+resttime) - disptime == 1 && rn == num
            ba = 6;
        end
        return
    else
        input = reshape(training.images(:,:,imno+1),[],1);
        input = normalise_input(ia, input);
    end
    
end