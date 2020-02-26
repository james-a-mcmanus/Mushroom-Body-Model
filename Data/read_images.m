function r_data = read_images(fname)


    im_w = 28;
    im_h = 28;
    
    file = fopen(fname);
    fread(file,16);
    data = fread(file);
    r_data = reshape(data,im_h,im_w,[]);
    % for some reason they are all 
    fclose(file);
    
end