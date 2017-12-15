classdef Query < handle
    
    properties
        Image
        RegionIdxs
        Metadata
    end
    
    properties (Dependent)
        Features
    end
    
    methods (Static)
        function this = fromImageRegion(imageData, regionIdxs)
            this = Query(imageData, ...
                            regionIdxs, ...
                            imageData.Metadata);
        end
        
        function this = fromNewImageRegion(imageData)
            imageData.show();
            region = getrect();
            regionIdxs = imageData.addRegion(region);
            this = Query(imageData, ...
                            regionIdxs, ...
                            imageData.Metadata);
        end
    end
    
    methods
        function this = Query(im, regionIdxs, metadata)
            this.Image = im;
            this.RegionIdxs = regionIdxs;
            this.Metadata = metadata;
        end
    end
    
    methods
        function features = get.Features(this)
            features = this.Image.Features(this.RegionIdxs, :);
        end
    end
    
end