classdef ImageData < handle
	
	properties
		Root
        Metadata
		Path
		Features
		Regions
        RegionProposer
        FeatureExtractor
	end

	properties (Dependent)
		Image
    end
    
    properties (Transient)
        Image_
    end

	methods

		function this = ImageData(root, path)
            % TODO validate image
            this.Root = root;
            this.Path = path;
        end
        
        function calculateRegions(this, regionProposer)
            this.RegionProposer = regionProposer;
            this.Regions = regionProposer.calculate(this.Image);
        end
        
        function calculateFeatures(this, featureExtractor)
            this.FeatureExtractor = featureExtractor;
            this.Features = featureExtractor.calculate(this.Image, this.Regions);
            this.Metadata = featureExtractor.Metadata;
        end
        
        function idx = addRegion(this, region)
            idx = size(this.Regions, 1) + 1;
            this.Regions(idx, :) = region;
            
            if ~isempty(this.FeatureExtractor)
                this.Features(idx, :) = ...
                    this.FeatureExtractor.calculate(this.Image, region);
            end
        end

        function tf = eq(this, other)
            if ischar(other)
                tf = strcmpi(other, this.Path);
            else
                tf = eq@handle(this, other);
            end
        end

        %% Plotting methods
		function show(this)
			f = figure();
			imshow(this.Image);
        end
        
        function showRegions(this, regionIndexes)

			if isempty(regionIndexes)
				regionIndexes = 1:size(this.Regions, 1);
			end

			im = this.Image;
			for iRegion = 1:numel(regionIndexes)
				region = this.Regions(regionIndexes(iRegion), :);
				im = insertObjectAnnotation(im, 'rectangle', ...
											region, '', ...
											'LineWidth', 5, ...
                                            'Color', 255*rand(1, 3));
			end
			imshow(im)
        end
        
        function showRegionHeatmap(this, regionIndexes)
            if isempty(regionIndexes)
				regionIndexes = 1:size(this.Regions, 1);
			end

			im = this.Image;
            imSize = size(im);
            imHeatmap = zeros(imSize(1), imSize(2));
			for iRegion = 1:numel(regionIndexes)
				region = this.Regions(regionIndexes(iRegion), :);
				imHeatmap(region(2):region(2) + region(4), ...
                          region(1):region(1) + region(3)) = ...
                             imHeatmap(region(2):region(2) + region(4), ...
                                        region(1):region(1) + region(3)) + 1;
            end
            imshowpair(im, imHeatmap, 'montage')
%             imFused = imfuse(im, imHeatmap);
% 			imshow(imFused)
        end

		function im = get.Image(this)
            if isempty(this.Image_)
                this.Image_ = imread(fullfile(this.Root, this.Path));
            end
            
            im = this.Image_;
		end

	end

end