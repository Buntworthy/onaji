classdef ImageDatabase < handle
    
    properties
        Images
        Root
    end
    
    methods
        
        function this = ImageDatabase(root)
            % find all the images in root
            % Create new ImageData objects where required
        end
        
        function update(this)
            % Loop over the Images
            % Check if the features are extracted by the correct network
            % and layer
            % Extract features if not/missing
        end
        
        function query(this, queryImage)
        end
        
    end
end