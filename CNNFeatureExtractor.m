classdef CNNFeatureExtractor < FeatureExtractor
    
    properties
        Metadata
        Network
        Layer
    end
    
    methods
        function this = CNNFeatureExtractor(net, layer)
            this.Network = net;
            this.Layer = layer;
            this.Metadata = 'TBD';
        end
        
        function features = calculate(this, im, regions)
            inSize = this.Network.Layers(1).InputSize;
            nRegions = size(regions, 1);
            
            imCrops = zeros(inSize(1), inSize(2), 3, nRegions, 'uint8');
            for iRegion = 1:nRegions
                imCrop = imcrop(im, regions(iRegion, :));
                imCrops(:, :, :, iRegion) = imresize(imCrop, inSize(1:2));
            end
            features = this.Network.activations(imCrops, this.Layer);
        end
    end
end