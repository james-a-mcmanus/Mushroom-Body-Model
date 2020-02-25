classdef data
   
    properties
        folder
        images
        labels
    end
    
    methods
        
        function obj = data(folder)
            
            obj.folder = folder;
            im_file = dir([folder '*image*']);
            lbl_file = dir([folder '*labels*']);
            obj.images = read_images(im_file.name);
            obj.labels = read_labels(lbl_file.name);
            
        end 
        
        
    end
    
end