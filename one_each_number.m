function outdata = one_each_number(training)

    outdata = data();
    outdata.images = zeros(28,28,10); outdata.labels = zeros(10,1);
    
    for i = 0:9
        
        ind = find(training.labels==i,1);
        outdata.images(:,:,i+1) = training.images(:,:,ind);
        outdata.labels(i+1) = i;
        
    end
    
    

end