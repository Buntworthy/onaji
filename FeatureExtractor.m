classdef FeatureExtractor < handle
    
    properties (Abstract)
        Metadata
    end
    
    methods (Abstract)
        features = calculate(this, im, regions);
    end
    
end