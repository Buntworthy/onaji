classdef ImageData
	
	properties
		Root
		Network
		Layer
		Path
		Features
		Regions
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
        
        function this = calculateRegions(this, regionProposer)
            this.Regions = regionProposer(this.Image);
        end
        
        function calculateFeatures(this, network, layer)
            this.Features = extractFeatures(this.Image, this.Regions, network, layer);
            this.Network = vertcat({network.Layers.Name}');
            this.Layer = layer;
        end

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

		function im = get.Image(this)
            if isempty(this.Image_)
                this.Image_ = imread(fullfile(this.Root, this.Path));
            end
            
            im = this.Image_;
		end

	end

end