function out = testingmatrixmult()

    a = randn(1000,1000);
    n = 100;
    tic
    for i = 1:n
       (1+a)*a;
    end
    out = toc/n;
    
end

function multip(a,b)

    for i = 1:10
        r = a*b;
    end

end


