for i = 1:60000
    image(fliplr(rot90(ims(:,:,i),3)));
    disp(lbls(i))
    waitforbuttonpress
end
