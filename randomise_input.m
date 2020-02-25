function training = randomise_input(training)
    
    neworder = randperm(length(training.labels));
    
    training.labels = training.labels(neworder);
    training.images = training.images(:,:,neworder);


end