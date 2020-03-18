%training
weights = main_low_mem(3,[784 1000 1],[10 1000], true);

%testing
[~, na] = main_low_mem(3,[784 1000 1],[10 1000], false, weights, false);

plot(0:9,na(:,1)./na(:,2)); 
