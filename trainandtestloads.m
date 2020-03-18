%training
weights = main_low_mem(3,[784 1000 1],[10 1000], true);

reps = 20;
na = cell(reps,1);

for i = 1:reps
    %testing
    [~, na{i}] = main_low_mem(3,[784 1000 1],[10 1000], false, weights, false);
    fprintf('0');
end

themean = nan(reps,10);

for i = 1:reps
    themean(i,:) = na{i}(:,1)./na{i}(:,2); 
end

plot(mean(themean))