classdef Query < handle
    
    properties
        Image
        Features
        Metadata
    end
    
    methods (Static)
        function this = fromImageRegion(imageData, regionIdx)
            this = Query(imageData, ...
                            imageData.Features(regionIdx, :), ...
                            imageData.Metadata);
        end
    end
    
    methods
        
        function this = Query(im, features, metadata)
            this.Image = im;
            this.Features = features;
            this.Metadata = metadata;
        end
        
    end
    
end