function input = normalise_input(total_activity, input)

    input = input ./ (sum(input)/total_activity);
    

end