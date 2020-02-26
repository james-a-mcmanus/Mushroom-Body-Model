classdef data
   
    properties
        folder
        images
        labels
    end
    
    methods
        
        function obj = data(folder)
            
            if nargin > 0
                obj.folder = folder;
                im_file = dir([folder '*image*']);
                lbl_file = dir([folder '*labels*']);
                obj.images = read_images([folder im_file.name]);
                obj.labels = read_labels([folder lbl_file.name]);
            end
            
            
        end 
        
        
    end
    
end