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
            layerIdx = strcmp({this.Network.Layers.Name}, this.Layer);
            inSize = this.Network.Layers(1).InputSize;
            nFeatures = this.Network.Layers(layerIdx).OutputSize;
            nRegions = size(regions, 1);
            features = zeros(nRegions, nFeatures, 'single');
    
            for iRegion = 1:nRegions
                imCrop = imcrop(im, regions(iRegion, :));
                imInput = imresize(imCrop, inSize(1:2));
                featureVector = this.Network.activations(imInput, ...
                                                        this.Layer, ...
                                                        'OutputAs', 'channels');
                % TODO reshaping if required
                features(iRegion, :) = featureVector;
            end
        end
    end
end