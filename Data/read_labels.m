function lbls = read_labels(fname)

    file = fopen(fname);
    fread(file,8);
    lbls = fread(file);
    fclose(file);
    
end