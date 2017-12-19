classdef MultiImageQuery < handle
    
    properties
        ImRegionTable
        Metadata
    end
    
    properties (Dependent)
        Features
        Image
    end
    
    methods
        function this = MultiImageQuery(imRegionTable, metadata)
            this.ImRegionTable = imRegionTable;
            this.Metadata = metadata;
        end
    end
    
    methods
        function images = get.Image(this)
            images = this.ImRegionTable{:,1};
        end
        
        function features = get.Features(this)
            features = [];
            for iIm = 1:height(this.ImRegionTable)
                regionIdx = this.ImRegionTable{iIm, 2};
                im = this.ImRegionTable{iIm, 1};
                iFeatures = im.Features(regionIdx, :);
                features = [features;  iFeatures];
            end
        end
    end
    
end