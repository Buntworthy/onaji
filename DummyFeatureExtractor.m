classdef DummyFeatureExtractor < FeatureExtractor
    
    properties
        Metadata = 'DummyFeatureExtractor';
    end
    
    methods
        function features = calculate(~, ~, regions)
            nRegions = size(regions, 1);
            features = rand(nRegions, 1000);
        end
    end
end