function [input, num] = get_test_input(t,test,l1num,disptime,resttime,ia)

    restnow = mod(t,disptime+resttime)>disptime;
    imno = floor(t / (resttime + disptime));
    num = test.labels(imno+1);
    
    if restnow
        input = zeros(l1num,1);
        return
    else
        input = reshape(test.images(:,:,imno+1),[],1);
        input = normalise_input(ia, input);
    end
    
end