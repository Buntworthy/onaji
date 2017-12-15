classdef ImageDatabase < handle
    
    properties
        Images = ImageData.empty
        Root
        RegionProposer
        FeatureExtractor
    end
    
    methods
        
        function this = ImageDatabase(root, regionProposer, featureExtractor)
            this.Root = root;
            this.RegionProposer = regionProposer;
            this.FeatureExtractor = featureExtractor;
            
            this.update();
        end
        
        function update(this)
            imageFiles = util.findImages(this.Root);
            if ~isempty(this.Images)
                nonMembers = ~ismember(imageFiles, this.Images);
            else
                nonMembers = true(numel(imageFiles), 1);
            end
            for iImage = 1:numel(nonMembers)
                path = imageFiles{iImage};
                this.Images(end + 1) = ImageData(this.Root, path);
            end
            
            fprintf('Updating DB')
            for iImage = 1:numel(this.Images)
                fprintf('.');
                thisImage = this.Images(iImage);
                if isempty(thisImage.Features)
                    thisImage.calculateRegions(this.RegionProposer);
                    thisImage.calculateFeatures(this.FeatureExtractor);
                end
            end
            fprintf('done\n');
        end
        
        function result = query(this, query)
            imagesToQuery = this.Images(this.Images ~= query.Image);
             
            distances = zeros(numel(imagesToQuery), 1);
            minRegion = zeros(numel(imagesToQuery), 1);
            for iIm = 1:numel(imagesToQuery)
                iDistances = pdist2(query.Features, imagesToQuery(iIm).Features, 'cosine');
                [distances(iIm), minRegion(iIm)] = min(iDistances);
            end
            imageFilename = {imagesToQuery.Path}';
            indexes = (1:numel(this.Images))';
            indexes = indexes(this.Images ~= query.Image);
            result = table(indexes, imageFilename, distances, minRegion);
        end
        
        function close(this)
        end
        
        function save(this)
        end
        
    end
end